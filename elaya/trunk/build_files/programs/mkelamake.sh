# This program creates  all Makefiles for all ela files.
#(C) copyright Jeroen van Iddekinge
#Under GPL License (TODO)

cd rtl
while true;
do  read filename
  iseof=$?
  if test "$iseof" != "0"; then break;fi
  echo "3:"
  echo $filename  $iseof
  l_dir=`pwd`
  cd $filename
  export lpath=""
  while [ ! -e build_files   ];
      do cd ..; pwd;
      if test "`pwd`" = "/" ; then break;fi
      lpath="${lpath}../"
  done
  cd $l_dir
  echo "1:"
  pwd
  cd $filename
  echo "2:"
  pwd

  echo "#auto generated please,don't edit" >Makefile
  echo "root_path=$lpath" >>Makefile
  if test -e Makefile.inc;then echo "include Makefile.inc" >>Makefile;fi
  echo 'include $(root_path)Makefile.ela' >>Makefile
  cd $l_dir
done
