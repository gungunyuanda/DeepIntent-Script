#此工具仅支持Linux和Macos!!!
cd /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/
#把apk名字加到selected.txt上(不包含'.apk')
python3 getAPKNames.py /home/gungun/gungunda/apks/

#进入gator-IconIntent文件夹，使用gator对apk进行解码
cd gator-IconIntent
#argv[1] Your apk folder directory
#argv[2] Your Android sdk directory
#argv[3] Your apktool.jar's directory, it is included in gator-IconIntent folder
python3 /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/gator-IconIntent/gator.py /home/gungun/gungunda/apks  /opt/sdk/android-sdk-linux/  /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/gator-IconIntent
#gator-IconIntent文件夹下有了output和log_output和dot_output文件夹和result.txt，
#output文件夹下有xxx.apk.json,
#log_output文件夹下有log，
#dot_output文件夹有xxx.apk.wtg.dot
#result.txt中写着各apk的结果

#将output文件夹移到外面来
mv /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/gator-IconIntent/output/ /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/
cd /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/

mkdir img2widgets
mkdir permission_output
mkdir dot_output

#寻找icon-widget-handler的联系
#argv[1]: Your apk folder directory
java -jar wid.jar /home/gungun/gungunda/apks
#多了logs文件 分别有debug、error、info log
#output文件夹下多了xxx.image.json和xxx.json

#argv[1] 上一步输出的output文件夹
#argv[2] 上一步输出的output文件夹
#argv[3] Static_Analysis文件夹
#argv[4] 包含需要处理的apk名字的selected.txt
java -jar ImageToWidgetAnalyzer.jar /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/output/ /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/output/ /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/  /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/selectedAPK.txt
#img2widgets文件夹下多了xxx_img2widgets.csv,表头为 APK	Image	WID	WID Name	Layout	Handler

#run ic3
#argv[1]: Your apk folder directory
sh /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/ic3/runic3.sh /home/gungun/gungunda/apks 
#output文件夹下的xxx.apk.json，xxx.image.json和xxx.json文件消失，出现了apk文件夹，下有xxx_version.txt,(如com.ssm.asiana_17.txt  cn.menue.iqtest_3.txt) 
#多了sootOutput和testspace文件夹,testspace文件夹下有xxx.apk 放着解码后的apk

#此步之前需先在cc中建一个新table outputmapping，表有两个字段，一个是Method，一个是Permission，数据从jellybean_allmappings.txt中引入
#寻找 handler-permission 的联系
for app in `ls /home/gungun/gungunda/apks/*.apk`
do
echo $app
#argv[1]: Your apk folder directory
#argv[2]: img2widgets文件夹
#argv[3]: permission_output文件夹
#argv[4]: ic3的output文件夹
java -jar APKCallGraph.jar $app  /home/gungun/gungunda/apks/ /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/img2widgets/ /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/permission_output/ /DeepIntent/IconWidgetAnalysis/Static_Analysis/ic3/output/
done
#permission_output文件夹下将出现xxx.csv 表头为 APK	Image	WID	WID Name	Layout	Handler	Method	Lines	Permissions
#dot_output文件夹下出了xxx文件夹 下面有xxx.dot文件

#combine results and get 1-to-more mapping using 1tomore.txt
python3 combine.py /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/permission_output/
#出现了permissions.csv 表头为"APK", "Image", "WID", "WID Name", "Layout", "Handler", "Method", "Permissions"

#change the input and output file names and paths at line 4, 5, and 6.
python3 map1tomore.py
#出现了 outputP.csv,这就是静态分析的最终的结果

#注意：以上的"xxx"均指代apk的名字(不包括后缀".apk")。