#!/bin/bash

INSTALL_ROOT=`pwd`

git clone https://github.com/paskma/pypy-sc.git
svn co http://codespeak.net/svn/py/dist/py@60839
ln -s ../py pypy-sc/py
git clone https://github.com/paskma/framework-parlib.git

wget http://www.python.org/ftp/python/2.4.4/Python-2.4.4.tgz
tar xf Python-2.4.4.tgz
cd Python-2.4.4
patch -p1 < ../framework-parlib/misc/disable_hash.patch
./configure --prefix=$INSTALL_ROOT/python24
make
make -i install
cd ..

wget -O jasmin-2.2.zip http://sourceforge.net/projects/jasmin/files/jasmin/jasmin-2.2/jasmin-2.2.zip/download
unzip jasmin-2.2.zip

svn checkout https://javapathfinder.svn.sourceforge.net/svnroot/javapathfinder/trunk -r 1790 jpf_trunk
cd jpf_trunk
java RunAnt run-tests
cd ..

echo "PARLIB_FRAMEWORK_ROOT=\"$INSTALL_ROOT/framework-parlib\"" > framework-parlib/environment.sh
echo "PYPY_ROOT=\"$INSTALL_ROOT/pypy-sc\"" >> framework-parlib/environment.sh
echo "PYTHON_BIN=\"$INSTALL_ROOT/python24/bin/python\"" >> framework-parlib/environment.sh
echo "JPF_ROOT=\"$INSTALL_ROOT/jpf_trunk\"" >> framework-parlib/environment.sh
echo "JASMIN_JAR=\"$INSTALL_ROOT/jasmin-2.2/jasmin.jar\"" >> framework-parlib/environment.sh

cd framework-parlib/binding/c
./compile.sh
cd ../../..

# We need to make user execute this command in his shell:
#export PATH="$INSTALL_ROOT/framework-parlib/bin:$PATH"

echo "Execute the following command in your shell:"
echo -n 'export PATH="'
echo -n $INSTALL_ROOT
echo '/framework-parlib/bin:$PATH"'




