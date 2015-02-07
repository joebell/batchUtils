%%
%
%	batchSubmit.m
%
%	Utility function for submitting LSF jobs to the 'short' queue.
%
%	Args:
%
%		funcHandles - A cell array of function handles (eg. {@myFunc1, @myFunc2})
%		otherArgs (opt.) - A string of other arguments to pass to the scheduler.
%
%	Returns:
%
%		jobName - A string denoting the name of the created job.
%
%	Notes:
%
%		It can be helpful to use anonymous functions to deal with arguments to 
%		functions in funcHandles. For example:
%
%		funcHandles{1} = @() myFunction(myArg1, myArg2, myArg3);
%
%% JSB 8/2014
function jobName = batchSubmit(funcHandles, varargin)

	if nargin > 1
		otherArgs = varargin{1};
	else
		otherArgs = '';
	end

	queueString = '-W 12:00 -q short';
	jm = findResource('scheduler','type','lsf');
	set(jm,'ClusterMatlabRoot','/opt/matlab-2013b');
	job = createJob(jm);
	
	set(jm,'SubmitArguments',['-R "rusage[matlab_dc_lic=1]"',...
			' -R "rusage[mem=16384]"',...
			' -R "span[ptile=1]" ', queueString,' ', otherArgs]);
           %  ' -R "rusage[swp=16384]"'

	for taskN = 1:length(funcHandles)
		fHandle = funcHandles{taskN};

		createTask(job, fHandle, 0, {});
		disp(['Task: ',func2str(fHandle)]);
	end

	jobName = get(job,'Name');
	submit(job);


