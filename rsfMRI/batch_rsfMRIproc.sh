#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt) in the same
# folder and will run job_rsfMRIproc.tcsh
# for each subject in that list.

# Set your study
STUDY=/projects/sanlab/shared/DEV

# Set subject list
SUBJLIST=`cat subject_list_total.txt`

for SUBJ in $SUBJLIST
 do sbatch --export SUBID=${SUBJ} --job-name rsfMRIproc --partition=short --mem-per-cpu=8G --cpus-per-task=1 -o "${STUDY}"/dev_scripts/rsfMRI/output/"${SUBJ}"_rsfMRIproc_output.txt -e "${STUDY}"/dev_scripts/rsfMRI/output/"${SUBJ}"_rsfMRIproc_error.txt job_rsfMRIproc.tcsh
done


