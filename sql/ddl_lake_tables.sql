-- Project Cloud Target: driiiportfolio
-- Dataset Location Reference: ads_integrity_srv
CREATE OR REPLACE TABLE `driiiportfolio.ads_integrity_srv.raw_attribution_logs` (
    ad_id INT64 OPTIONS(description="Primary system key tracking the unique advertisement entity"),
    advertiser_id INT64 OPTIONS(description="Enterprise system key tracking the registered commercial client"),
    network_type STRING OPTIONS(description="Traffic delivery vector classification (e.g., Pangle_Network, TikTok_InApp)"),
    region_id STRING OPTIONS(description="Compliance zone tracker mapping data back to GLOBAL_CORE or USDS_JV nodes"),
    postal_code STRING OPTIONS(description="Granular geographic postal boundary key utilized for spatial risk mapping"),
    spend_usd FLOAT64 OPTIONS(description="Total capital ad budget currency pool deployed by the account"),
    click_count INT64 OPTIONS(description="Accumulated consumer interactive ad click logs"),
    ttr_seconds FLOAT64 OPTIONS(description="Time-To-Record latency metric mapping download registration velocity"),
    is_ai_generated_creative INT64 OPTIONS(description="Binary flag indexing whether generative artificial media was used"),
    historical_trust_score FLOAT64 OPTIONS(description="MICE-reconstructed continuous credit validation metric"),
    nlp_token_2hours FLOAT64 OPTIONS(description="TF-IDF continuous weight metric isolating phrase '2hours'"),
    nlp_token_click FLOAT64 OPTIONS(description="TF-IDF continuous weight metric isolating phrase 'click'"),
    nlp_token_fast FLOAT64 OPTIONS(description="TF-IDF continuous weight metric isolating phrase 'fast'"),
    nlp_token_guaranteed FLOAT64 OPTIONS(description="TF-IDF continuous weight metric isolating phrase 'guaranteed'"),
    nlp_token_urgent FLOAT64 OPTIONS(description="TF-IDF continuous weight metric isolating phrase 'urgent'"),
    is_scam INT64 OPTIONS(description="Ecosystem classification risk target output parameter")
);
