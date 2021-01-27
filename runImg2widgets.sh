#�˹��߽�֧��Linux��Macos!!!
cd /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/
#��apk���ּӵ�selected.txt��(������'.apk')
python3 getAPKNames.py /home/gungun/gungunda/apks/

#����gator-IconIntent�ļ��У�ʹ��gator��apk���н���
cd gator-IconIntent
#argv[1] Your apk folder directory
#argv[2] Your Android sdk directory
#argv[3] Your apktool.jar's directory, it is included in gator-IconIntent folder
python3 /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/gator-IconIntent/gator.py /home/gungun/gungunda/apks  /opt/sdk/android-sdk-linux/  /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/gator-IconIntent
#gator-IconIntent�ļ���������output��log_output��dot_output�ļ��к�result.txt��
#output�ļ�������xxx.apk.json,
#log_output�ļ�������log��
#dot_output�ļ�����xxx.apk.wtg.dot
#result.txt��д�Ÿ�apk�Ľ��

#��output�ļ����Ƶ�������
mv /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/gator-IconIntent/output/ /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/
cd /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/

mkdir img2widgets
mkdir permission_output
mkdir dot_output

#Ѱ��icon-widget-handler����ϵ
#argv[1]: Your apk folder directory
java -jar wid.jar /home/gungun/gungunda/apks
#����logs�ļ� �ֱ���debug��error��info log
#output�ļ����¶���xxx.image.json��xxx.json

#argv[1] ��һ�������output�ļ���
#argv[2] ��һ�������output�ļ���
#argv[3] Static_Analysis�ļ���
#argv[4] ������Ҫ�����apk���ֵ�selected.txt
java -jar ImageToWidgetAnalyzer.jar /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/output/ /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/output/ /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/  /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/selectedAPK.txt
#img2widgets�ļ����¶���xxx_img2widgets.csv,��ͷΪ APK	Image	WID	WID Name	Layout	Handler

#run ic3
#argv[1]: Your apk folder directory
sh /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/ic3/runic3.sh /home/gungun/gungunda/apks 
#output�ļ����µ�xxx.apk.json��xxx.image.json��xxx.json�ļ���ʧ��������apk�ļ��У�����xxx_version.txt,(��com.ssm.asiana_17.txt  cn.menue.iqtest_3.txt) 
#����sootOutput��testspace�ļ���,testspace�ļ�������xxx.apk ���Ž�����apk

#�˲�֮ǰ������cc�н�һ����table outputmapping�����������ֶΣ�һ����Method��һ����Permission�����ݴ�jellybean_allmappings.txt������
#Ѱ�� handler-permission ����ϵ
for app in `ls /home/gungun/gungunda/apks/*.apk`
do
echo $app
#argv[1]: Your apk folder directory
#argv[2]: img2widgets�ļ���
#argv[3]: permission_output�ļ���
#argv[4]: ic3��output�ļ���
java -jar APKCallGraph.jar $app  /home/gungun/gungunda/apks/ /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/img2widgets/ /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/permission_output/ /DeepIntent/IconWidgetAnalysis/Static_Analysis/ic3/output/
done
#permission_output�ļ����½�����xxx.csv ��ͷΪ APK	Image	WID	WID Name	Layout	Handler	Method	Lines	Permissions
#dot_output�ļ����³���xxx�ļ��� ������xxx.dot�ļ�

#combine results and get 1-to-more mapping using 1tomore.txt
python3 combine.py /home/gungun/gungunda/ccs_codes/DeepIntent/IconWidgetAnalysis/Static_Analysis/permission_output/
#������permissions.csv ��ͷΪ"APK", "Image", "WID", "WID Name", "Layout", "Handler", "Method", "Permissions"

#change the input and output file names and paths at line 4, 5, and 6.
python3 map1tomore.py
#������ outputP.csv,����Ǿ�̬���������յĽ��

#ע�⣺���ϵ�"xxx"��ָ��apk������(��������׺".apk")��