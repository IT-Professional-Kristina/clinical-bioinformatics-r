# =============================================================================
# PROJECT: Mayo Clinic Clinical Bioinformatics Analysis Suite
# MODULE 3: Visualization with ggplot2
# Script:  03_visualization.R
# Author:  Kristina Ankrah
# Purpose: Build publication-quality clinical figures from variant data
# =============================================================================

library(dplyr)
library(ggplot2)

# Load variant data fresh from CSV
variants_df <- read.csv(
  "data/raw/variants.csv",
  stringsAsFactors = FALSE
)

message(paste("Variants loaded:", nrow(variants_df)))

# ── PLOT 1: Lollipop plot — VAF by gene ───────────────────────────────────────
# The lollipop plot is the standard figure for variant allele frequency
# in clinical genomics publications. The line shows the VAF value,
# the dot marks the exact position, and color shows gene type.

ggplot(variants_df,
       aes(x    = reorder(gene, vaf),
           y    = vaf,
           color = oncogene)) +

  # The line from zero to the VAF value
  geom_segment(
    aes(x    = reorder(gene, vaf),
        xend = reorder(gene, vaf),
        y    = 0,
        yend = vaf),
    color = "grey70",
    linewidth = 0.8
  ) +

  # The dot at the top of each line
  geom_point(size = 6) +

  # Flip so genes are on the y-axis (standard for lollipop plots)
  coord_flip() +

  # Clinical color scheme: red = oncogene, purple = tumor suppressor
  scale_color_manual(
    values = c("TRUE"  = "#B71C1C",
               "FALSE" = "#4A148C"),
    labels = c("TRUE"  = "Oncogene",
               "FALSE" = "Tumor Suppressor")
  ) +

  # Add a horizontal reference line at VAF = 0.40
  geom_hline(yintercept = 0.40,
             linetype   = "dashed",
             color      = "grey40",
             linewidth  = 0.5) +

  labs(
    title    = "Variant Allele Frequency by Oncology Gene",
    subtitle = "Six pathogenic variants — Mayo Clinical Bioinformatics Portfolio",
    x        = "Gene",
    y        = "Variant Allele Frequency (VAF)",
    color    = "Gene Classification",
    caption  = "Source: NCBI ClinVar | Clinical Bioinformatics Analysis Suite"
  ) +

  theme_minimal(base_size = 13) +
  theme(
    plot.title    = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(color = "grey40"),
    legend.position = "bottom"
  )
# Save Plot 1
ggsave(
  "figures/plot1_vaf_lollipop.png",
  width  = 10,
  height = 7,
  dpi    = 300
)
message("Plot 1 saved.")

# ── PLOT 2: Bar chart — VAF by gene colored by classification ─────────────────
ggplot(variants_df,
       aes(x    = reorder(gene, -vaf),
           y    = vaf,
           fill = oncogene)) +

  geom_col(width = 0.6) +

  geom_text(
    aes(label = paste0(vaf * 100, "%")),
    vjust    = -0.4,
    size     = 4,
    fontface = "bold"
  ) +

  scale_fill_manual(
    values = c("TRUE"  = "#B71C1C",
               "FALSE" = "#4A148C"),
    labels = c("TRUE"  = "Oncogene",
               "FALSE" = "Tumor Suppressor")
  ) +

  geom_hline(yintercept = 0.40,
             linetype   = "dashed",
             color      = "grey40") +

  scale_y_continuous(
    limits = c(0, 0.75),
    labels = scales::percent
  ) +

  labs(
    title    = "Variant Allele Frequency Across Six Oncology Genes",
    subtitle = "Ordered by VAF | Dashed line = 0.40 QC threshold",
    x        = "Gene",
    y        = "Variant Allele Frequency",
    fill     = "Gene Classification",
    caption  = "Source: NCBI ClinVar | Mayo Clinical Bioinformatics Portfolio"
  ) +

  theme_minimal(base_size = 13) +
  theme(
    plot.title      = element_text(face = "bold"),
    plot.subtitle   = element_text(color = "grey40"),
    legend.position = "bottom"
  )

ggsave(
  "figures/plot2_vaf_barchart.png",
  width  = 11,
  height = 7,
  dpi    = 300
)
message("Plot 2 saved.")

