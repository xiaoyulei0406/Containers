vcf=$1
sample_name=$2
cat ${vcf} | grep '^#' > "${sample_name}_pass_oncefilterd.vcf"
cat ${vcf} | grep -v '#' | awk '$7=="PASS"' >> "${sample_name}_pass_oncefilterd.vcf"