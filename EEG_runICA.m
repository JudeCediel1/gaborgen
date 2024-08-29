function EEG_runICA(partID, exclude4ICA, parentFolder, day1, day2)

if nargin < 4
    day1 = 1;
end

if nargin < 5
    day2 = 1;
end

if day1 == 0 && day2 == 0
    error('day1 and day2 arguments are zero which means neither day should be processed')
end

gaborgenCodeRepository = fileparts(mfilename('fullpath'));

participantDirectories = dir(dataFolder);
participantDirectories = participantDirectories(~ismember({participantDirectories.name}, {'.', '..'}));


for partI = 1:length(partID)
    % set random number generator (just in case)
    rng(1);

    [currentParticipantDirectories, dataFolder, gaborgenCodeRepository] = ...
        gaborgenMriReturnDirs(partID, parentFolder, day1, day2);

    for j = 1:length(currentParticipantDirectories)

        % initialize eeglab
        [AllEEG, ~, ~, ~] = eeglab;

        % load dataset
        disp('Step 1/3 - load EEG data');
        currentDir =  [dataFolder '/' matchingDirs{j} '/EEG'];

        currentFilenames = {dir(currentDir).name};
        EEGpreICAIndex = find(endsWith(currentFilenames, '_02_prepped4ICA.set'));
        if ~isempty(EEGpreICAIndex)
            EEGpreICAFileName = currentFilenames{EEGpreICAIndex};
        elseif EEGIndex > 1
            error(['More than one 02_prepped4ICA.set file found in ' currentDir]);
        else
            error(['No 02_prepped4ICA.set file found in ' currentDir]);
        end
        [~, EEGFileName, ~] = fileparts(currentFilenames{EEGpreICAIndex});


        EEG = pop_loadset('filename', EEGpreICAFileName, 'filepath', currentDir);
        [AllEEG, EEG, ~] = eeg_store(AllEEG, EEG, 0);

        % list indices of channels to include
        chanList = struct2cell(EEG.chanlocs);
        chanList = chanList(1,1,:);

        exclude4ICA_ind = find(ismember(squeeze(chanList), exclude4ICA{partI}));

        chans2include = 1:31;
        exclude4ICA_ind = unique([exclude4ICA_ind; 32]);
        chans2include = chans2include(~ismember(chans2include, exclude4ICA_ind));

        % run ICA
        disp('Step 2/3 - run ICA');
        EEG = pop_runica(EEG,'icatype','sobi','chanind',chans2include);
        [AllEEG, EEG, CURRENTSET] = pop_newset(AllEEG, EEG, 1, 'setname', ...
            [EEGFileName '_ICA'],'gui','off');
        [~, EEG] = eeg_store(AllEEG, EEG, CURRENTSET);

        % save data in eeglab format
        disp('Step 3/3 - save data with IC weights');
        EEG = eeg_checkset(EEG);
        pop_saveset(EEG, 'filename', [EEGFileName '_03_ICA.set'], ...
            'filepath', currentDir);

        % generate logfile
        logText = strcat('logfile for gaborgen_mri_eeg: run ICA\n', ...
            'date_time: ', string(datetime()), '\n', ...
            'participant: ', EEGFileName, '\n', ...
            'channels excluded from ICA: ', sprintf('%s ',string(exclude4ICA{partI})));
        fID = fopen([currentDir '/log02_runICA_' EEGFileName '.txt'], 'w');
        fprintf(fID, logText);
        fclose(fID);
    end
end
end