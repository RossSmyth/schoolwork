% Root directory of this running .m file
projectRootDir = fileparts(mfilename('fullpath'));

% Add project directories to path
addpath(fullfile(projectRootDir,'data'),'-end');
addpath(fullfile(projectRootDir,genpath('documents')),'-end');
addpath(fullfile(projectRootDir,'scripts'),'-end');