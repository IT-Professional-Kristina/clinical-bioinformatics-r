#==================================================================
# PROJECT: Clinical Bioinformatics Analysis Suite
# MODULE 1: Data Foundation
# Script: 01_data_foundation.R
# Author: Kristina Ankrah
# Purpose: Build, explore, and save the oncology variant dataset
#==================================================================
gene_name <- "BRAF"

variant <- "V600E"
position <- 140453136
is_pathogenic <- TRUE
class(gene_name)
class(position)
class(is_pathogenic)

#______________SECTION 2: Vectors______________
genes <- c("BRAF","TP53", "KRAS", "EGFR", "ERBB2", "ABL1")
variants <- c("V600E", "R248W", "G12D", "L858R", "V842I", "T315I")
chromosomes <- c("chr7","chr17", "chr12", "chr7", "chr17", "chr9")
positions <- c(140453136, 7577538, 25398281, 55259515, 37880993, 133748283)
vafs <- c(0.48, 0.35, 0.52,0.41, 0.29, 0.61)
cancer_type <- c("Melanoma", "Pan-cancer", "PDAC", "NSCLC", "Breast", "CML")
oncogene <- c(TRUE, FALSE, TRUE, TRUE, TRUE, FALSE)

# ____________SECTION 3: Build the Clinical Data Frame_________________________
variants_df <- data.frame(
  gene = genes,
  variant = variants,
  chromosome = chromosomes,
  position = positions,
  vaf = vafs,
  cancer_type = cancer_type,
  oncogene = oncogene,
  stringsAsFactors = FALSE
)
nrow(variants_df)
ncol(variants_df)

str(variants_df)
variants_df$gene

variants_df$vaf

variants_df[variants_df$oncogene == FALSE,]

write.csv(
  variants_df,
  file      = "data/raw/variants.csv",
  row.names = FALSE
)

