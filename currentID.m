%%
%	currentID.m
%
%	Utility function for returning (as a string) the LSF job ID of the calling job.
%
%% JSB 1/2015
function out = currentID()

	[status, retVal] = system('echo $LSB_JOBID');
	out = num2str(str2num(retVal));
