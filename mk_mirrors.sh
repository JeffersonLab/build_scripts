#!/bin/bash
nmirrors=100
echo Number of mirrors = $nmirrors
mirror_dir=/work/halld/ccdb_sqlite
echo Mirror directory = $mirror_dir
mkdir -pv $mirror_dir/tmp
cd $mirror_dir/tmp
echo pwd = `pwd`
cp -v /group/halld/www/halldweb/html/dist/ccdb.sqlite .
for i in `seq 1 $nmirrors`;
do
     target_dir=../$i
     mkdir -pv $target_dir
     cp -pv ccdb.sqlite ccdb.sqlite.tmp
     mv -v ccdb.sqlite.tmp $target_dir/ccdb.sqlite
done
