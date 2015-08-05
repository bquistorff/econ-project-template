function log_close()
	disp(strcat('log closed on: ', datestr(datetime())))
	diary off
end