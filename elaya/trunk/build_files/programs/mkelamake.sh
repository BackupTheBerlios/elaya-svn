cd rtl
while true;
do  read filename
iseof=$?
if test "$iseof" != "0"; then break;fi
echo $filename  $iseof
pwd
pushd .
cd $filename
export lpath=""
pushd .
while [ ! -e build_files   ];
      do cd ..; pwd;
      if test "`pwd`" = "/" ; then break;fi
      lpath="${lpath}../"
done
popd

echo "all:all_ela" >Makefile
echo "root_path=$lpath" >>Makefile
if test -e Makefile.inc;then echo "include Makefile.inc" >>Makefile;fi
echo 'include $(root_path)Makefile.ela' >>Makefile
popd
done
