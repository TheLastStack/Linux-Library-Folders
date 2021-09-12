#!/bin/bash
folder=''
Home=`echo ~`
Music=$Home'/Music/'
Pictures=$Home'/Pictures/'
Videos=$Home'/Videos/'
Documents=$Home'/Documents/'
cDir=''
while read line
  do
  if [ `echo $line | grep '\:'` ] 
  then
    case ${line: 0:-1} in
      "music") cDir=$Music
      ;;
      "pictures") cDir=$Pictures
      ;;
      "videos") cDir=$Videos
      ;;
      "documents") cDir=$Documents
      ;;
    esac
    #echo $cDir #Debugging statement
  else
    folder=`echo $line | tr -d [:space:] | cut -c 2-`
    if [ -d $folder ]
    then
      if [ -d $cDir ]
      then
        #echo `ls $folder` #Debugging statement
        OIFS=$IFS
        IFS=$'\n'
        for afile in `ls -1 ${folder}` 
          do
          #echo ${afile} #Debugging statements
          #echo $folder$afile
          #echo $cDir$afile
          ln -s $folder$afile $cDir$afile &> /dev/null
        done
        IFS=$OIFS
      fi
    fi
  fi
done < 'library.yaml'
FOLDERS=($Music
$Pictures
$Videos
$Documents)
for direc in "${FOLDERS[@]}" 
  do
  OIFS=$IFS
  IFS=$'\n'
  for alink in `find $direc -xtype l`
    do
    unlink $alink
    #echo $alink #Debugging purpose
  done
  IFS=$OIFS
done
