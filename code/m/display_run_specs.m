% Displays the specifications for the current run
% To do: save the output and display nicely.
function display_run_specs(envvars_show,envvars_hide)
    % Display the generic stuff
	version
	version -java
	computer
	system('hostname');
	pwd
	feature('numCores');
	
	switch nargin
    case 0
        envvars_show = {};
        envvars_hide = {};
    case 1
        envvars_hide = {};
    case 2
	otherwise
		error('display_run_specs:TooManyInputs requires at most 2 optional inputs');
	end

	for i = 1:length(envvars_show)
		getenv(envvars_show{i})
	end
	for i = 1:length(envvars_hide)
		disp(strcat('LOGREMOVE ', getenv(envvars_show{i})))
	end
end