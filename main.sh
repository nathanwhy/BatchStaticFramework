#!/bin/sh

# 脚本路径--根目录

Build_Dir=$(cd `dirname $0`; pwd)

cd ${Build_Dir}

# 删掉缓存

if [ -d ${Build_Dir}/build ]; then
  rm -rf ${Build_Dir}/build
fi

rm -rf ${Build_Dir}/Podfile.lock
rm -rf ${Build_Dir}/Pods
rm -rf ${Build_Dir}/Podfile

touch Podfile

# 开始生成静态库

while read myline
do
    if [[ ${myline} == *"pod"* ]]; then
	    # 截取 Library
	    podline=${myline}
	    lib=${myline#*\'}
	    lib=${lib%%\'*}
	    echo "Library:"${lib}
	    echo ${myline}
	    source build.sh ${lib} ${podline}
    fi
done < Podfile_Main