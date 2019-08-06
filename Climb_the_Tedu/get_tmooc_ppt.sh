#! /bin/bash 

PPT_path='tmooc_ppt'


# 筛选 PPT 标题目录
function get_title() { 
    title=$(echo "$web_string" | sed -n 's/<h2>//p' | sed -n 's/<\/h2>//p') 
    title_01=$(echo $title | awk '{print $1}') 
    title_02=$(echo $title | awk '{print $2}') 
} 

# 创建 PPT 存储目录
function mkdir_title_file() {
    # 获取标题
    get_title 

    new_title=""
    new_title+="$title_01"
    
    # 根据标题创建ppt存储目录
    if [ ! -d "$new_title" ]; then 
        mkdir -p "$PPT_path/$new_title"
	# 记录新的文件目录
	new_PPT_path="$PPT_path/$title_01"
        # echo "$new_PPT_path"
    fi 

    # 记录新文件目录的子目录
    new_title+="_$title_02"
    new_title="$new_PPT_path/$new_title"
    
    # 创建ppt存储目录子目录
    if [ ! -d "$new_title" ]; then 
        mkdir "$new_title"
    fi 
}


# 下载ppt文件
function get_ppt() { 
    mkdir_title_file
    # ppt_number=`echo "$web_string" | grep '<img' | wc -l` 
    # img_str=$(echo "$web_string" | grep  '<img') 
    
    new_url=${url%/*}
    echo "$new_url"
    
    # 筛选 ppt 文件 
    img_str=$(echo "$web_string" | sed -n 's/.*src="//p' | sed -n 's/".*//p')  
    
    # 根据url下载ppt文件 
    for i in $img_str
    do
       wget "$new_url/$i" -P "$new_title"  
       [ $? -eq 0 ] && echo "$new_url/$i 下载成功" || echo "下载失败"
       # echo "$new_title" 
    done 
} 


# 遍历url文件获取源码
for i in `cat tmooc_ppt_url.txt`
do
    url="$i" 
    # echo "$url" 
    web_string=`curl -H 'Content-Type:application/javascript;charset=UTF-8' $url `
    get_ppt 
done 
