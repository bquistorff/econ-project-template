#!/usr/bin/sed -f

s|\(<xmp:\w\+Date>\)[-0-9TZ:]\+\(</xmp:\w\+Date>\)|\12015-01-01T01:11:11Z\2|g
s|D:[0-9]\+Z|D:12015010101111Z|g
s|uuid:[-0-9a-z]\+|uuid:4c503234-a2b5-11e4-0000-0c2c18598e3f|g
s|/ID \[<[0-9A-F]\+> \?<[0-9A-F]\+>|/ID [<0A3CB2BE6CA192C50EDBD15A1258B512><0A3CB2BE6CA192C50EDBD15A1258B512>|g
