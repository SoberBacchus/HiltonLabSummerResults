#!/bin/bash
source ~/.bashrc

T_START=$(date +%r)
S_START=$(date +%s)

#WORDIR=/home/ec2-user/designRuns  
#OUTDIR=${WORKDIR}/results
FOI=/home/ec2-user/

workdir=/home/ec2-user/designRuns
#CHRSIZE=${WORKDIR}/references/hg38.chrom.sizes
grnas=/home/ec2-user/temp/sorted.crispr.bed.1
#CRES=/home/ec2-user/designRuns/processedPeaks.bed
input_peaks=/home/ec2-user/designRuns/sorted_filtered_proc_peaks.bed

#S1=$(find $FOI/*.bed | sed -n "$ID"'p') 
#P0=filtered_proc_peaks.bed
#$(find $S1 -printf "%f"| sed 's/.bed//' )

#conda activate nf-core
cd $WORKDIR
#mkdir -p $OUTDIR/all_crispr_cres

#echo 'Finding every CRE associated to: '$P0
#closest-features  --delim '\t' --closest $S1 $CRES > $OUTDIR/all_crispr_cres/${P0}.cre.bed

#echo 'Finding every gRNAs associated to: '$P0
#closest-features  --delim '\t' --closest $GRNAS $OUTDIR/all_crispr_cres/${P0}.cre.bed > $OUTDIR/all_crispr_cres/${P0}.grnas.bed

echo 'Removing gRNAs that are not within the detected peaks of : '

bedops --element-of 50% $grnas  $input_peaks  > /home/ec2-user/designRuns/sorted_grnas.bed

#
# echo 'Preparing bedGraph file for sample: '$P0
# awk '{$6=$4+$5}; {print $1,$2,$3,$6}' OFS='\t' $OUTDIR/bedtools/mergebg/${P0}.bedGraph | awk '!/chrEBV/' > $OUTDIR/bedtools/mergebg/$P0.single.bedGraph
#
# echo 'Starting to convert bedGraph to bigWig for sample: '$P0
# bedGraphToBigWig $OUTDIR/bedtools/mergebg/${P0}.single.bedGraph $CHRSIZE bw/${P0}.bw

T_END=$(date +%r)
S_END=$(( $(date +%s) - S_START ))

#echo "Start Time: "$T_START
#echo "End Time: "$T_END
echo "Total Time: "$(date -ud @$S_END +'%H hr %M min %S sec')


#### Notes: 
# make sure to sort BED Files!
