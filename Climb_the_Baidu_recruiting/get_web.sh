#! /bin/bash 

read -p "输入城市:" city
read -p "输入岗位:" query 


# 编译URL
query_coding=$(echo "${query}" | xxd --plan | sed 's/\(..\)/%\1/g')
city_coding=$(echo "${city}" | xxd --plain | sed  's/\(..\)/%\1/g')
query_coding=${query_coding%\%*}
city_coding=${city_coding%\%*}

# https://zhaopin.baidu.com/quanzhi?city=%E5%8C%97%E4%BA%AC&query=%E4%BA%91%E8%AE%A1%E7%AE%97 
URL="https://zhaopin.baidu.com/quanzhi?query=${query_coding}&city=${city_coding}"  
# curl -H 'Content-Type:text/html;charset=utf-8' "${URL}" > index_url.txt 
echo "${URL}" > index_url.txt 
