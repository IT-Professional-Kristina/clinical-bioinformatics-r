# Clinical Bioinformatics Pipeline in R
### Genomic Variant Analysis | VAF Statistics | Clinical Decision Support Context

---

## Overview

This project implements a four-script clinical bioinformatics pipeline in R, built to demonstrate genomic variant analysis workflows relevant to oncology informatics and clinical decision support. The pipeline ingests a curated set of six clinically significant oncology variants, performs data wrangling and exploratory analysis, produces publication-quality visualizations, and applies nonparametric statistical testing to compare variant allele frequency (VAF) distributions between oncogenes and tumor suppressors.

The variant panel was not chosen arbitrarily. Each mutation represents a therapeutically actionable target with direct clinical implications:

| Variant | Gene Type | VAF | Clinical Significance |
|---|---|---|---|
| BRAF V600E | Oncogene | 0.42 | Targeted by vemurafenib/dabrafenib in melanoma |
| TP53 R248W | Tumor Suppressor | 0.35 | Contact mutation disrupting DNA-binding domain |
| KRAS G12D | Oncogene | 0.48 | Driver mutation; limits targeted therapy options |
| EGFR L858R | Oncogene | 0.39 | Sensitizing mutation; targeted by erlotinib/osimertinib |
| ERBB2 V842I | Oncogene | 0.45 | HER2 kinase domain mutation; targeted by neratinib |
| ABL1 T315I | Tumor Suppressor | 0.61 | Gatekeeper resistance mutation in CML; targeted by ponatinib |

---

## Pipeline Architecture

```
data/raw/               ← Source variant data (CSV)
scripts/
  01_data_foundation.R  ← Data import, structure, type validation
  02_dplyr_wrangling.R  ← Tidyverse filtering, grouping, summarization
  03_visualization.R    ← ggplot2 charts: VAF distribution, group comparison
  04_statistical_analysis.R ← Descriptive stats + Wilcoxon rank-sum test
output/
  overall_statistics.csv  ← Dataset-level summary statistics
  group_statistics.csv    ← VAF statistics by gene type (oncogene vs. tumor suppressor)
figures/                ← ggplot2 output plots
```

Each script is self-contained and annotated with clinical context, not just code comments. The intent is that a clinical analyst — not only a data scientist — can follow the reasoning.

---

## Key Findings

**Descriptive Statistics**

- Overall mean VAF: 0.45 across all six variants
- Oncogene group (n=4): mean VAF 0.435, SD 0.039 — tightly clustered
- Tumor suppressor group (n=2): mean VAF 0.480, SD 0.184 — wide spread driven by ABL1 T315I at 0.61

The counterintuitive result — tumor suppressors showing higher mean VAF than oncogenes — is a direct consequence of ABL1 T315I dominating a two-sample group. This is a deliberate teaching point about the outsized influence of extreme values in small clinical datasets, a consideration that applies directly to variant interpretation in real genomic pipelines.

**Statistical Test**

A Wilcoxon rank-sum test (non-parametric, appropriate for non-normal small samples) returned p = 0.817 — no statistically significant difference between groups.

This result is expected and intentional. With n=4 vs. n=2, the test has very low statistical power. In a production pipeline, this methodology would run on hundreds of variants from a VCF file processed through GATK or similar. The purpose here is to demonstrate correct test selection and interpretation, including honest acknowledgment of sample size limitations — a skill as important in clinical informatics as in bench research.

---

## Tools and Methods

- **Language:** R 4.6.0
- **IDE:** RStudio
- **Libraries:** tidyverse, dplyr, ggplot2
- **Statistical method:** Wilcoxon rank-sum test (selected over t-test due to small, non-normal sample)
- **Version control:** Git + GitHub via RStudio Git panel
- **Data:** Manually curated variant panel based on published oncology literature and ClinVar classifications

---

## Clinical and Informatics Context

This project was built by a healthcare IT professional with 9+ years of clinical pharmacy experience across academic medical centers, including direct end-user experience with Epic Willow Inpatient, Beacon Oncology, and Ambulatory modules, as well as Cerner and IV chemotherapy compounding in an oncology setting.

The variant selection reflects real clinical exposure: BRAF V600E and EGFR L858R are mutations encountered in oncology prior authorization workflows; ABL1 T315I is the resistance mutation that drives treatment escalation to ponatinib in CML — a clinical scenario familiar from pharmacy practice long before it became a bioinformatics data point.

This background shapes how the analysis is framed. VAF is not treated as an abstract number — it is interpreted in terms of tumor clonality, resistance emergence, and what it would mean for a clinical team making treatment decisions.

---

## How to Run

```r
# Run scripts in order from the RStudio console or source each file:
source("scripts/01_data_foundation.R")
source("scripts/02_dplyr_wrangling.R")
source("scripts/03_visualization.R")
source("scripts/04_statistical_analysis.R")
```

Output CSVs will be written to `output/`. Figures will be saved to `figures/`.

**Dependencies:**
```r
install.packages(c("tidyverse", "ggplot2", "dplyr"))
```

---

## Portfolio Context

This repository is one component of a broader clinical informatics and healthcare IT portfolio that includes:

- **Azure Genomics Research Platform** — live Cosmos DB with six pathogenic oncology variants, GitHub Actions CI/CD pipeline, and a live HTML dashboard (github.com/IT-Professional-Kristina/azure-genomics-research-platform)
- **Genomic Cosmos AWS** — DynamoDB-backed genomic variant database in Node.js/JavaScript (github.com/IT-Professional-Kristina/genomic-cosmos-aws-db)
- **Oncology Medication Safety Checker** — interactive clinical decision support tool built for portfolio demonstration

The common thread across all projects: clinical knowledge applied to technical infrastructure, with honest framing of what was self-directed versus guided learning.

---

*Built in 2025 | R 4.6.0 | RStudio | GitHub*
