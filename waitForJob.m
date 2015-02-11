%%
%
%% JSB 2/2015
function status = waitForJob(jobName)

	jm = findResource('scheduler','type','lsf');
	set(jm,'ClusterMatlabRoot','/opt/matlab-2013b');

	allJobs = findJob(jm);
	jobsUnfinished = true;
	while (jobsUnfinished)
		jobsUnfinished = false;
		status = 0;
		for jobN = 1:length(allJobs)
			aName = allJobs(jobN).Name;
			aStatus = allJobs(jobN).State;
			if (strcmp(aName, jobName))
				if strcmp(aStatus,'failed')
					jobsUnfinished = false;
					status = 1;
				elseif strcmp(aStatus,'finished')
					jobsUnfinished = false;
					status = 0;
				else
					disp(['Waiting for ',aName,': ',aStatus,'...']);
					jobsUnfinished = true;
					status = 1;
				end
			end
		end
		if (jobsUnfinished)
			pause(30);
		end
	end

