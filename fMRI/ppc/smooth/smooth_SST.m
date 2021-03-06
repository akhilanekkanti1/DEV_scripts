%-----------------------------------------------------------------------
% Job saved on 27-Apr-2019 12:00:43 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6906)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
for i = 1:numel(waves)
    % define wave number
    waveNum = waves(i);
    fprintf('------------------------------------------------------------------------\n')
    fprintf('Smoothing wave %d\n', waveNum)
    fprintf('------------------------------------------------------------------------\n')

    % create matlabbatch job
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {sprintf('/projects/sanlab/shared/DEV/bids_data/derivatives/fmriprep/sub-DEV001/ses-wave%d/func', waveNum)};
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '.*task-SST_acq-1_bold_space-MNI152NLin2009cAsym_preproc.nii.gz';
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (.*task-SST_acq-1_bold_space-MNI152NLin2009cAsym_preproc.nii.gz)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = true;
    matlabbatch{3}.spm.util.exp_frames.files(1) = cfg_dep('Gunzip Files: Gunzipped Files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{':'}));
    matlabbatch{3}.spm.util.exp_frames.frames = Inf;
    matlabbatch{4}.spm.spatial.smooth.data(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{4}.spm.spatial.smooth.fwhm = [6 6 6];
    matlabbatch{4}.spm.spatial.smooth.dtype = 0;
    matlabbatch{4}.spm.spatial.smooth.im = 0;
    matlabbatch{4}.spm.spatial.smooth.prefix = 's6_';
    matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('Gunzip Files: Gunzipped Files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{':'}));
    matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.action.delete = false;

    % run job
    spm_jobman('run',matlabbatch)
end
