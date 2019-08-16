#! /bin/bash 


# 一级目录
PPT_PATH='TMOOC'
[ ! -d ${PPT_PATH} ] && mkdir ${PPT_PATH} || echo -e "\033[32m\t${PPT_PATH}已创建\033[0m"


# cookie缓存
Julian_cookie='Cookie:eBoxOpenNSDTN201904=true; eBoxOpenNSDTN201801=true; eBoxOpenAIDTN201903=true; TMOOC-SESSION=F15C24489ACA4D9983B15140446948E4; Hm_lvt_51179c297feac072ee8d3f66a55aa1bd=1565143728,1565266060,1565502423,1565667752; Hm_lpvt_51179c297feac072ee8d3f66a55aa1bd=1565784971; sessionid=F15C24489ACA4D9983B15140446948E4|E_bfuo0k5; cloudAuthorityCookie=0; versionListCookie=AIDTN201903; defaultVersionCookie=AIDTN201903; versionAndNamesListCookie=AIDTN201903N22NPython%25E4%25BA%25BA%25E5%25B7%25A5%25E6%2599%25BA%25E8%2583%25BD%25E5%2585%25A8%25E6%2597%25A5%25E5%2588%25B6%25E8%25AF%25BE%25E7%25A8%258BV06; courseCookie=AID; stuClaIdCookie=699459; JSESSIONID=34EDA738B2B3CBAA1286EC685FB87AE3; tedu.local.language=zh-CN; Hm_lvt_e997f0189b675e95bb22e0f8e2b5fa74=1565784918,1565785002,1565785465,1565785490; Hm_lpvt_e997f0189b675e95bb22e0f8e2b5fa74=1565785490; isCenterCookie=yes' 

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
    echo -e "\033[31m\t本机尚未安装wkhtmltopdf\033[0m"
    sleep 1 ; exit 0
fi 
