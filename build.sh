#!/bin/sh

# 库名
Library_Name=$1

Pod_Line=${myline}

echo "name="${Library_Name}
echo "Pod_Line="${Pod_Line}

# build生成静态库路径

Build_Lib_Arm_Dir=${Build_Dir}/build/${Library_Name}/arm

Build_Lib_i386_Dir=${Build_Dir}/build/${Library_Name}/i386x86_64

Build_Lib_Arm=${Build_Lib_Arm_Dir}/lib${Library_Name}.a

Build_Lib_i386=${Build_Lib_i386_Dir}/lib${Library_Name}.a

# 合并静态库后路径

Lib_Output=${Build_Dir}/output/${Library_Name}

if [ -d ${Lib_Output} ]; then
  rm -rf ${Lib_Output}
fi

mkdir -p ${Lib_Output}

# echo ${Lib_Output}/lib${Library_Name}.a

# podfile 生成

Pod_Content="target 'Template' do\n"${Pod_Line}"\nend"

echo ${Pod_Content} > Podfile

# pod install

pod install

# 开始 xcodebuild

xcodebuild -workspace Template.xcworkspace -scheme Template -configuration Release build CONFIGURATION_BUILD_DIR=${Build_Lib_Arm_Dir}

xcodebuild -workspace Template.xcworkspace -scheme Template -configuration Release clean build CONFIGURATION_BUILD_DIR=${Build_Lib_i386_Dir} ARCHS='i386 x86_64' VALID_ARCHS='i386 x86_64' -sdk iphonesimulator

# 合并静态库

lipo -create ${Build_Lib_Arm} ${Build_Lib_i386} -output ${Lib_Output}/lib${Library_Name}.a

# 复制头文件

cp ${Build_Lib_Arm_Dir}/*.h ${Lib_Output}

# 生成 Podspec

Final_Podspec=${Lib_Output}/${Library_Name}.podspec.json

cp Template.podspec.json ${Lib_Output}
mv ${Lib_Output}/Template.podspec.json ${Final_Podspec}

newvalue="s/name_temp/"${Library_Name}"/g"
sed -i '' ${newvalue} ${Final_Podspec}

# test=`sed "s/name_temp/"${Library_Name}"/g" ${Final_Podspec}`
# echo ${test} > ${Final_Podspec}
