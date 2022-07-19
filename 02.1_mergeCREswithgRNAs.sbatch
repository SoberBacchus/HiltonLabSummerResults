#!/bin/bash
##SBATCH --qos=test
#SBATCH --time=0:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=20G
#SBATCH -o /fslhome/mariode/compute/blood/slurm/%x-slurm-%j.out
#SBATCH --array=3-4

T_START=$(date +%r)
S_START=$(date +%s)

WORKDIR=/fslhome/mariode/compute/blood
OUTDIR=${WORKDIR}/results
FOI=/fslhome/mariode/compute/blood/analysis/processed/
ID=$SLURM_ARRAY_TASK_ID
CHRSIZE=${WORKDIR}/references/hg38.chrom.sizes
CRES=/fslhome/mariode/compute/blood/references/encodeCcreCombined.bed
GRNAS=/fslhome/mariode/compute/blood/references/crispr.bed

S1=$(find $FOI/*.bed | sed -n "$ID"'p')
P0=$(find $S1 -printf "%f"| sed 's/.bed//' )

source ~/.bashrc
conda activate nf-core
cd $WORKDIR
mkdir -p $OUTDIR/all_crispr_cres

echo 'Finding every CRE associated to: '$P0
closest-features  --delim '\t' --closest $S1 $CRES > $OUTDIR/all_crispr_cres/${P0}.cre.bed

echo 'Finding every gRNAs associated to: '$P0
closest-features  --delim '\t' --closest $GRNAS $OUTDIR/all_crispr_cres/${P0}.cre.bed > $OUTDIR/all_crispr_cres/${P0}.grnas.bed

echo 'Removing gRNAs that are not within the detected peaks of : '$P0
bedops --element-of 50% $OUTDIR/all_crispr_cres/${P0}.grnas.bed $S1 > $OUTDIR/all_crispr_cres/${P0}.grnas.cre.bed

#
# echo 'Preparing bedGraph file for sample: '$P0
# awk '{$6=$4+$5}; {print $1,$2,$3,$6}' OFS='\t' $OUTDIR/bedtools/mergebg/${P0}.bedGraph | awk '!/chrEBV/' > $OUTDIR/bedtools/mergebg/$P0.single.bedGraph
#
# echo 'Starting to convert bedGraph to bigWig for sample: '$P0
# bedGraphToBigWig $OUTDIR/bedtools/mergebg/${P0}.single.bedGraph $CHRSIZE bw/${P0}.bw

T_END=$(date +%r)
S_END=$(( $(date +%s) - S_START ))

echo "Start Time: "$T_START
echo "End Time: "$T_END
echo "Total Time: "$(date -ud @$S_END +'%H hr %M min %S sec')
