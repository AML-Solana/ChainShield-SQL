WITH TransactionFlow AS (
    SELECT 
        t.block_time,
        t.tx_hash,
        t."from" AS sender_address,
        t."to" AS receiver_address,
        t.amount_usd,
        LEAD(t.block_time) OVER (PARTITION BY t."to" ORDER BY t.block_time) AS next_outbound_time,
        LEAD(t."to") OVER (PARTITION BY t."to" ORDER BY t.block_time) AS next_destination_wallet,
        LEAD(t.amount_usd) OVER (PARTITION BY t."to" ORDER BY t.block_time) AS next_outbound_amount
    FROM tokens.transfers t
    WHERE t.blockchain = 'ethereum'
      AND t.symbol = 'USDT'
      AND t.block_time > now() - interval '12' hour
),

typology_b_alerts_raw AS (
    SELECT 
        tf.receiver_address AS wallet_address,
        tf.amount_usd AS transaction_value,
        tf.block_time AS tx_time,
        1 AS is_peeling_hop,
        CASE WHEN mod(cast(tf.amount_usd as bigint), 1000) = 0 THEN 1 ELSE 0 END AS is_round_number
    FROM TransactionFlow tf
    WHERE tf.next_outbound_time IS NOT NULL
      AND date_diff('second', tf.block_time, tf.next_outbound_time) <= 300 
      AND (tf.next_outbound_amount / tf.amount_usd) BETWEEN 0.90 AND 1.00 
      AND tf.amount_usd > 50000 
),

filtered_alerts AS (
    SELECT 
        r.*
    FROM typology_b_alerts_raw r
    LEFT JOIN labels.addresses lbl 
        ON r.wallet_address = lbl.address
    WHERE (lbl.name IS NULL OR (
            lower(lbl.name) NOT LIKE '%uniswap%'
            AND lower(lbl.name) NOT LIKE '%morpho%'
            AND lower(lbl.name) NOT LIKE '%curve%'
            AND lower(lbl.name) NOT LIKE '%aave%'
            AND lower(lbl.name) NOT LIKE '%router%'
            AND lower(lbl.name) NOT LIKE '%bridge%'
            AND lower(lbl.category) NOT IN ('dex', 'defi', 'cex')
       ))
       -- Hard exclusion list for verified core infrastructure protocols missing metadata labels
       AND r.wallet_address NOT IN (
            0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb, -- Morpho Blue Core
            0x3ee18b2214aff97000d974cf647e7c347e8fa585, -- Wormhole TokenBridge Router
            0x4e5b2e1dc63f6b91cb6cd759936495434c7e972f  -- Canonical Create2 Deployer proxy
       )
),

risk_scoring AS (
    SELECT 
        wallet_address,
        COUNT(tx_time) AS total_flagged_events,
        MAX(transaction_value) AS max_single_value,
        MAX(is_peeling_hop) AS triggered_peeling,
        MAX(is_round_number) AS triggered_round_num,
        
        (MAX(is_peeling_hop) * 40) + 
        (CASE WHEN MAX(transaction_value) >= 500000 THEN 30 ELSE 0 END) +
        (MAX(is_round_number) * 10) +
        (CASE WHEN COUNT(tx_time) >= 3 THEN 20 ELSE 0 END) AS final_risk_score
    FROM filtered_alerts
    GROUP BY wallet_address
)

SELECT 
    wallet_address,
    total_flagged_events,
    max_single_value,
    final_risk_score,
    CASE 
        WHEN final_risk_score >= 70 THEN '🔴 CRITICAL RISK (Immediate Enforcement)'
        WHEN final_risk_score >= 40 THEN '🟡 MEDIUM RISK (Enhanced Monitoring)'
        ELSE '🟢 LOW RISK (Routine Review)'
    END AS risk_tier
FROM risk_scoring
ORDER BY final_risk_score DESC, max_single_value DESC
LIMIT 20;
