%-----------------------------------------------------------------------
% Job saved on 28-Apr-2019 09:37:49 by cfg_util (rev $Rev: 6460 $)
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
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '.*task-WTP_acq-1_bold_space-MNI152NLin2009cAsym_preproc.nii.gz';
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (.*task-WTP_acq-1_bold_space-MNI152NLin2009cAsym_preproc.nii.gz)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = true;
    matlabbatch{3}.spm.util.exp_frames.files(1) = cfg_dep('Gunzip Files: Gunzipped Files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{':'}));
    matlabbatch{3}.spm.util.exp_frames.frames = Inf;
    matlabbatch{4}.spm.spatial.smooth.data(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{4}.spm.spatial.smooth.fwhm = [6 6 6];
    matlabbatch{4}.spm.spatial.smooth.dtype = 0;
    matlabbatch{4}.spm.spatial.smooth.im = 0;
    matlabbatch{4}.spm.spatial.smooth.prefix = 's6_';
    matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {sprintf('/projects/sanlab/shared/DEV/bids_data/derivatives/fmriprep/sub-DEV001/ses-wave%d/func', waveNum)};
    matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '.*task-WTP_acq-2_bold_space-MNI152NLin2009cAsym_preproc.nii.gz';
    matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
    matlabbatch{6}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (.*task-WTP_acq-2_bold_space-MNI152NLin2009cAsym_preproc.nii.gz)', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{6}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
    matlabbatch{6}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = true;
    matlabbatch{7}.spm.util.exp_frames.files(1) = cfg_dep('Gunzip Files: Gunzipped Files', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{':'}));
    matlabbatch{7}.spm.util.exp_frames.frames = Inf;
    matlabbatch{8}.spm.spatial.smooth.data(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{8}.spm.spatial.smooth.fwhm = [6 6 6];
    matlabbatch{8}.spm.spatial.smooth.dtype = 0;
    matlabbatch{8}.spm.spatial.smooth.im = 0;
    matlabbatch{8}.spm.spatial.smooth.prefix = 's6_';
    matlabbatch{9}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {sprintf('/projects/sanlab/shared/DEV/bids_data/derivatives/fmriprep/sub-DEV001/ses-wave%d/func', waveNum)};
    matlabbatch{9}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '.*task-WTP_acq-3_bold_space-MNI152NLin2009cAsym_preproc.nii.gz';
    matlabbatch{9}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
    matlabbatch{10}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (.*task-WTP_acq-3_bold_space-MNI152NLin2009cAsym_preproc.nii.gz)', substruct('.','val', '{}',{9}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{10}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
    matlabbatch{10}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = true;
    matlabbatch{11}.spm.util.exp_frames.files(1) = cfg_dep('Gunzip Files: Gunzipped Files', substruct('.','val', '{}',{10}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{':'}));
    matlabbatch{11}.spm.util.exp_frames.frames = Inf;
    matlabbatch{12}.spm.spatial.smooth.data(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{11}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{12}.spm.spatial.smooth.fwhm = [6 6 6];
    matlabbatch{12}.spm.spatial.smooth.dtype = 0;
    matlabbatch{12}.spm.spatial.smooth.im = 0;
    matlabbatch{12}.spm.spatial.smooth.prefix = 's6_';
    matlabbatch{13}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {sprintf('/projects/sanlab/shared/DEV/bids_data/derivatives/fmriprep/sub-DEV001/ses-wave%d/func', waveNum)};
    matlabbatch{13}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '.*task-WTP_acq-4_bold_space-MNI152NLin2009cAsym_preproc.nii.gz';
    matlabbatch{13}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
    matlabbatch{14}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (.*task-WTP_acq-4_bold_space-MNI152NLin2009cAsym_preproc.nii.gz)', substruct('.','val', '{}',{13}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{14}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
    matlabbatch{14}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = true;
    matlabbatch{15}.spm.util.exp_frames.files(1) = cfg_dep('Gunzip Files: Gunzipped Files', substruct('.','val', '{}',{14}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{':'}));
    matlabbatch{15}.spm.util.exp_frames.frames = Inf;
    matlabbatch{16}.spm.spatial.smooth.data(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{15}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{16}.spm.spatial.smooth.fwhm = [6 6 6];
    matlabbatch{16}.spm.spatial.smooth.dtype = 0;
    matlabbatch{16}.spm.spatial.smooth.im = 0;
    matlabbatch{16}.spm.spatial.smooth.prefix = 's6_';
    matlabbatch{17}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('Gunzip Files: Gunzipped Files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{':'}));
    matlabbatch{17}.cfg_basicio.file_dir.file_ops.file_move.files(2) = cfg_dep('Gunzip Files: Gunzipped Files', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{':'}));
    matlabbatch{17}.cfg_basicio.file_dir.file_ops.file_move.files(3) = cfg_dep('Gunzip Files: Gunzipped Files', substruct('.','val', '{}',{10}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{':'}));
    matlabbatch{17}.cfg_basicio.file_dir.file_ops.file_move.files(4) = cfg_dep('Gunzip Files: Gunzipped Files', substruct('.','val', '{}',{14}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{':'}));
    matlabbatch{17}.cfg_basicio.file_dir.file_ops.file_move.action.delete = false;

    % run job
    spm_jobman('run',matlabbatch)
end
