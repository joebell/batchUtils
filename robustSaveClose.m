%%
%	robustSaveClose.m
%
%	Robust saving for running scripts in parallel on shared filesystems.
%	This assumes that the running process already has a valid lock on the 
%	file, write to it, and then deletes any existing lockfile.
%
%	Args:
%
%		fileName - String name of file to save.
%
%		nTries - Number of times to retry on failure to save or get lock.
%
%		varargin - String names of variables to save.
%
%% JSB 1/2015
function robustSaveClose(fileName, nTries, varargin)
	S = struct();
	for varN = 1:length(varargin)
		fieldVal = evalin('caller',varargin{varN});
		S = setfield(S,varargin{varN},fieldVal);
	end

	saved = false;
	tryCounts = 0;
	while ((~saved) && (tryCounts < nTries))
		try
			save(fileName,'-struct','S','-v7.3');
			saved = true;
			system(['rm -f ',fileName,'.lock']);
		catch err
			tryCounts = tryCounts + 1;
			delayTime = rand()*2^(tryCounts - 1);
			disp(['Save failed, pausing: ',num2str(delayTime),' sec.']);
			pause(delayTime);
		end
	end

	if (~saved)
		disp(['Save of: ',fileName,' failed.']);
		return;
	end
