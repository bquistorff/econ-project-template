function log_open(base_name)
	log_name = ['log/m/', base_name, '.log'];
	delete(log_name) %otherwise it appends
	diary(log_name)
	d_str = datestr(now);
	disp([' opened on: ', d_str])
end
