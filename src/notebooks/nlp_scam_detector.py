import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer

df = pd.read_csv("synthetic_ads_integrity_dataset.csv")

df.head()

tfidf_vectorizer = TfidfVectorizer(
    max_features=5,
    ngram_range=(1, 2),
    stop_words='english'
)

nlp_sparse = tfidf_vectorizer.fit_transform(
    df['ad_caption']
).toarray()

nlp_feature_names = [
    f"nlp_token_{word.replace(' ', '_')}"
    for word in tfidf_vectorizer.get_feature_names_out()
]

nlp_df = pd.DataFrame(
    nlp_sparse,
    columns=nlp_feature_names
)

nlp_df.head()

df_nlp = pd.concat(
    [df, nlp_df],
    axis=1
)

df_nlp.head()

df_nlp.to_csv(
    "nlp_enriched_ads_dataset.csv",
    index=False
)

print("[SUCCESS] NLP enriched dataset exported.")
