function log_open(base_name)
	log_name = strcat('../log/m/', base_name, '.log')
	delete log_name %otherwise it appends
	diary(log_name)
	disp(strcat('log opened on: ', datestr(datetime())))
end