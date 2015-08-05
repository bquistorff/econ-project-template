#!/usr/bin/sed -bf

#### Standard R output ####

### Machine-specific
##OS-dependent: file path
s/^\(PWD: \).\+/\1-normalized-/g

### Hardware details
s/^\(Platform: \).\+/\1-normalized-/g

### R details
s/^\(R version \).\+/\1-normalized-/g

#### display_run_specs.ado ####
/^LOGREMOVE/d
s/^\(HOSTNAME: \).\+/\1-normalized-/g
s/^\(Time: \).\+/\1-normalized-/g

#### log_close ####
s/^user.self: .\+/user.self: -normalized- 	system: -normalized- 	elapsed: -normalized- /g
