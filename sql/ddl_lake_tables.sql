/*
========================================================================================
PROJECT: DATA PRIVACY & COMPLIANCE ACCESS POLICIES (TIKTOK USDS JOINT VENTURE)
OBJECTIVE: ENFORCE ROLE-BASED ACCESS CONTROLS ON FEDERATED DATA SERVICES
DIALECT: GOOGLE BIGQUERY SQL SECURITY
========================================================================================
*/

-- 1. Enforce strict data minimization rules for international trust operations
GRANT `roles/bigquery.dataViewer`
ON SCHEMA `driiiportfolio.ads_integrity_srv`
TO "user:emea-integrity-escalations@tiktok.com";

-- 2. Restrict visibility of secure federal data assets to approved domestic personnel
GRANT `roles/bigquery.admin`
ON TABLE `driiiportfolio.ads_integrity_srv.vw_federated_dsa_reporting`
TO "user:usds-trust-safety@tiktok.com";

-- 3. Revoke generalized query access over raw system click logs to prevent cross-border data leakage
REVOKE `roles/bigquery.dataViewer`
ON TABLE `driiiportfolio.ads_integrity_srv.raw_attribution_logs`
FROM "user:global_core_analyst@tiktok.com";
