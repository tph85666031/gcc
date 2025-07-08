#!/bin/bash

X_KEY=206418e43f2eda625af3917eb21c82e07205ee6a39412811f477a8304513c2ba
X_IV=3f8e524d4826f29327387c6a818505424ae58b9ee51328e5f477405463049142
X_MAGIC="\x9b\xaa\x31\xe1\x96\x41\x43\xa7\x05\x4a\x0e\x90\xc4\x40\x3d\x36\x6c\x87\x37\x41\x28\x2b\xa2\x7b\x73\xe3\x48\xcc\x4c\x0e\xa7\x72"

for file in $1/*.c $1/*.h;do
  echo -n -e ${X_MAGIC} | cmp -n 32 $file > /dev/null 2>&1
  if [ $? == 0 ];then
    echo "Failed: file already encrypted:${file}"
    continue
  fi
  openssl aes-256-cbc -e -v -nosalt -K ${X_KEY} -iv ${X_IV} -in ${file} -out ${file}.enc > /dev/null  2>&1
  echo -n -e ${X_MAGIC} > $file
  cat ${file}.enc >> $file
  rm ${file}.enc
  echo "Succeed: file encrypted:${file}"
done
