% Displays the specifications for the current run
% To do: save the output and display nicely.
function display_run_specs(envvars_show,envvars_hide)
    % Display the generic stuff
	v1 = version;
	disp(['Version: ', v1])
	v2=version('-java');
	disp(['Version (Java): ', v2])
	c = computer;
	disp(['Computer: ', c])
	p = pwd;
	disp(['PWD: ', p])
	disp(['numCores: ',int2str(feature('numCores'))]);
	
	[ret, name] = system('hostname');   
	if ret ~= 0,
		 if ispc
				name = getenv('COMPUTERNAME');
		 else      
				name = getenv('HOSTNAME');      
		 end
	end
	name = strtrim(lower(name));
	disp(['hostname: ', name])
	
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
		disp([envvars_show{i}, ': ', getenv(envvars_show{i})])
	end
	for i = 1:length(envvars_hide)
		disp(['LOGREMOVE ', envvars_hide{i}, ': ', getenv(envvars_hide{i})])
	end
end