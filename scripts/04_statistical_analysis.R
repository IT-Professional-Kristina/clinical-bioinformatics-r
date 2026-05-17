# =============================================================================
# PROJECT: Mayo Clinic Clinical Bioinformatics Analysis Suite
# MODULE 4: Statistical Analysis
# Script:  04_statistical_analysis.R
# Author:  Kristina Ankrah
# Purpose: Descriptive statistics and group comparisons
#          demonstrating clinical statistical programming methods
# =============================================================================

library(dplyr)

# Load variant data
variants_df <- read.csv(
  "data/raw/variants.csv",
  stringsAsFactors = FALSE
)

message(paste("Variants loaded:", nrow(variants_df)))

# ── SECTION 1: Descriptive Statistics ────────────────────────────────────────
# These are the summary statistics that appear in the first table
# of every clinical genomics publication — often called "Table 1"

overall_stats <- variants_df %>%
  summarise(
    n            = n(),
    mean_vaf     = round(mean(vaf), 3),
    median_vaf   = round(median(vaf), 3),
    sd_vaf       = round(sd(vaf), 3),
    min_vaf      = min(vaf),
    max_vaf      = max(vaf),
    range_vaf    = round(max(vaf) - min(vaf), 3)
  )

print(overall_stats)
# ── SECTION 2: Statistics by Gene Type ───────────────────────────────────────
# Compare oncogenes vs tumor suppressors — the key clinical grouping

group_stats <- variants_df %>%
  group_by(oncogene) %>%
  summarise(
    gene_type  = ifelse(first(oncogene), "Oncogene", "Tumor Suppressor"),
    n          = n(),
    mean_vaf   = round(mean(vaf), 3),
    median_vaf = round(median(vaf), 3),
    sd_vaf     = round(sd(vaf), 3),
    min_vaf    = min(vaf),
    max_vaf    = max(vaf),
    .groups    = "drop"
  )

print(group_stats, width = Inf)

# ── SECTION 3: Statistical Comparison — VAF by Gene Type ─────────────────────
# The Wilcoxon rank-sum test compares two groups without assuming
# the data follows a normal distribution. It is preferred over
# a t-test when sample sizes are small (which ours are — n=4 vs n=2).
#
# IMPORTANT CLINICAL NOTE: With only 6 total variants, this test
# has very low statistical power. In a real pipeline this would run
# on hundreds of variants. We are demonstrating the METHODOLOGY.

wilcox_result <- wilcox.test(
  vaf ~ oncogene,
  data    = variants_df,
  exact   = FALSE
)

# Print the test result
print(wilcox_result)

# Extract and interpret the p-value
p_value <- round(wilcox_result$p.value, 4)
message(paste("Wilcoxon p-value:", p_value))

if (p_value < 0.05) {
  message("Result: Statistically significant difference in VAF between groups")
} else {
  message("Result: No statistically significant difference detected")
  message("Note: Low power due to small sample size — larger dataset needed")
}
# ── SECTION 4: Save Statistical Results ──────────────────────────────────────
write.csv(overall_stats, "output/overall_statistics.csv", row.names = FALSE)
write.csv(group_stats,   "output/group_statistics.csv",   row.names = FALSE)
message("Statistical results saved to output/")
