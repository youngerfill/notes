=============
Pygments test
=============

C++ program
===========
.. highlight:: c++

::

    #include <iostream>

    using namespace std;

    int main()
    {
      cout << "Hello world!" << endl;
      return 0;
    }


C program
=========
.. highlight:: c

::

    #include <stdlib.h>
    #include <stdio.h>
    #include <dlfcn.h>


    int main(int argc, char **argv)
    {
      void *handle;
      char *error;
      void (*fun)();
      char fileName[300];
      char* buildDir = getenv("BUILD_DIR");

      sprintf(fileName, "%s/toolkit/libtoolkit.so.1.0.0", buildDir);
      printf("fileName = %s\n", fileName);

      printf("mark1\n");

      dlerror();
      handle = dlopen ( fileName , RTLD_LAZY);
      if (!handle) {
          fputs (dlerror(), stderr);
            printf("\n");
          exit(1);
      }

      printf("mark2\n");

      fun = (void (*)()) dlsym(handle, "testfun1");
      if ((error = dlerror()) != NULL)  {
          fputs(error, stderr);
            printf("\n");
          exit(1);
      }

      printf("mark3\n");

      (*fun)();

      printf("mark4\n");

      dlclose(handle);

    }


Python program
==============
.. highlight:: python

::

 def my_function():
     "just a test"
     print 8/2


bash script
===========
.. highlight:: bash

::

    #!/bin/bash

    if [ -z "$1" ]; then
      echo "Usage: $(basename $0) COMMAND"
      exit 0
    fi

    . ~/tools/common.sh
    if [ "$?" -ne "0" ]; then
      echo "$0: Error while sourcing ~/tools/common.sh" >&2
      exit 1
    fi

    checkPrereq ~/tools/timestamp_id
    checkPrereq ~/tools/fullts

    logDir=${LOGOP_DIR:-~/log}
    fileName="$(timestamp_id).txt"
    logFile="$logDir/$fileName"

    # Obtain path to external time command, to avoid having to use
    # the limited shell built-in command.
    timeCmd=$(which time)

    # Print header
    echo ====  Start log: `date '+%Y-%m-%d %H:%M:%S'` | tee -a "$logFile"
    echo ==== Command: $*  | tee -a "$logFile"
    echo ==== Logfile: $logFile | tee -a "$logFile"
    echo ==== Logscript: $(readlink -f $0)  | tee -a "$logFile"
    echo  | tee -a "$logFile"

    # Run the command and log its output
    $timeCmd -f "\n==== Exit status: %x\n==== Elapsed: %e seconds" $* 2>&1 | tee -a "$logFile"

    # Print footer
    echo ====  End log: `date '+%Y-%m-%d %H:%M:%S'` | tee -a "$logFile"

    # Update symlink 'latest.txt' to point to latest logfile
    ln -sf "$fileName" "$logDir/latest.txt"
