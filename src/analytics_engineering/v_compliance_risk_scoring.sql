CREATE OR REPLACE VIEW `driiiportfolio.ads_integrity_srv.vw_compliance_risk_scoring` AS
SELECT
  ad_id,
  advertiser_id,
  network_type,
  region_id,
  postal_code, -- Preserved explicitly for geographic map layers
  spend_usd,
  click_count,
  ttr_seconds,
  is_ai_generated_creative,
  historical_trust_score,
  is_scam,
  (nlp_token_2hours + nlp_token_click + nlp_token_fast + nlp_token_guaranteed + nlp_token_urgent) AS total_nlp_scam_weight,
  
  -- Generate precise classification descriptions for leadership dashboard panels
  CASE
    WHEN is_scam = 1 AND is_ai_generated_creative = 1 THEN 'Unlabeled AI Deceptive Ad'
    WHEN is_scam = 1 THEN 'Verified Policy Scam Copy'
    WHEN network_type = 'Pangle_Network' AND ttr_seconds < 1.0 THEN 'Pangle Click Injection Botnet'
    WHEN ttr_seconds < 1.0 THEN 'Standard Attribution Fraud Injection'
    ELSE 'Approved Secure Asset Layer'
  END AS threat_type_classification,
  
  -- Calculate active financial exposure risk pools (Budget-at-Risk Monitoring)
  CASE
    WHEN is_scam = 1 OR ttr_seconds < 1.0 THEN spend_usd
    ELSE 0.0
  END AS budget_at_risk_usd
FROM
  `driiiportfolio.ads_integrity_srv.raw_attribution_logs`;
