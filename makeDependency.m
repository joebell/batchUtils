%% 
%	makeDependency.m
%
%	Utility function for creating dependency arguments for batchSubmit().
%
%	Args:
%	
%		jobName - String containing name of job to wait for.
%
%		oneToOne - Boolean flag. If true, each job in a job array waits for 
%					only the corresponding job in the array it waits for.
%					If false, each job waits for all the jobs in first array.
%
%	nb: This uses the 'ended' condition, which is valid for 'EXIT' or 'DONE'.
%		If you only want it to run on successful completion, change to 'done'
%
%	Example:
%
%		job1 = batchSubmit({@firstJobFcn});
%		job2 = batchSubmit({@secondJobFcn}, makeDependency(job1,false));
%
%% JSB 8/2014
function depString = makeDependency(jobName,oneToOne)

	if oneToOne
		depString = ['-w "ended("',jobName,'[*]")"'];
	else
		depString = ['-w "ended("',jobName,'")"'];
	end
