# Enterprise Ads Integrity & Regulatory Compliance Architecture
**Target Role:** TikTok - Risk Analyst (Global Operations / Ads Integrity) 
**Location Focus:** Austin, TX / Waco, TX  
**Temporal Validity & Data Baseline:** Current as of May 2026  
**Prepared by:** Daniel Rodriguez III 

---

## 1. Executive Briefing & Project Architecture

### Core Business Challenges
This repository houses an end-to-end analytical data framework built to protect TikTok’s ad ecosystem from multi-vector ad fraud and systemic regulatory compliance risks. It solves three critical operational challenges:
1. **Severe Regulatory Fine Exposure (EU DSA):** Financial advertisements deploying deceptive or policy-evading linguistic copy routinely bypass traditional automated keyword filters, exposing the platform to severe non-compliance penalties under the EU Digital Services Act (DSA) of up to 6% of global annual turnover for Very Large Online Platforms (VLOPs).
2. **Ad Budget Attrition via Publisher Botnets:** Coordinated botnets operating on third-party channels like the **Pangle Network** generate an **average invalid traffic (IVT) rate of 24.2%**, spiking up to **29.4% fraud rates** in unchecked clusters. These botnets exploit software development kits (SDKs) to execute sub-second "Click Injections" right before genuine app installs, draining valid advertiser budgets and driving critical client churn.
3. **Cross-Entity Data Fragmentation (USDS JV vs. Global Core):** Data minimized and anonymized in transit between the domestic **USDS Joint Venture** cloud ringfence and the **Global Core** registry results in missing historical metrics. Standard risk detection models suffer from extreme selection bias when up to 40% of localized advertiser trust indicators are dropped.

### Technical Objective & Architecture
To act as a zero-latency Risk Analyst, this framework establishes a robust, privacy-compliant data loop across Python/Sklearn, Google BigQuery, and Looker Studio.
