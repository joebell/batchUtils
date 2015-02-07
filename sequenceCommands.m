%%
%	sequenceCommands.m
%
%	This function runs the commands in the cell array anonFuncs in sequence.
%
%	Args:
%
%		anonFuncs - A cell array of anonymous functions.
%
%	Example:
%
%		anonFuncs{1} = @() myFunc1(arg1, arg2);
%		anonFuncs{2} = @() myFunc2(arg1, arg2, arg3);
%		sequenceCommands(anonFuncs);
%	
%% JSB 8/2014
function sequenceCommands(anonFuncs)

	for funcN = 1:length(anonFuncs)

		feval(anonFuncs{funcN});

	end
