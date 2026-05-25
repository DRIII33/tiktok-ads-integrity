/*
========================================================================================
PROJECT: TRANSFORMATION AND SECURITY LOGIC LAYER (BIGQUERY CORE)
OBJECTIVE: AGGREGATE POLICY METRICS AND BUILD VW_FEDERATED_DSA_REPORTING
DIALECT: GOOGLE BIGQUERY SQL STANDARD
========================================================================================
*/

CREATE OR REPLACE VIEW `driiiportfolio.ads_integrity_srv.vw_federated_dsa_reporting` AS
SELECT
  ad_id,
  advertiser_id,
  network_type,
  region_id,
  postal_code,
  spend_usd,
  click_count,
  ttr_seconds,
  is_ai_generated_creative,
  historical_trust_score,
  is_scam,
  
  -- Calculate structural text mining score based on continuous weights
  (nlp_token_2hours + nlp_token_click + nlp_token_fast + nlp_token_guaranteed + nlp_token_urgent) AS total_nlp_scam_weight,
  
  -- Algorithmic threat vector separation logic
  CASE
    WHEN ttr_seconds < 1.0 AND network_type = 'Pangle_Network' THEN 'Pangle Click Injection Botnet'
    WHEN ttr_seconds < 1.0 THEN 'Standard Attribution Fraud Injection'
    WHEN is_scam = 1 AND is_ai_generated_creative = 1 THEN 'Deceptive Generative Media Campaign'
    WHEN is_scam = 1 THEN 'Policy Evasion Scam Matrix Asset'
    ELSE 'Approved Secure Asset Layer'
  END AS threat_type_classification,
  
  -- Quantify the immediate financial exposure 
  CASE 
    WHEN ttr_seconds < 1.0 OR is_scam = 1 THEN spend_usd
    ELSE 0.0
  END AS budget_at_risk_usd,
  
  -- Enforce geopolitical regulatory mapping boundaries
  CASE
    WHEN region_id = 'USDS_JV' THEN 'United States Domestic'
    ELSE 'European Union (Eurozone)'
  END AS geo_jurisdiction,
  
  -- Dynamically assign DSA enforcement priorities
  CASE
    WHEN region_id = 'GLOBAL_CORE' AND (is_scam = 1 OR ttr_seconds < 1.0) THEN 'Tier-1 VLOP (6% Revenue Fine Scope)'
    WHEN region_id = 'GLOBAL_CORE' THEN 'Tier-2 Baseline Regional Compliance'
    ELSE 'Custom Federal Cloud Ringfence'
  END AS dsa_audit_tier,
  
  -- Define localized platform safety alert flags
  CASE 
    WHEN region_id = 'GLOBAL_CORE' THEN '0.0350'
    ELSE '0.0500'
  END AS max_allowed_ivt_pct,
  
  -- Provision cross-functional escalation communication points
  CASE
    WHEN region_id = 'USDS_JV' THEN 'usds-trust-safety@tiktok.com'
    ELSE 'emea-integrity-escalations@tiktok.com'
  END AS emergency_escalation_email,
  
  -- Compute binary alert flags for Looker Studio KPI logic triggers
  CASE
    WHEN region_id = 'GLOBAL_CORE' AND ttr_seconds < 1.0 THEN 1
    ELSE 0
  END AS is_regulatory_breach_alert

FROM
  `driiiportfolio.ads_integrity_srv.raw_attribution_logs`;
