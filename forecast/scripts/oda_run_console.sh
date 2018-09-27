#! /bin/bash
#
# Purpose : startup script for openDA applications
# Args    : -gui   to start the gui
#           -p     perform a parallel run
#           <file>  to open configuration file
# Examples: Application.sh               : starts gui
#           Application.sh -gui          : starts gui
#           Application.sh main.xml      : starts computations without gui
#           Application.sh -gui main.xml : starts gui and opens the configuration file main.xml
#           The main xml-file now often has the extension .oda
# Author  : M. verlaan
# License : GPL

#stop the script if a command fails
set -o errexit

# read local settings
if [ -z "$OPENDADIR" ];then
   echo "OPENDADIR not set! Run settings_local.sh to fix this"
   exit 1;
fi

#if [ ! -z "$OPENDALIB" ]; then
#   echo "setting path for OPENDALIB"
#   export LD_LIBRARY_PATH=$OPENDALIB:$LD_LIBRARY_PATH
#fi

# java options
if [ -z "$ODA_JAVAOPTS" ]; then
	export ODA_JAVAOPTS="-Xmx1024m -Djava.library.path=$OPENDALIB"
fi

# append all jars in opendabindir to java classpath
for file in $OPENDADIR/*.jar ; do
   if [ -f "$file" ] ; then
       export CLASSPATH=$CLASSPATH:$file
   fi
done

# starting from bin-directory is necessary for *.so loading now TODO fix this
if [ $# -eq 0 ] ; then
   java $ODA_JAVAOPTS org.openda.application.OpenDaApplication -gui
elif [ $# -eq 1 ]; then
   if [ "$1" == "-gui" ]; then
      java $ODA_JAVAOPTS org.openda.application.OpenDaApplication -gui
   else

      configFile=$1
      if [ ! -f $configFile ]; then
         echo "OpenDa config file $configFile not found"
         exit 1
      fi

      echo "========================================================================="
      echo Starting "java org.openda.application.OpenDaApplication"

      # start timing
      STARTRUN=`date +%s` 
      echo "$configFile" 
      date "+%F, %H:%M:%S" 

      # run application
      java $ODA_JAVAOPTS org.openda.application.OpenDaApplication $configFile

      # end timing
      date "+%F, %H:%M:%S"
      ENDRUN=`date +%s` 
      declare -i DURATION
      DURATION=($ENDRUN-$STARTRUN)
      echo DURATION, "$DURATION" 

      echo "Run finished"
      echo "========================================================================="

   fi
elif [ $# -eq 2 ]; then
   if [ "$1" != "-gui" -a  "$1" != "-p" ]; then
         echo "This scipt accepts no more than one file and option -gui or -p"
      exit 1
   fi
   if [ ! -f $2 ]; then
         echo "OpenDa config file $2 not found"
      exit 1
   fi
   java org.openda.application.OpenDaApplication $1 $2
else
   echo "This scipt accepts no more than one file and option -gui"
fi

