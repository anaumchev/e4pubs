import os
import os.path
import shutil

dir = '.'
file = './autoproof.py'

for o in os.listdir (dir): 
    if os.path.isdir (os.path.join (dir, o)):
        shutil.copy(file, os.path.join (dir, o))
        

