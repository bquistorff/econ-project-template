%Not needed when calling from command-line
clear all %doesn't reset the path
close all

echo on %show commands along with the output (helpful for logging)

%graymon

%rng(1337) %By default uses Mersenne Twister with seed 0

if exist('testing','var')==0
	testing=0;
end
if exist('verbose','var')==0
	verbose=0;
end

%Specify a default save format 
% (not even v6 doesn't make them platform indepedent & byte equal across runs)
%com.mathworks.services.Prefs.setStringPref('MatfileSaveFormat','v6')
%com.mathworks.services.Prefs.getStringPref('MatfileSaveFormat') == 'v6'

%Get any environment variables
%N = getenv('name')

display_run_specs()
