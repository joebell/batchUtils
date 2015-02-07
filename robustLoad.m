%%
%	robustLoad.m
%
%	Robust loading for running scripts in parallel on shared filesystems.
%	This implements a file-lock system to prevent multiple access, but 
%	releases the lock once the file is loaded.
%
%	Args:
%
%		fileName - String name of file to load.
%
%		nTries - Number of times to retry on failure to load or get lock.
%
%% JSB 1/2015
function robustLoad(fileName, nTries)
	loaded = false;
	tryCounts = 0;
	while ((~loaded) && (tryCounts < nTries))
		try
			result = system(['lockfile -l 128 -r 0 ',fileName,'.lock']);
			if (result == 0)
				S = load(fileName);
				loaded = true;
				system(['rm -f ',fileName,'.lock']);
			else
				tryCounts = tryCounts + 1;
				delayTime = rand()*2^(tryCounts - 1);
				disp(['Couldn''t get lock of ',fileName]);
				disp(['Pausing: ',num2str(delayTime),' sec.']);
				pause(delayTime);
			end
		catch err
			tryCounts = tryCounts + 1;
			delayTime = rand()*2^(tryCounts - 1);
			disp(['Loaded failed of ',fileName]);
			disp(['Pausing: ',num2str(delayTime),' sec.']);
			pause(delayTime);
		end
	end

	if (~loaded)
		disp(['Load of: ',fileName,' failed.']);
		% disp('Deleting.');
		% system(['rm ',fileName]);
		return;
	else
		varNames = fieldnames(S);
		for varN = 1:length(varNames)
			assignin('caller',varNames{varN},getfield(S,varNames{varN}));
		end
	end

