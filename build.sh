#!/usr/bin/env sh

cat <<EOF > localbuild.sh
export ACCEPT_EULA=Y

export ODBCINI=/opt/odbc.ini
export ODBCSYSINI=/opt/
export CFLAGS="-I/opt/include"
export LDFLAGS="-L/opt/lib"

cd /tmp
curl ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.7.tar.gz -s --output unixODBC.tgz
tar zxvf unixODBC.tgz
cd unixODBC*

./configure --sysconfdir=/opt --disable-gui \
  --disable-drivers --enable-iconv \
  --with-iconv-char-enc=UTF8 --with-iconv-ucode-enc=UTF16LE \
  --prefix=/opt

make
make install

curl https://packages.microsoft.com/config/rhel/6/prod.repo > /etc/yum.repos.d/mssql-release.repo

yum install -y e2fsprogs
yum install -y --disablerepo=amzn* unixODBC unixODBC-devel
yum install -y msodbcsql17

cd /opt
mv microsoft/* .
rm -r microsoft/
sed -i'' 's#/opt/microsoft/#/opt/#g' odbcinst.ini
EOF

docker run -v "$PWD/layer":/opt -v "$PWD/localbuild.sh":/localbuild.sh -it --rm lambci/lambda:build-python3.7 sh /localbuild.sh
rm -f localbuild.sh layer.zip

cd layer/
zip -r9 ../layer.zip .
cd ..

rm -rf layer/
