#!/bin/bash

# 打包脚本使用说明：
# 1.修改：yz_cocopods、yz_project、yz_scheme参数
# 2.执行：./archive.sh 默认打 Debug 包
# 3.执行：./archive.sh Release 打 Release 包

# 用Cocopods管理的.xcworkspace项目,赋值true；用Xcode默认创建的.xcodeproj,赋值false
yz_cocopods=true
# 工程名称(project的名称)
yz_project=YZAuthID
# scheme名称（也就是工程的target名称）
yz_scheme=YZAuthID
# Debug Release
if [ -z $1 ]; then
	yz_configuration=Debug
else
	yz_configuration=$1
fi
# method，打包的方式（方式分别为 development, ad-hoc, app-store, enterprise）
yz_method=development
# 日期时间
yz_date=`date +%Y%m%d_%H%M%S`
# 获取当前脚本所在目录
yz_script_path=$( cd $( dirname $0 ) && pwd )
# 工程目录
yz_project_path=$yz_script_path
# 指定输出导出文件夹路径
yz_export_path=$yz_project_path/package/$yz_date
# 指定输出归档文件路径
yz_export_archive=$yz_export_path/$yz_scheme.xcarchive
# 指定输出ipa名称
yz_export_ipa=$yz_export_path/$yz_scheme.ipa
# 指定导出ipa包需要用到的plist配置文件的路径
yz_export_options_plist=$yz_project_path/ExportOptions.plist

#  下面两个参数只是在手动指定Pofile文件的时候用到，如果使用Xcode自动管理Profile,直接留空就好
# (跟method对应的)mobileprovision文件名，需要先双击安装.mobileprovision文件.手动管理Profile时必填
yz_mobileprovision_name=""
# 项目的bundleID，手动管理Profile时必填
yz_bundle_identifier=""

# 输出参数
echo --------------------脚本配置参数检查--------------------
echo yz_cocopods=$yz_cocopods
echo yz_project=$yz_project
echo yz_scheme=$yz_scheme
echo yz_configuration=$yz_configuration
echo yz_method=$yz_method
echo yz_date=$yz_date
echo yz_script_path=$yz_script_path
echo yz_project_path=$yz_project_path
echo yz_export_path=$yz_export_path
echo yz_export_archive=$yz_export_archive
echo yz_export_ipa=$yz_export_ipa
echo yz_export_options_plist=$yz_export_options_plist

if [[ "Debug" != $yz_configuration ]] && [[ "Release" != $yz_configuration ]]; then
	echo "参数yz_configuration=${1}不正确，yz_configuration取值范围：Debug（默认）、Release"
	exit 1
fi

# 开发打包
echo --------------------自动打包脚本执行--------------------

# 进入项目工程目录
cd $yz_project_path

# 指定输出文件目录不存在则创建
if [ -d $yz_export_path ] ; then
	echo $yz_export_path
else
	mkdir -pv $yz_export_path
fi

# 判断是Cocoapods还是Xcode项目
if $yz_cocoapods ; then

echo -------------------Cocoapods 项目打包-------------------

# pods 添加
pod install

# 打包脚本执行
xcodebuild archive \
-workspace $yz_project.xcworkspace \
-scheme $yz_scheme \
-configuration $yz_configuration \
-archivePath $yz_export_archive \
clean \
build

else

echo ---------------------Xcode 项目打包---------------------

xcodebuild archive \
-project $yz_project.xcodeproj \
-scheme $yz_scheme \
-configuration $yz_configuration \
-archivePath $yz_export_archive \
clean \
build

fi

# 检查构建是否成功
if [ -d $yz_export_archive ] ; then
	echo "项目构建成功，开始导出 ipa 文件🚀🚀🚀"
else
	echo "项目构建失败😢😢😢"
	exit 1
fi

# 先删除yz_export_options_plist文件
if [ -f $yz_export_options_plist ] ; then
	rm -rf $yz_export_options_plist
fi

# 根据参数生成export_options_plist文件
/usr/libexec/PlistBuddy -c  "Add :method String ${yz_method}"  $yz_export_options_plist
/usr/libexec/PlistBuddy -c  "Add :provisioningProfiles:"  $yz_export_options_plist
/usr/libexec/PlistBuddy -c  "Add :provisioningProfiles:${yz_bundle_identifier} String ${yz_mobileprovision_name}"  $yz_export_options_plist

# 导出ipa文件
xcodebuild  -exportArchive \
            -archivePath $yz_export_archive \
            -exportPath $yz_export_path \
            -exportOptionsPlist $yz_export_options_plist \
            -allowProvisioningUpdates            

# 检查ipa文件是否存在
if [ -f $yz_export_ipa ] ; then
	echo "导出 ipa 包成功🎉🎉🎉"
	open $yz_export_path
else
	echo "导出 ipa 包失败😢😢😢"
	exit 1
fi

# 删除 yz_export_options_plist 文件（中间文件）
if [ -f $yz_export_options_plist ] ; then
	rm -f $yz_export_options_plist
fi

# 输出打包总用时
echo "使用脚本打包总耗时：${SECONDS}s"
