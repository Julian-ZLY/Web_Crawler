#! /bin/bash 

# 存储二级URL地址文件
Index_url="./web_file/index_url.txt"
rm -rf ${Index_url}

Result=`date +%Y-%m-%d_%T`

# 一级域名cookie缓存
Julian_cookie='cookie:_uab_collina=156515790500120207873583; lastCity=101200100; _uab_collina=156523336605563703908828; __c=1565572821; __g=-; __zp_stoken__=a2ealk%2F3B7QHkJiu%2B3AMZ2MYfQfdaptSXf%2FubvoWVPYRZfFxeodwtmvKrdaqby%2FFPCTj8a9qr%2BgYFIkhm7rzTDphtw%3D%3D; __l=l=%2Fwww.zhipin.com%2Fweb%2Fcommon%2Fsecurity-check.html%3Fseed%3D8GW5MJju8lLJYiy0ScbtIaCP3z1AjK4PLcoNvzorHIQ%253D%26name%3D7c0225ec%26ts%3D1565572820744%26callbackUrl%3D%252Fjob_detail%252F%253Fquery%253D%2525E5%2525B0%25258F%2525E7%2525B1%2525B3%25250A%2526industry%253D%2526position%253D&r=; __a=75198609.1565233369.1565157906.1565572821.7.2.4.7; Hm_lvt_194df3105ad7148dcf2b98a91b5e727a=1565233372,1565572823; Hm_lpvt_194df3105ad7148dcf2b98a91b5e727a=1565572825' 

# 二级域名cookie缓存
cookie_02='cookie:_uab_collina=156515790500120207873583; lastCity=101200100; _uab_collina=156523336605563703908828; __c=1565572821; __g=-; __zp_stoken__=a2ealk%2F3B7QHkJiu%2B3AMZ2MYfQfdaptSXf%2FubvoWVPYRZfFxeodwtmvKrdaqby%2FFPCTj8a9qr%2BgYFIkhm7rzTDphtw%3D%3D; __l=l=%2Fwww.zhipin.com%2Fweb%2Fcommon%2Fsecurity-check.html%3Fseed%3D8GW5MJju8lLJYiy0ScbtIaCP3z1AjK4PLcoNvzorHIQ%253D%26name%3D7c0225ec%26ts%3D1565572820744%26callbackUrl%3D%252Fjob_detail%252F%253Fquery%253D%2525E5%2525B0%25258F%2525E7%2525B1%2525B3%25250A%2526industry%253D%2526position%253D&r=; __a=75198609.1565233369.1565157906.1565572821.13.2.10.13; Hm_lvt_194df3105ad7148dcf2b98a91b5e727a=1565233372,1565572823; Hm_lpvt_194df3105ad7148dcf2b98a91b5e727a=1565573752' 

# citycode = {"北京":"101010100","上海":"101020100","天津":"101030100","重庆":"101040100",
# "哈尔滨":"101050100","长春":"101060100","沈阳":"101070100","呼和浩特":"101080100","石家庄":"101090100",
# "太原":"101100100","西安":"101110100","济南":"101120100","乌鲁木齐":"101130100","西宁":"101150100",
# "兰州":"101160100","银川":"101170100","郑州":"101180100","南京":"101190100","武汉":"101200100",
# "杭州":"101210100","合肥":"101220100","福州":"101230100","南昌":"101240100","长沙":"101250100",
# "贵阳":"101260100","成都":"101270100","广州":"101280100","昆明":"101290100","南宁":"101300100",
# "海口":"101310100","台湾":"101341100","拉萨":"101140100","香港":"101320300","澳门":"101330100"}


# 获取用户请求
function get_request() {

    read -p "请输入招聘 职位 * 公司:" info 
    # 字符串编码
    str_coding=$(echo "${info}" | xxd -plaion | sed 's/\(..\)/%\1/g')

    read -p "请输入城市:" city

    case ${city} in 
      '北京')
        city='101010100';;
      '上海')
        city='101020100';;
      '天津')
        city='101030100';;
      '重庆')
        city='101040100';;
      '哈尔滨')
        city='101050100';;
      '长春')
        city='101060100';;
      '沈阳')
        city='101070100';;
      '呼和浩特')
        city='101080100';;
      '石家庄')
        city='101090100';;
      '太原')
        city='101100100';;
      '西安')
        city='101110100';;
      '济南')
        city='101120100';;
      '乌鲁木齐')
        city='101130100';;
      '西宁')
        city='101150100';;
      '兰州')
        city='101160100';;
      '银川')
        city='101170100';;
      '郑州')
        city='101180100';;
      '南京')
        city='101190100';;
      '武汉')
        city='101200100';;
      '杭州')
        city='101210100';;
      '合肥')
        city='101220100';;
      '福州')
        city='101230100';;
      '南昌')
        city='101240100';;
      '长沙')
        city='101250100';;
      '贵阳')
        city='101260100';;
      '成都')
        city='101270100';;
      '广州')
        city='101280100';;
      '昆明')
        city='101290100';;
      '南宁')
        city='101300100';;
      '海口')
        city='101310100';;
      '台湾')
        city='101341100';;
      '拉萨')
        city='101140100';;
      '香港')
        city='101320300';;
      '澳门')
        city='101330100';;
      *) 
        echo -e "\033[31m\t未找到该城市...\033[0m"
	# 退出脚本
	sleep 1 ; exit 0;; 

    esac 
    
    # 获取URL 
    URL="https://www.zhipin.com/job_detail/?query=${str_coding}&city=${city}&industry=&position="
} 


# 默认搜索当前城市
function get_request_default() { 

    read -p "请输入招聘 职位 * 公司:" info 
    # 字符串编码
    str_coding=$(echo "${info}" | xxd -plaion | sed 's/\(..\)/%\1/g')

    # 默认当前城市
    URL="https://www.zhipin.com/job_detail/?query=${str_coding}&industry=&position="
} 


# 请求网页
function request_web() { 
    
    # 伪装浏览器类型 -A 
    WeChat='Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12A365 MicroMessenger/6.0 NetType/WIFI'
    Chrome='Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1667.0 Safari/537.36'

    # 告诉网站，我是百度蜘蛛爬取 -H 
    Baiduspider='Mozilla/5.0 (compatible; Baiduspider/2.0; +http://www.baidu.com/search/spider.html)'

    # 请求一级URL网页
    source_file=`curl --cookie "${Julian_cookie}" -A "${Chrome}" -H "${Baiduspider}" ${URL}`
    echo ${URL}

    # 过滤二级URL地址
    url=`echo "${source_file}" | grep 'data-index' | awk -F [\"] '{print $2}'`

    if [ -z "${url}" ]; then 
        echo -e "\033[31m\t搜索失败...\033[0m" 
        sleep 1; exit 0 
    fi 
    
    # 收集二级URL地址
    for i in $url 
    do 
        echo "https://www.zhipin.com${i}" >> ${Index_url}
	# 文件为空搜索失败
        [ ! -s ${Index_url} ] && echo -e "\033[31m\t没找到您想要的数据...\033[0m`exit 0`"
    done 

} 


# 循环访问二级URL;收集源网页
function get_web() {
    
    request_web 

    for i in `cat ${Index_url}` 
    do  
        # 调用终端打印结果
        # gnome-terminal -x bash -c "./cat_result.sh" 
	
        curl --cookie "${cookie_02}" -H "${Baiduspider}" "$i" > ./web_file/web.txt 
        sleep 3 

        \cp ./web_file/web.txt ./web_file/cp_web.html 
        
        # 调用过滤脚本 
        bash grep_web.sh
	cat ./web_file/result.txt >> ./info/${Result}
    done 
} 


case $1 in 

  '--city')
    get_request 
    get_web
    ;;

  '--help'|'-h')
    echo -e "\033[31m\n脚本参数:"
    echo -e "\033[32m\t./get_web\t\t搜索当前城市"
    echo -e "\033[32m\t./get_web  --city\t指定城市搜索"
    echo -e "\033[31m\n脚本描述:"
    echo -e "\033[33m\tget_web.sh\t\t请求网页获取源码"
    echo -e "\033[33m\tgrep_web.sh\t\t过滤源码获取数据"
    echo -e "\033[33m\tcat_result.sh\t\t实时查看获取结果;需和get_web.sh一起使用"
    echo -e "\033[31m\n文件描述:"
    echo -e "\033[35m\tweb_file\t\t存放网页源码"
    echo -e "\033[35m\tinfo\t\t\t存放搜索结果;按执行脚本时间创建文件" 
    echo -e "\033[0m" 
    ;;

  *) 
    get_request_default 
    get_web
    ;;  

esac 
