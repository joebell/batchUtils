%%
%	setupPool.m
%
%	Utility function for requesting a pool for parallel jobs.
%
%	Args:
%
%		nHosts - # of workers to request.
%
%	Returns:
%
%		jm - LSF scheduler object.
%
%% JSB 8/2014
function jm = setupPool(nHosts)

	jm = findResource('scheduler','type','lsf');
	set(jm, 'ClusterMatlabRoot','/opt/matlab-2013b');
	subArgs = ['-R "rusage[matlab_dc_lic=1]" -W 12:00 -q parallel'];
	set(jm, 'SubmitArguments',subArgs);

	if nHosts > 0 
		poolSize = matlabpool('size');
		if (poolSize > 0) && (poolSize < nHosts)
			matlabpool('close');
			disp('Closing existing pool...');
			matlabpool(jm, nHosts);
		elseif (poolSize == 0)
			matlabpool(jm, nHosts);
		end
	end


