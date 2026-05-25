/*
========================================================================================
PROJECT: DATA LAKE LOGIC PIPELINE FOR NETWORK MONETIZATION FRAUD
OBJECTIVE: ISOLATE ADRESSED PANGLE BOTNETS RUNNING REAL NLP METRIC SCENARIOS
DIALECT: GOOGLE BIGQUERY SQL
========================================================================================
*/

WITH TrafficAggregation AS (
  SELECT
    advertiser_id,
    network_type,
    region_id,
    COUNT(ad_id) AS total_ad_install_events,
    
    -- Track invalid traffic markers via sub-second installation times (Click Injections)
    COUNTIF(ttr_seconds < 1.0) AS automated_injection_clicks,
    
    -- Evaluate cumulative linguistic threat exposure across profiles
    SUM(nlp_token_urgent + nlp_token_guaranteed + nlp_token_click) AS cumulative_nlp_scam_weight,
    
    -- Monitor unlabeled AI generation activity in suspect channels
    COUNTIF(is_ai_generated_creative = 1 AND is_scam = 1) AS flagged_ai_scam_ads,
    AVG(spend_usd) AS average_spend_pool,
    MIN(historical_trust_score) AS minimum_observed_trust
  FROM
    `driiiportfolio.ads_integrity_srv.raw_attribution_logs`
  GROUP BY
    1, 2, 3
),

RiskAttributionAnalytics AS (
  SELECT
    advertiser_id,
    network_type,
    region_id,
    total_ad_install_events,
    automated_injection_clicks,
    cumulative_nlp_scam_weight,
    flagged_ai_scam_ads,
    average_spend_pool,
    minimum_observed_trust,
    
    -- Calculate operational ratio indicators safely to protect against zero division errors
    SAFE_DIVIDE(automated_injection_clicks, total_ad_install_events) AS attribution_fraud_ratio,
    SAFE_DIVIDE(cumulative_nlp_scam_weight, total_ad_install_events) AS localized_nlp_risk_density
  FROM
    TrafficAggregation
)

SELECT
  advertiser_id,
  network_type,
  region_id,
  total_ad_install_events,
  automated_injection_clicks,
  ROUND(attribution_fraud_ratio * 100, 2) AS fraud_percentage,
  ROUND(localized_nlp_risk_density, 4) AS nlp_risk_density_score,
  ROUND(average_spend_pool, 2) AS average_spend_pool,
  
  -- Structural threat ranking matches May 2026 verified platform specifications
  CASE
    WHEN network_type = 'Pangle_Network' AND attribution_fraud_ratio >= 0.242 THEN 'CRITICAL: CO-ORDINATED PANGLE BOTNET'
    WHEN attribution_fraud_ratio > 0.15 AND localized_nlp_risk_density > 0.05 THEN 'HIGH RISK: AUTOMATED NLP FRAUD ENGINE'
    WHEN attribution_fraud_ratio > 0.10 THEN 'MEDIUM RISK: ATTRIBUTION CLAMP ESCAPE'
    ELSE 'COMPLIANT: VERIFIED TRUSTED CHANNEL'
  END AS ecosystem_risk_classification
FROM
  RiskAttributionAnalytics
WHERE
  total_ad_install_events >= 5
ORDER BY
  fraud_percentage DESC,
  nlp_risk_density_score DESC;
