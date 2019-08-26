#!/bin/bash
jindu(){
for i in `seq 20`
do
  echo -n "#"
  sleep 0.3
done
}
jindu
echo -n "正在下载请稍等,此过程大约5分钟"
jindu
lj=/root/TTS/
mkdir $lj     &>/dev/null
for j in ADMIN ENGINEER SERVICES NETWORK SHELL OPERATION CLUSTER PROJECT1 RDBMS1 RDBMS2 NOSQL SECURITY PROJECT2 CLOUD ARCHITECTURE  PROJECT3  
do
for i in {1..10}
do
wget -p  -P $lj --http-user=18547502357 --http-passwd=zy343376 http://tts.tmooc.cn/ttsPage/LINUX/NSDTN201904/$j/DAY0$i/CASE/01/   &>/dev/null

done

for i in {1..10}
do
wget -p  -P $lj --http-user=18547502357 --http-passwd=zy343376 http://tts.tmooc.cn/ttsPage/LINUX/NSDTN201904/$j/DAY0$i/COURSE/ppt.html   &>/dev/null
done

for i in {1..10}
do
wget -p  -P $lj --http-user=18547502357 --http-passwd=zy343376 http://tts.tmooc.cn/ttsPage/LINUX/NSDTN201904/$j/DAY0$i/EXERCISE/01/index_answer.html  &>/dev/null
done
done
echo "下载完成,文件在 /root/TTS 目录中"
