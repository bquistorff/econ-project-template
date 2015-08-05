#! /usr/bin/env python
from os.path import join; 
import sys; 
sys.path = [ join(sys.prefix, 'Lib', 'site-packages', 'scons-2.3.5'), join(sys.prefix, 'Lib', 'site-packages', 'scons'), join(sys.prefix, 'scons-2.3.5'), join(sys.prefix, 'scons')] + sys.path; 
import SCons.Script; 
SCons.Script.main()
