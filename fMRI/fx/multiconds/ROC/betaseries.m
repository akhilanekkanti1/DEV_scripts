% This script pulls onsets and durations from the subject output files for
% ROC to create FX multicond files
%
% D.Cos 10/2018

%% Load data and intialize variables
inputDir = '~/Dropbox (PfeiBer Lab)/Devaluation/Tasks/ROC/output';
runNames = {'run1', 'run2', 'run3', 'run4'};
waveNames = {'1', '2'};
writeDir = '~/Documents/code/sanlab/DEV_scripts/fMRI/fx/multiconds/ROC/betaseries';
studyName = 'DEV';
filePattern = 'run'; 
nTrials = 20;
rowNum = -1;

% list files in input directory
runFiles = dir(sprintf('%s/*%s*.mat', inputDir, filePattern));
filesCell = struct2cell(runFiles);

% extract subject IDs
subjectID = unique(extractBetween(filesCell(1,:), 1,6));

% exclude test responses
excluded = subjectID(cellfun(@isempty,regexp(subjectID, '[0-2]{1}[0-9]{2}')));
subjectID = subjectID(~cellfun(@isempty,regexp(subjectID, '[0-2]{1}[0-9]{2}')));
fprintf(1, 'Excluded: %s\n', excluded{:})

% initialize table
eventtable  = cell2table(cell(0,6), 'VariableNames', {'subjectID', 'wave', 'run', 'rating', 'rt', 'condition'});

%% Loop through subjects and runs and save names, onsets, and durations as .mat files
for i = 1:numel(subjectID)
    sub = subjectID{i};
    
    for j = 1:numel(waveNames)
        wave = waveNames{j};
        files = dir(fullfile(inputDir, sprintf('%s_%s_*%s*.mat', sub, wave, filePattern)));

        % warn if there are not the correct number of files
        if numel(files) ~= length(runNames)
            warning('Incorrect number of files. Subject %s has %d files for wave %s.', sub, numel(files), wave)
        end

        % log missing trial info
        trials{i+j+rowNum,1} = sub;
        trials{i+j+rowNum,2} = wave;

        for k = 1:numel(runNames)
            %% Load text file
            run = runNames{k};
            runFile = dir(fullfile(inputDir, sprintf('%s_%s_*%s*.mat', sub, wave, run)));
            subFileName = {runFile.name};

            if ~isempty(subFileName)
                subFile = sprintf('%s/%s', inputDir, subFileName{end}); %select the last file

                if exist(subFile)
                    load(subFile);
                    
                    % Error if the behavioral version was run instead of the
                    % scan version
                    if ~contains(run_info.stimulus_input_file, 'beh')
                    
                        %% Pull onsets and durations
                        % Trials
                        idxs_all = find(~cellfun(@isempty,run_info.tag(:,1)));
                        idxs_image = idxs_all(2:3:length(idxs_all));
                        durations = num2cell(run_info.durations(idxs_image));
                        durations([durations{:}] == 0) = []; % remove incomplete trials
                        onsets = num2cell(run_info.onsets(idxs_image));
                        %onsets([onsets{:}] == 0) = []; % remove incomplete trials
                        onsets = onsets(1:length(durations)); % remove incomplete trials to match durations
                        
                        % Instructions
                        idxs_instructions = idxs_all(1:3:length(idxs_all));
                        durations{length(durations)+1} = run_info.durations(idxs_instructions)';
                        durations{length(durations)}(durations{length(durations)}(:) == 0) = []; % remove incomplete trials
                        
                        onsets{length(onsets)+1} = run_info.onsets(idxs_instructions)';
                        %onsets{length(onsets)}(onsets{length(onsets)}(:) == 0) = []; % remove incomplete trials
                        onsets{length(onsets)} = onsets{length(onsets)}(1:length(durations{length(durations)})); % remove incomplete trials to match durations
 
                        % Ratings
                        idxs_ratings = idxs_all(3:3:length(idxs_all));
                        ratings = run_info.responses(idxs_ratings)';
                        onsets{length(onsets)+1} = run_info.onsets(idxs_ratings)';
                        onsets{length(onsets)}(onsets{length(onsets)}(:) == 0) = []; % remove incomplete trials
                        durations{length(durations)+1} = run_info.durations(idxs_ratings)';
                        if length(durations{length(durations)}) > length(onsets{length(onsets)})
                            durations{length(durations)} = durations{length(durations)}(1:length(onsets{length(onsets)})); % remove incomplete trials
                        end

                        %% Initialize names
                        % Trials
                        for b = 1:length(onsets)-2
                            names{b} = strcat('trial',num2str(b));
                        end

                        % Instructions
                        names{length(names)+1} = 'instructions';

                        % Ratings
                        names{length(names)+1} = 'ratings';
                        
                        %% Define output file name
                        outputName = sprintf('%s_%s_ROC%d.mat', sub, wave, k);

                        %% Save as .mat file and clear
                        if ~exist(writeDir); mkdir(writeDir); end

                        if ~(isempty(onsets{1}) && isempty(onsets{2}))
                            save(fullfile(writeDir,outputName),'names','onsets','durations');
                        else
                            warning('File is empty. Did not save %s.', outputName);
                        end

                        %% Log missing trial info
                        trials{i+j+rowNum,k+2} = length(onsets)-2;
                        
                        %% Add subject data to table
                        tmp.subjectID = cell(length(run_info.onsets),1);
                        tmp.subjectID(:) = {sub};
                        tmp.wave = cell(length(run_info.onsets),1);
                        tmp.wave(:) = {wave};
                        tmp.run = cell(length(run_info.onsets),1);
                        tmp.run(:) = {run};
                        tmp.rating = run_info.responses';
                        tmp.rt = run_info.rt';
                        tmp.condition = run_info.tag;
                        runtable = struct2table(tmp);
                        eventtable = vertcat(eventtable, runtable);

                        clear names onsets durations;
                    else
                        warning('Behavioral version of task was run for subject %s wave %s %s.', sub, wave, run)
                    end                        
                else
                    warning('Unable to load subject %s run %s.', sub, run);
                end
            end
        end
    end
    rowNum = rowNum+1;
end
  
% save missing trial inf
%trials(cellfun('isempty', trials)) = {NaN};
table = cell2table(trials,'VariableNames',[{'subjectID'}, {'wave'}, runNames{:}]);
writetable(table,fullfile(writeDir, 'trials.csv'),'Delimiter',',')
fprintf('\nTrial info saved in %s\n', fullfile(writeDir, 'trials.csv'))

% save event info
writetable(eventtable,fullfile(writeDir, 'events.csv'),'Delimiter',',')
fprintf('\nEvent info saved in %s\n', fullfile(writeDir, 'events.csv'))