#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt). And 
# runs the job_reconall.sh file for 
# each subject. It saves the ouput
# and error files in their specified
# directories.
#
# Set your study
STUDY=/projects/sanlab/shared/DEV

# Set subject list
SUBJLIST=`cat subject_list_total.txt`

# 
for SUBJ in $SUBJLIST
do
 sbatch --export SUBID=${SUBJ} --job-name reconall --partition=short --mem-per-cpu=8G --time=20:00:00 --cpus-per-task=1 -o "${STUDY}"/dev_scripts/sMRI/output/"${SUBJ}"_reconall_output.txt -e "${STUDY}"/dev_scripts/sMRI/output/"${SUBJ}"_reconall_error.txt job_reconall.sh
done
