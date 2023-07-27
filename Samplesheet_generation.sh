










#### Generating manifest file ####

# Needs 5 columns - 1. patient ID, 2. sample ID, 3. lane number, 4. forward fastq file, full path, 5. reverse fastq

# Sample IDs

# Get filenames
find -maxdepth 1 -type f -iname "*R1*" > filenames.txt
# Strip unneeded text. Cuts everything after (-f1) the "-" and then everything before (-f2) the "/". Leaving just the sample number, in this case.
cat filenames.txt | cut -d "-" -f1 | cut -d "/" -f2 > sample_ID.txt
# Append 'Sample' before each sample number
sed -i -e 's/cutadapt//' sample_ID.txt
sed -i -e 's/^/Sample/' sample_ID.txt

# NOTE - pipe this to a metadata file, which can have the metadata addd later (just the sample IDs and column headers for now). Thus the same sample IDs are in both metadata and files manifest files.
echo -e "ID\tProduct\tBatch" | cat - sample_ID.txt > metadata.tsv

# Files and full path

# "$PWD" adds full path
# -maxdepth 1 doesn't look in subdirs
find "$PWD" -maxdepth 1 -type f -iname "*R1*" > forward_reads.txt
find "$PWD" -maxdepth 1 -type f -iname "*R2*" > reverse_reads.txt

# Combine it column-wise
paste sample_ID.txt forward_reads.txt reverse_reads.txt > files_cols.txt

# Add headers
echo -e "sampleID\tforwardReads\treverseReads" | cat - files_cols.txt > files.tsv

# Cleanup
rm *.txt


