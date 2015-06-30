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

%Get any environment variables
%N = getenv('name')

echo display_run_specs on
display_run_specs()
