%%
%	rechunkSubmit.m
%
%	This function allows many short running tasks to be run serially using a
%	smaller number of LSF jobs.
%
%	Args:
%
%		funcHandles - A cell array of function handles to run.
%
%		chunkSize - An integer # of tasks to run sequentially in each job.
%
%		extraParams (opt.) - Optional argument string.
%
%	Returns:
%
%		jobName - String containing the name of the job.
%
%%	JSB 8/2014
function jobName = rechunkSubmit(funcHandles,chunkSize,varargin)

	if nargin > 2
		extraParams = varargin{1};
	else
		extraParams = '';
	end

	count = 0;
	chunkList = {};
	totalList = {};

	% Go through all the tasks we need to run
	for taskN = 1:length(funcHandles)
		fHandle = funcHandles{taskN};

		% Assign them spots in the smaller chunkList
		count = count + 1;
		chunkList{count} = fHandle;
		% If a chunk is full or we're out of tasks...
		if ((count == chunkSize) || (taskN == length(funcHandles)))

			% Schedule them to be run by the sequencer
			totalList{end+1} = @()sequenceCommands(chunkList);

			% And clear the chunkList
			count = 0;
			chunkList = {};
		end
	end

	% Submit all the sub-sequenced tasks...	
	jobName = batchSubmit( totalList, extraParams);








