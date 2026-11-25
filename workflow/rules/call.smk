# Create sequence dict for ref genome

ref_path = config["ref_genome"]
ref_dict = Path(ref_path).with_suffix(".dict")

rule create_dict:
    input:
        ref_path
    output:
        ref_dict
    log:
        "results/logs/create_dict.log"
    wrapper:
        "v9.19.3/bio/picard/createsequencedictionary"

# Call haplotypes for each individual BAM

# Note: the below wrapper already has -ERC GVCF option specified

rule haplotype_caller_gvcf:
    input:
        bam=get_bam,
        ref=ref_path,
    output:
        gvcf="results/gvcfs/{sample}.g.vcf.gz",
    log:
        "results/logs/haplotypecaller/{sample}.log",
    wrapper:
        "v9.19.3/bio/gatk/haplotypecaller"

# Import database

rule genomics_db_import:
    input:
        gvcfs=get_cohort_gvcfs
    output:
        db=directory("results/db/{cohort}_{chrom}"),
    log:
        "results/logs/genomicsdbimport/{cohort}_{chrom}.log",
    params:
        intervals=lambda wc: wc.chrom
    wrapper:
        "v9.19.3/bio/gatk/genomicsdbimport"

# Genotype GVCFs

rule genotype_gvcfs:
    input:
        gvcf="results/db/{cohort}_{chrom}",
        ref=config["ref_genome"]
    output:
        vcf="results/calls/{cohort}_{chrom}.vcf.gz",
    log:
        "results/logs/genotypegvcfs/{cohort}_{chrom}.log"
    wrapper:
        "v9.19.3/bio/gatk/genotypegvcfs"

# Merge VCFs

rule merge_vcfs:
    input:
        vcfs=lambda wc: expand(
            "results/calls/{cohort}_{chrom}.vcf.gz",
            cohort=wc.cohort,
            chrom=CHROMS
        )
    output:
        "results/calls/{cohort}_{chrom}.vcf",
    log:
        "results/logs/mergevcfs/{cohort}_{chrom}.log",
    wrapper:
        "v9.19.3/bio/picard/mergevcfs"


