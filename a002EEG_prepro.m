%% This will clear and edit your matlab path
% possibly necessary if you don't have eeglab set up correctly
restoredefaultpath
% gaborgenCodeRepository = '/home/andrewf/Repositories/gaborgen';
gaborgenCodeRepository = '/Users/researchassistants/Documents/GitHub/gaborgen';

% eeglabDirectory = '/home/andrewf/Repositories/eeglab2024.0';
eeglabDirectory = '/Users/researchassistants/Documents/MATLAB/eeglab2024.1';

cd(eeglabDirectory)
[AllEEG, ~, ~, ~] = eeglab;
cd(gaborgenCodeRepository)

% Add EMGS directory and all subdirectories to path
% emegs28path = '/home/andrewf/Repositories/emegs2.8'; 
% addpath(genpath(emegs28path), '-end'); 

%% Preprocessing, Step 1
% correct for scanner & cardioballistic artifacts, downsample, and filter
% EEG_prep4ICA(partID,newSamplingRate,filterCutOff,parentFolder)
% Data should be dropbox organization: parentFolder/raw_data/...partID/EEG
EEG_prep4ICA([116],500,[3 40], ...
    '/Users/researchassistants/Documents/EEGstudies/Gaborgen24_EEG_fMRI');



%%% manual step: check which channels should not be included in ICA



%% Preprocessing, Step 2
% run ICA, while excluding bad channels
% Example:
% EEG_runICA([101:102 104:107], ...
%     {{'CP1','FC2'}, {'CP1','FC2'}, {}, {'F7','Cz'}, {}, {'T7'}}, ...
%     '/Volumes/TOSHIBA_4TB/ssV4att_MRI')
% 

%EEG_runICA(partID, exclude4ICA, parentFolder, day1, day2)
EEG_runICA([114], ...
    {{}}, ...
    '/Users/researchassistants/Documents/EEGstudies/Gaborgen24_EEG_fMRI')


%%% manual step: check which ICs to remove and which channels to interpolate
% How do you know which ICs to manuall remove? Andrew


%% Preprocessing, Step 3
% exclude artifact ICs, interpolate bad channels, apply average reference,
% run artifact rejection, apply CSD


 EEG_finishPrepro([110],{[]}, {{}}, ...
 '/Users/researchassistants/Documents/EEGstudies/Gaborgen24_EEG_fMRI')

% % 101 ICs - Gradients: 1,2,6,9,15; eyes: 3,5; CBA: 4
% EEG_03_finishPrepro(101,{[1 2 3 4 5 6 9 15]},{{'CP1','FC2'}},'/Volumes/TOSHIBA_4TB/ssV4att_MRI')
% 
% % 102 ICs - Gradients: 1,6; eyes: 3; CBA: 2,7
% EEG_03_finishPrepro(102,{[1 2 3 6 7]},{{'CP1','FC2'}},'/Volumes/TOSHIBA_4TB/ssV4att_MRI')
% 
% % 104 ICs - Gradients: 3,5; eyes: 2,10; CBA: 6,7
% EEG_03_finishPrepro(104,{[2,3,5,6,7,10]},{{}},'/Volumes/TOSHIBA_4TB/ssV4att_MRI')
% 
% % 105 ICs - Gradients: 1,2,3; eyes: 4,10; CBA: 5
% EEG_03_finishPrepro(105,{[1 2 3 4 5 10]},{{'F7','Cz'}},'/Volumes/TOSHIBA_4TB/ssV4att_MRI')
% 
% % 106 ICs - Gradients: 1,2,4,7,8,14,18,24; eyes: 3; CBA: 9,11
% EEG_03_finishPrepro(106,{[1 2 3 4 7 8 9 11 14 18 24]},{{}},'/Volumes/TOSHIBA_4TB/ssV4att_MRI')
% 
% % 107 ICs - Gradients: 1,8; eyes: 2; CBA: 4
% EEG_03_finishPrepro(107,{[1 2 4 8]},{{'T7'}},'/Volumes/TOSHIBA_4TB/ssV4att_MRI')



%% Sliding Window

% function EEG_slidingWindow(partID, markerStrings, condStrings, ...
%     resampleTo, segTimesMs, blTimesMs_bl, ...
%     ssvepTimesMs_bl, blTimesMs_cue, ssvepTimesMs_cue, ...
%     avgChannels, parentFolder, day1, day2)

% Example:
% EEG_slidingWindow([101:102 104:107], ...
%                      {{'S 11', 'S111'},{'S 12', 'S112'},{'S 21', 'S121'},{'S 22', 'S122'}},{'11','12','21','22'}, ...
%                      480,[-1600 4000],[-1600 -1400],[-1400 -466],[-200 0],[933 3734], ...
%                      {'Oz','O1','O2'},'/Volumes/TOSHIBA_4TB/ssV4att_MRI')


EEG_slidingWindow([130], ...
                     {{'S 11'},{'S 12'},{'S 13'},{'S 14'},{'S 21'},{'S 22'},{'S 23'},{'S 24'},{'S 31'},{'S 32'},{'S 33'},{'S 34'}}, ...
                     {'11','12','13','14','21','22','23','24','31','32','33','34'}, ...
                     480,[-1600 2000],[-1600 -1400],[-1400 -466],[-200 0],[933 3734], ...
                     {'Oz','O1','O2'},'/Volumes/TOSHIBA_4TB/ssV4att_MRI')
