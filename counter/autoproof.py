import sys
import os, os.path
import shutil
from subprocess32 import call, TimeoutExpired

curdir = os.getcwd()
ccap = "/var/www/comcom/executables/autoproof"
to = 120
output_boogie = '-nadia'

path = sys.argv[-1]
if os.path.isfile(path):
    dir, fn = os.path.split(os.path.abspath(path))
    # cd dir
    os.chdir(dir)

    shutil.copy(os.path.join(ccap, "app.ecf"), ".")
    #shutil.copy(os.path.join(ccap, "com_list.e"), ".")

    args = sys.argv[1:-1] # starting from 2 to ignore the spurious empty argument
    try:
        args.remove('')
        args.remove(output_boogie)
    except ValueError:
        pass # who cares
    args = ['-batch', '-output_file', 'out', '-config', 'app.ecf', '-target', 'app', '-verify', fn, '-verify', 'html:true']
else:
    exit()

# set environment variables
os.environ['ISE_PLATFORM'] = 'linux-x86-64'
os.environ['ISE_C_COMPILER'] = 'gcc'
os.environ['ISE_EIFFEL'] = '/usr/local/Eiffel_21.11'
os.environ['ISE_LIBRARY'] = os.getenv("ISE_EIFFEL")
os.environ['ISE_PRECOMP'] = os.path.join(os.getenv("ISE_EIFFEL"), 'precomp', 'spec', 'linux-x86-64')
os.environ['PATH'] = os.path.join(os.getenv("ISE_EIFFEL"), 'studio', 'tools', 'boogie') + os.pathsep + os.path.join(os.getenv("ISE_EIFFEL"), 'studio', 'spec', os.getenv("ISE_PLATFORM"), 'bin') + os.pathsep + os.environ['PATH']

try:
    with open('/tmp/err_log.txt', 'w') as f: 
        call(["ec_ap"] + args, timeout=to, stderr=f)
        f.close()
except TimeoutExpired:
    print "Terminated due to timeout of", to, "seconds"



for o in sys.argv:
    if o == output_boogie:
        import cgi
        print '\n<pre><code>\n';
        with open('EIFGENs/app/Proofs/autoproof0.bpl', 'r') as f:
            print cgi.escape(f.read())
        print '\n</code></pre>\n';
        
os.chdir(curdir)        
