# ==============================================================================
#     Setup
# ==============================================================================

# Packages
import pandas as pd
import os
from pathlib import Path

# ==============================================================================
#     Reading in the data
# ==============================================================================

# Load sample metadata
samples = pd.read_csv(
    config["samples"],
    sep="\t",
    dtype=str,
    keep_default_na=False
)

# Create list of samples
SAMPLES = samples["sample_id"].unique().tolist()

# Load chromosomes
with open(config["chrom_list"]) as f:
    CHROMS = [line.strip() for line in f if line.strip()]

# ==============================================================================
#     Helper functions
# ==============================================================================

# Function to get bam per sample

def get_bam(wc):
    match = samples.loc[
        samples["sample_id"] == wc.sample
    ]

    if len(match) != 1:
        raise ValueError(f"Expected one BAM for {wc.sample}, found {len(match)}")

    return match.iloc[0]["bam_path"]

# Function to get sample ids in a cohort (for below function)

def get_cohort_samples(wc):
    # Get populations included in the requested cohort
    pops = config["cohorts"][wc.cohort]

    # Select samples belonging to those populations
    cohort_samples = samples.loc[
        samples["pop"].isin(pops), "sample_id"
    ].tolist()

    return cohort_samples

# Function to get list of gvcfs per cohort

def get_cohort_gvcfs(wc):
    cohort_samples = get_cohort_samples(wc)

    return [
        f"results/gvcfs/{sample}.g.vcf.gz"
        for sample in cohort_samples
    ]



def get_cohort_vcfs(wc):
    cohort_samples = get_cohort_samples(wc)

    return [
        f"results/gvcfs/{sample}.g.vcf.gz"
        for sample in cohort_samples
    ]