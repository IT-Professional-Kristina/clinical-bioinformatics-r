# ===================================================
# PROJECT:Clinical Bioinformatics Analysis Suite
# MODULE 2: Data Wrangling with dplyr
# Script: 02_dplyr_wrangling.R
# Author: Kristina Ankrah
# Purpose: Clean, filter, sort and summarize the variant dataset
#       using dplyr - the standard tool for clinical data pipelines
# =================================================================

# Load dplyr - do this at the top of every script that uses it
library(dplyr)

# Load the variant data from CSV - always read from file, not from memory
variants_df <- read.csv(
  "data/raw/variants.csv",
  stringsAsFactors = FALSE
)
nrow(variants_df)

# _____VERB 1: filter() - keep rows meeting a condition_________________________
high_vaf <- filter(variants_df, vaf > 0.40)
high_vaf

#______VERB 2: select() ____choose specific columns_____________________________
report_cols <- select(variants_df, gene, variant, vaf, cancer_type)
report_cols

sorted_vaf_desc <- arrange(variants_df, desc(vaf))
sorted_vaf_desc
# ____VERB 4: mutate() _____add a new calculated column________________________
variants_classified <- mutate(
  variants_df,
  vaf_category = case_when(
    vaf >= 0.50 ~ "High",
    vaf >= 0.35 ~ "Moderate",
    vaf < 0.35 ~ "Low"
  )
)
select(variants_classified, gene, variant, vaf, vaf_category)

# ── VERB 5: group_by() + summarise() — grouped statistics ────────────────────

# Clinical question: how do oncogenes compare to tumor suppressors?
# group_by splits the data into two invisible groups: TRUE and FALSE
# summarise collapses each group into one summary row

oncogene_summary <- variants_df %>%
  group_by(oncogene) %>%
  summarise(
    count        = n(),
    mean_vaf     = round(mean(vaf), 3),
    max_vaf      = max(vaf),
    min_vaf      = min(vaf),
    .groups = "drop"
  )

oncogene_summary


