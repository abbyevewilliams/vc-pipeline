# A snakemake pipeline for variant calling *Zosterops* aligned reads

*Abby Williams, University of Oxford, 2025*

A pipeline for calling variants from reads aligned to the *Zosterops lateralis* pseudochrome assembly. This pipeline combines alignments originating from museum specimens (high coverage) and live birds (low coverage). We downsample the high-coverage reads and call genotype likelihoods using ANGSD.

---

**Workflow**

Specific steps are outlined below:
1. Downsample high-coverage museum reads using Samtools
2. Call genotype likelihoods using ANGSD
3. Do PCA using PCAngsd
4. Assess population structure using NGSadmix

---

**Installation and usage**

Use conda/mamba to install the environment from the `environment.yaml` provided.

`conda create --prefix ./snakemake-env --file environment.yaml`

Do the following prior to running: 
- edit file paths in `config/config.yaml`
- add any appropriate profiles in `profiles/`
- edit the `run.sh` depending on your HPC environment

To run snakemake, run:

`sbatch run.sh`

---

This pipeline was built in [snakemake](https://snakemake.github.io/) using [this workflow template](https://github.com/snakemake-workflows/snakemake-workflow-template).
