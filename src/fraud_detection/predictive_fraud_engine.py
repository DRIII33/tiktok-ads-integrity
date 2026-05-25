import os
import numpy as np
import pandas as pd

from sklearn.model_selection import train_test_split

from sklearn.experimental import enable_iterative_imputer
from sklearn.impute import IterativeImputer

from xgboost import XGBClassifier

from sklearn.metrics import (
    classification_report,
    roc_auc_score
)

# =========================================================================
# LOAD DATASET
# =========================================================================

RANDOM_SEED = 42

df = pd.read_csv("synthetic_ads_integrity_dataset.csv")

# =========================================================================
# FEATURE DEFINITIONS
# =========================================================================

numerical_features = [
    'spend_usd',
    'click_count',
    'ttr_seconds',
    'historical_trust_score'
]

categorical_features = [
    'is_ai_generated_creative'
]

X = df[
    numerical_features
    + categorical_features
    + [
        'ad_caption',
        'postal_code',
        'network_type',
        'region_id',
        'ad_id',
        'advertiser_id'
    ]
]

y = df['is_scam']

# =========================================================================
# TRAIN / TEST SPLIT
# =========================================================================

print("[SYSTEM] Partitioning train and test layers...")

X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.20,
    stratify=y,
    random_state=RANDOM_SEED
)

X_train = X_train.copy()
X_test = X_test.copy()

# =========================================================================
# MICE IMPUTATION
# =========================================================================

print("[SYSTEM] Executing MICE imputation pipeline...")

mice_imputer = IterativeImputer(
    max_iter=10,
    initial_strategy='mean',
    random_state=RANDOM_SEED
)

X_train[numerical_features] = mice_imputer.fit_transform(
    X_train[numerical_features]
)

X_test[numerical_features] = mice_imputer.transform(
    X_test[numerical_features]
)

X_train['historical_trust_score'] = np.clip(
    X_train['historical_trust_score'],
    0.0,
    1.0
)

X_test['historical_trust_score'] = np.clip(
    X_test['historical_trust_score'],
    0.0,
    1.0
)

# =========================================================================
# NLP FEATURE IMPORT
# =========================================================================

from sklearn.feature_extraction.text import TfidfVectorizer

tfidf_vectorizer = TfidfVectorizer(
    max_features=5,
    ngram_range=(1, 2),
    stop_words='english'
)

train_nlp_sparse = tfidf_vectorizer.fit_transform(
    X_train['ad_caption']
).toarray()

test_nlp_sparse = tfidf_vectorizer.transform(
    X_test['ad_caption']
).toarray()

nlp_feature_names = [
    f"nlp_token_{word.replace(' ', '_')}"
    for word in tfidf_vectorizer.get_feature_names_out()
]

train_nlp_df = pd.DataFrame(
    train_nlp_sparse,
    columns=nlp_feature_names,
    index=X_train.index
)

test_nlp_df = pd.DataFrame(
    test_nlp_sparse,
    columns=nlp_feature_names,
    index=X_test.index
)

X_train = pd.concat(
    [X_train, train_nlp_df],
    axis=1
)

X_test = pd.concat(
    [X_test, test_nlp_df],
    axis=1
)

# =========================================================================
# MODEL TRAINING
# =========================================================================

print("[SYSTEM] Optimizing XGBoost Risk Engine...")

model_features = (
    numerical_features
    + categorical_features
    + nlp_feature_names
)

class_ratio = (
    len(y_train[y_train == 0])
    / len(y_train[y_train == 1])
)

risk_engine = XGBClassifier(
    n_estimators=200,
    learning_rate=0.05,
    max_depth=6,
    scale_pos_weight=class_ratio,
    random_state=RANDOM_SEED,
    eval_metric='logloss'
)

risk_engine.fit(
    X_train[model_features],
    y_train
)

# =========================================================================
# MODEL EVALUATION
# =========================================================================

predictions = risk_engine.predict(
    X_test[model_features]
)

prediction_probabilities = risk_engine.predict_proba(
    X_test[model_features]
)[:, 1]

print("\n" + "=" * 60)

print("     MAY 2026 REGULATORY DSA AUDIT INTEGRITY METRIC REPORT     ")

print("=" * 60)

print(
    classification_report(
        y_test,
        predictions,
        target_names=[
            'Clean Ad Asset',
            'Scam Matrix Threat'
        ]
    )
)

print(
    f"Area Under the ROC Curve (ROC-AUC) Performance: "
    f"{roc_auc_score(y_test, prediction_probabilities):.4f}"
)

print("=" * 60)

# =========================================================================
# EXPORT MODEL-READY DATASET
# =========================================================================

train_final = pd.concat(
    [X_train, y_train],
    axis=1
)

test_final = pd.concat(
    [X_test, y_test],
    axis=1
)

df_final = pd.concat(
    [train_final, test_final],
    axis=0
).sort_index()

df_final_export = df_final.drop(
    columns=['ad_caption']
)

output_path = "integrity_risk_dataset_2026.csv"

df_final_export.to_csv(
    output_path,
    index=False
)

print(
    f"[SUCCESS] Export pipeline terminated. "
    f"Production output housed at: {os.path.abspath(output_path)}"
)
