#note this script shows analysing raw amplicon sequencing data:(output of this script generates otu table, taxonomy per otu and fasta sequence per otu)
#input files are: forwars.fastq(Undetermined_S0_L001_R1_001.fastq) , reverse.fastq(Undetermined_S0_L001_R2_001.fastq) and index.fastq(Undetermined_S0_L001_I1_001.fastq) and barcode file (barcodBacFunOtradPr.txt)
# note: As there were 11 sets of input files to process, step1 to step3 were done per file seperatly and results of all the sets were combined in step4
# basically in step 4 'grep' were done 11 times and combined all the files together.
# note: if you are downloading the dataset from NCBI () you would need to change first step according to name of demultiplex files

#step1
make.contigs(ffastq=Undetermined_S0_L001_R1_001.fastq, rfastq=Undetermined_S0_L001_R2_001.fastq, rindex=Undetermined_S0_L001_I1_001.fastq, oligos=barcodBacFunOtradPr.txt, bdiffs=2, processors=12)
#step2
screen.seqs(fasta=Undetermined_S0_L001_R1_001.trim.contigs.fasta, contigsreport=Undetermined_S0_L001_R1_001.contigs.report, group=Undetermined_S0_L001_R1_001.contigs.groups, minoverlap=5, maxambig=0, maxhomop=10, minlength=100, maxlength=600, processors=12)
#step3
rename.seqs(fasta=Undetermined_S0_L001_R1_001.trim.contigs.good.fasta, group=Undetermined_S0_L001_R1_001.contigs.good.groups)
#step4
system(grep -A 1 "FITS2." Undetermined_S0_L001_R1_001.trim.contigs.good.renamed.fasta>FITS2.trim.contigs.good.renamed.fasta)
system(grep "FITS2." Undetermined_S0_L001_R1_001.contigs.good.renamed.groups>FITS2.contigs.good.renamed.groups)

#next steps
unique.seqs(fasta=FITS2.trim.contigs.good.renamed.fasta)
count.seqs(name=FITS2.trim.contigs.good.renamed.names, group=FITS2.contigs.good.renamed.groups)
chimera.vsearch(fasta=FITS2.trim.contigs.good.renamed.unique.fasta, count=FITS2.trim.contigs.good.renamed.count_table, processors=12)

remove.seqs(accnos=FITS2.trim.contigs.good.renamed.unique.denovo.vsearch.accnos, fasta=FITS2.trim.contigs.good.renamed.unique.fasta, count=FITS2.trim.contigs.good.renamed.count_table)

system(ITSx -i FITS2.trim.contigs.good.renamed.unique.pick.fasta --preserve T --save_regions all -t f,o,t --allow_single_domain 1e-5,0 -N 1 --partial 1 --cpu 16 --complement F)
system(cat ITSx_out.ITS2.full_and_partial.fasta ITSx_out_no_detections.fasta>FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.fasta)
list.seqs(fasta=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.fasta)
get.seqs(accnos=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.accnos, count=FITS2.trim.contigs.good.renamed.pick.count_table)
unique.seqs(fasta=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.fasta, count=FITS2.trim.contigs.good.renamed.pick.pick.count_table)
screen.seqs(fasta=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.fasta, count=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.count_table, minlength=30)
classify.seqs(fasta=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.fasta, template=UNITE_public_mothur_full_02.02.2019_phiX.fasta, taxonomy=UNITE_public_mothur_full_02.02.2019_taxonomy_phiX.txt, processors=12)
remove.groups(fasta=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.fasta, count=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.good.count_table, groups=FITS2.A48-FITS2.B37-FITS2.C41-FITS2.D48-FITS2.E18-FITS2.F37-FITS2.G17-FITS2.H42-FITS2.I29-FITS2.J96-FITS2.K11-FITS2.L2-FITS2.M52, taxonomy=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.2019_taxonomy_phiX.wang.taxonomy)
cluster(fasta=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.fasta, count=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.good.pick.count_table, method=dgc, cutoff=0.03)
split.abund(fasta=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.fasta, count=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.good.pick.count_table, list=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.dgc.list, cutoff=50)
classify.otu(taxonomy=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.2019_taxonomy_phiX.wang.pick.taxonomy, list=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.dgc.0.03.abund.list, count=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.good.pick.0.03.abund.count_table)
make.shared(list=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.dgc.0.03.abund.list, count=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.good.pick.0.03.abund.count_table)
remove.lineage(constaxonomy=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.dgc.0.03.abund.0.03.cons.taxonomy, shared=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.dgc.0.03.abund.shared, taxon=unknown-PhiX-Arabidopsis-mitochondria-Chloroplast-Embryophyceae)
get.oturep(fasta=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.0.03.abund.fasta, list=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.dgc.0.03.abund.list, count=FITS2.trim.contigs.good.renamed.unique.pick.cutadapt2.good.pick.0.03.abund.count_table, method=abundance)
