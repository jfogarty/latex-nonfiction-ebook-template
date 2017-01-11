#!/usr/bin/python
# Rescale .xbb file values for epub formatting.
# ----------------------------------------------------------------------------
# LaTeX eBook utility tools
# -----------------------------------------------------------------------------
# John Fogarty - https://github.com/jfogarty - johnhenryfogarty@gmail.com
# -----------------------------------------------------------------------------
import fileinput
import fnmatch
import glob
import os
import shutil
import StringIO as sio
import sys, getopt

options = {
        'quiet'    : False,
        'verbose'  : False,
        'trial'    : False,
        'debug'    : False,
        'factor'   : 2,
        'ext'      : 'xbb',
        'dir'      : '.',
        'stringIO' : False,
    }
    
def printf(f, *args):
    if '{0' in f:
        print(f.format(*args))
    else:
        print(f % args)

def println(*args):
    if len(args) == 0:
        print
    else:
        for arg in args:    
            print(arg),
        endarg=args[-1]            
        if type(endarg) is str:
            if len(endarg) == 0:
                print
            elif endarg[-1] != '\n':
                print

def perror(*args):
    println("** Error:", *args)
    sys.exit(3)
    
def dbgprint(*args):
    if options['debug']:
        println(*args)

def qprint(*args):
    if not options['quiet']:
        println(*args)

def vprint(*args):
    if options['verbose']:
        println(*args)    

def dbgprintf(f, *args):
    if options['debug']:
        printf(f, *args)
        
def qprintf(f, *args):
    if not options['quiet']:
        printf(f, *args)

def vprintf(f, *args):
    if options['verbose']:
        printf(f, *args)
               
def fix_line(line, start, fn):
    if line.startswith(start):
        nvals = [fn(x) for x in line.split()[1:]]
        line = start + ' '.join(nvals) + '\n'
    return line

def doxbb(fn):
    factor=float(options['factor'])
    dbgprint("----------------------------------------------------------------")
    if options['stringIO']:
        vprintf("- Processing \"%s\"", fn)
        toFile = sio.StringIO()
        with open(fn) as f:
            allFile = f.read().split('\n')
        lineNum = 0
        for line in allFile:
            lineNum += 1
            if lineNum < len(allFile): # Don't create extra blank line at
                line = line + '\n'     # end of file on each execution.
            line = fix_line(line, '%%BoundingBox: ', 
                lambda x : str(int(int(x) * factor)))
            line = fix_line(line, '%%HiResBoundingBox: ', 
                lambda x : str(float(x) * factor))
            dbgprint(line)  # Debugging only
            toFile.write(line)
        if not options['trial']:
            with open(fn, "w") as outf:
                outf.write(toFile.getvalue())
        toFile.close()
    else:
        fo = os.path.splitext(fn)[0]+'.ybb'
        vprintf("- Processing \"%s\" to \"%s\"", fn, fo)
        toFile = sio.StringIO()
        with open(fn) as f, open(fo, 'w') as toFile:
            for line in f:
                line = fix_line(line, '%%BoundingBox: ', 
                    lambda x : str(int(int(x) * factor)))
                line = fix_line(line, '%%HiResBoundingBox: ', 
                    lambda x : str(float(x) * factor))
                dbgprint(line)  # Debugging only
                if not options['trial']:
                    toFile.write(line)
        if not options['trial']:
            shutil.move(fo, fn)

def do_on_all_files(dirpath, ffilter, func):
    fileset = [os.path.join(dirpath, f)
        for dirpath, dirnames, files in os.walk(dirpath)
        for f in fnmatch.filter(files, ffilter)]
    qprintf("- Found %d %s files to process.", 
        len(fileset), options['ext'])
    for fn in fileset:
        dbgprintf("--- File: %s", fn)
        func(fn)
    qprintf("- Processed %d files%s.", len(fileset),
        " (NOTE: TRIAL MODE - nothing done)" if options['trial'] else '')

def run():
    dirpath = options['dir']
    qprintf("- Processing XBB files in '{0}'", dirpath)
    do_on_all_files(dirpath, '*.' + options['ext'], doxbb)
    qprint("- Done.")

def usage():
    printf("Usage: {0} [options] [dir]", options['scriptName'])
    printf("Rescale .xbb (image bounding box) file values for epub formatting.")
    printf('')
    printf("Options:")
    printf("  -q      : (--quiet) no output")
    printf("  -v      : (--verbose) lots of output")
    printf("  -t      : (--trial) trial mode, makes no changes")
    printf("  -e[ext] : (--ext) file extension to act on [{0}]",
        options['ext'])
    printf("  -d[dir] : (--dir) directory to process [{0}]",
        options['dir'])
    printf("  --factor [n] : Scaling factor [{0}]",
        options['factor'])
    printf('') 

def main(argv):
    try:
        opts, args = getopt.getopt(argv,'hqvtd:e:',[
            'quiet', 'verbose', 'trial', 'debug', 'stringIO',
            'dir=', 'ext=', 'factor='])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            usage()
            sys.exit()
        elif opt in ('-q', '--quiet'):
            options['quiet'] = True
        elif opt in ('-v', '--verbose'):
            options['verbose'] = True
        elif opt in ('-t', '--trial'):
            options['trial'] = True
        elif opt in ('--stringIO'):
            options['stringIO'] = True
        elif opt in ('--debug'):
            options['debug'] = True
        elif opt in ('--factor'):
            options['factor'] = float(arg)
        elif opt in ('-d', '--dir'):
            options['dir'] = arg
        elif opt in ('-e', '--ext'):
            options['ext'] = arg
        if len(args) > 0:
            if len(args) > 1:
                perror("Only one [dir] argument may be supplied")
            options['dir'] = args[0]
    dbgprint(options, '\n')
    run()

if __name__ == "__main__":
   options['scriptName'] = sys.argv[0]
   main(sys.argv[1:])
# - End of python script.
   
