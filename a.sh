#/bin/bash

a=0

b=0

for n in {1..245}

do

ping -c 3 -i 0.2 -w 1  176.19.2.$n &> /dev/null

if [ $? -eq 0 ];then

echo "176.19.2.$n 通了" >> ip2.txt
echo "176.19.2.$n"
let a++

else

echo "176.19.2.$n 不通"  &> /dev/null

let b++

fi

done

echo "${a}台ok,${b}台no"
