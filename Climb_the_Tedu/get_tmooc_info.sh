#! /bin/bash 


# 一级目录
PPT_PATH='TMOOC'
[ ! -d ${PPT_PATH} ] && mkdir ${PPT_PATH} || echo -e "\033[32m\t${PPT_PATH}已创建\033[0m"


# cookie缓存
Julian_cookie='Cookie:Hm_lvt_51179c297feac072ee8d3f66a55aa1bd=1565143728,1565266060,1565502423; Hm_lpvt_51179c297feac072ee8d3f66a55aa1bd=1565502423; TMOOC-SESSION=07FAD4349D4E4E42A8E2E076AA252D5F; sessionid=07FAD4349D4E4E42A8E2E076AA252D5F|1152688049%40qq.com; cloudAuthorityCookie=0; versionListCookie=NSDTN201904; defaultVersionCookie=NSDTN201904; versionAndNamesListCookie=NSDTN201904N22NLinux%25E4%25BA%2591%25E8%25AE%25A1%25E7%25AE%2597%25E5%2585%25A8%25E6%2597%25A5%25E5%2588%25B6%25E8%25AF%25BE%25E7%25A8%258BV07; courseCookie=LINUX; stuClaIdCookie=576746; JSESSIONID=FA444ED65E56489542E2BB9D4EB9DBF4; tedu.local.language=zh-CN; Hm_lvt_e997f0189b675e95bb22e0f8e2b5fa74=1565396707,1565502259,1565502430,1565503236; Hm_lpvt_e997f0189b675e95bb22e0f8e2b5fa74=1565503236; isCenterCookie=yes' 

# 一级URL
tmooc_URL='http://tts.tmooc.cn/studentCenter/toMyttsPage'

# 访问一级URL;获取相应URL
source_web=`curl --cookie "${Julian_cookie}" -s "${tmooc_URL}"` 

# 筛选PPT_URL 
PPT_URL=`echo "${source_web}" | awk -F [\"\"] '/<li class="ppt"/{print $6}'` 

# 筛选PDF_URL 
PDF_URL=`echo "${source_web}" | awk -F [\"\"] '/<li class="al"/{print $6}'`

# 筛选Video_URL
VIDEO_URL=`echo "${soruce_web}" | awk -F [\"\"] '/<li class="sp"/{print $6}'`


# 下载PPT
function DOWNLOAD_PPT() { 

    # 访问二级URL;获取PPT的URL 
    for url in ${PPT_URL} 
    do  
        # 二级目录;筛选PPT标题
        title=$(echo ${url} | awk -F [\/] '{print $7}')
        mkdir ${PPT_PATH}/${title}
    
        # 三级目录;存储PPT
        title_01=$(echo ${url} | awk -F [\/] '{print $8}')
        mkdir ${PPT_PATH}/${title}/${title_01}
        
    
        # 访问三级URL;获取图片URL 
        source_str=`curl -H 'Content-Type:application/javascript;charset=UTF-8' $url`
        
        # 获取url头部
        url_01=${url%/*}
        # 获取url尾部
        img_str=$(echo "${source_str}" | sed -n 's/.*src="//p' | sed -n 's/".*//p')
        
        
        # 循环遍历下载PPT
        for url_02 in ${img_str} 
        do
            # 下载PPT图片
    	    wget ${url_01}/${url_02} --directory-prefix=${PPT_PATH}/${title}/${title_01}
        done 
    done
} 

# DOWNLOAD_PPT 


# 下载PDF
function DOWNLOAD_PDF() { 

    for url in ${PDF_URL} 
    do 
        # 二级目录;筛选PDF标题
        title=$(echo ${url} | awk -F [\/] '{print $7}')
        # echo ${PPT_PATH}/${title}

        # 三级目录;存储PDF
        title_01=$(echo ${url} | awk -F [\/] '{print $8}')
        # echo ${PPT_PATH}/${title}/${title_01}
	
	# 将网页转换为PDF格式
	wkhtmltopdf ${url} ${PPT_PATH}/${title}/${title_01}/${title_01}.pdf 
	if [ $? -eq 0 ]; then 
	    echo "${PPT_PATH}/${title}/${title_01}.pdf 已转换保存" 
	else 
            echo -e "\033[31m\t转换PDF格式失败;可能未安装所需软件包: wkhtmltopdf\033[0m"
	    exit 0 
	fi
    done 
} 


# 检测运行环境
which wkhtmltopdf 
if [ $? -eq 0 ]; then 
    DOWNLOAD_PPT 
    DOWNLOAD_PDF
else 
    read -p "是否安装所需软件包 wkhtmltopdf (Y/N)" request 
    [ "${request}" == "Y" ] && yum -y install wkhtmltopdf 
    
    if [ $? -eq 0 ]; then 
        DOWNLOAD_PPT 
        DOWNLOAD_PDF
    else 
        echo -e "\033[31m\t安装wkhtmltopdf失败\033[0m"
        exit 0 
    fi 
fi 

