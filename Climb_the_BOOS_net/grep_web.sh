#! /bin/bash 

touch result.txt 


################
# 基本信息     #  
################
function Basic_Info() { 
    
    # 招聘信息URL
    URL=$(cat cp_web.html | grep '<link rel="canonical" href=' | gawk -F [\"\"] '{print $4}')

    # 删除匹配到关键字一下所有行
    sed -i '/<p>点击查看地图<\/p>/,$d' cp_web.html  
    
    # 更新时间
    up_time=$(cat cp_web.html | grep -E '<p class="gray".*[0-9]</p>' | gawk -F [\>\<] '{print $3}')  

    # 招聘标题
    title=$(cat cp_web.html | grep '<title>【' | grep '<title>【' | gawk -F [\>\<] '{print "\t"$3"\n"}')
    
    # 招聘状态
    job_status=$(cat cp_web.html | grep '<div class="job-status"' | gawk -F [\>\<] '{print "招聘状态:\t"$3"\n"}')
    
    # 招聘基本要求
    basic_requirements=$(cat cp_web.html | grep '<p>.*<em class=' | gawk -F [\>\<] '{print "基本要求:\t"$3,$7,$11,$15}')
    
    # 招聘岗位
    row_num=$(cat cp_web.html | grep -n '<h1>' | gawk -F : 'END{print $1}')
    next_row_num=$[ $row_num + 1 ] 
    job_name=$(sed -n ''$row_num'p' cp_web.html | gawk -F [\>\<] '{print "招聘岗位:\t"$3}')  

    # 参考薪资
    job_money=$(sed -n ''$next_row_num'p' cp_web.html | gawk -F [\>\<] '{print "参考薪资:\t"$3}')  
    
    # 工作福利
    job_welfare=$(cat cp_web.html | grep '</span><span>'| gawk -F [\>\<] 'END{print "工作福利:\n","\t"$3,$7,$11,$15,$19,$23,$27,$31,$35,$39}')
    
    # 招聘人
    HR=$(cat cp_web.html | grep '<h2 class="name">' | gawk -F [\>\<] '{print "信息发起:\t"$3"\n"}') 
    
    # 招聘人信息
    HR_info=$(cat cp_web.html | grep -E '<p class="gray">.*<em' | gawk -F [\>\<] 'END{print $3,$5,$7}')
 
    # 删除匹配到关键字以上所有行
    row_num=$(cat cp_web.html | gawk '/<h3>职位描述<\/h3>/{print NR}') 
    #let $row_num-- 
    sed -i '1,'$row_num'd' cp_web.html     
} 


###############################
# 工商信息;公司介绍;工作地址  #
###############################
function Business_Information_and_Address() { 

    # 获取公司工商信息和工作地址
    information=$(cat cp_web.html | sed -n '/<h3>工商信息<\/h3>/,$p')
    job_address_row=$(echo "$information" | gawk  '/<h3>工作地址<\/h3>/{print NR}')
    new_row=$[ $job_address_row - 1 ]

    
    # 去除标签;筛选工商信息
    string_01=$(echo "$information" | sed -n '1,'$new_row'p'| gawk -F [\>\<] '{print $3,$5,$7,$9,$11}')
    # 删除web网页中换行符/缩进 
    string_02=$(echo "${string_01}" | sed 's/\r//g;/工商信息/d')
    info_row=$(echo "${string_02}" | gawk '/查看全部/{print NR}')
    job_information=$(echo "${string_02}" | sed  ''$info_row',$d' | gawk 'BEGIN{print "工商信息:"}{print "\t"$0}')  


    # 查看公司全部信息url
    information_url=$(echo "$information" | sed -n '1,'$new_row'p' | grep "查看全部" | gawk -F [\"\"] '{print "查看全部:\n\t""https://www.zhipin.com"$4}')
    # information=$(echo "${string_02}" | sed 's/工商.*/工商信息:/;s/查看.*/查看全部:/;s/工作.*/工作地点:/')
    # echo "${job_information}" > result.txt
    # echo "${information_url}" >> result.txt 


    # 筛选工作地址
    string_03=$(echo "$information" | sed -n ''$job_address_row',$p')
    string_04=$(echo "${string_03}" | gawk -F [\>\<] '{print $3}')
    job_address=$(echo "${string_03}" | grep 'address' | gawk -F [\>\<] '{print "工作地址:\n\t"$3}')
    # echo "${job_address}" >> result.txt 


    # 删除工商信息标签文件 
    row_num=$(cat cp_web.html | gawk '/<h3>竞争力分析<\/h3>/{print NR}')
    sed -i ''$row_num',$d' cp_web.html 
} 



#######################
# 招聘要求            # 
#######################
function Position_and_Requirements() { 

    # 筛选公司简介
    row_num=$(cat cp_web.html |  grep -n '<div class="text">' | gawk -F : 'END{print $1}')
    new_row_num=$[ $row_num - 3 ] 
    sed -i ''$new_row_num',$d' cp_web.html 
    

    # 筛选招聘要求
    str_01=$(cat cp_web.html  | sed  's/<\/*[a-z]*>//g') 
    str_02=$(echo "${str_01}" | gawk -F [\>\<] '{print $1"\n",$3"\n",$5"\n",$7"\n",$9"\n",$11"\n",$13"\n",$15"\n",$17"\n",$19"\n",$21"\n",$23"\n",$25"\n",$27"\n",$29"\n",$31"\n"}') 
    str_03=$(echo "${str_02}" | sed -n '/ ./p' | sed 's/\ //g;s/\r//g' | grep -v '^$' | sed -n 's/^/\t/p')
    str_04=$(echo "${str_03}" | sed  '/公司介绍/,$d;/团队介绍/,$d')
    # str_05=$(echo "${str_04}" | )
    recruitment_info=$(echo "$str_04") 
    
    
    # echo "${recruitment_info}" > result.txt 
    # work_info=$(cat cp_web.html | sed  '/<.*>/d')
    # echo "${work_info}" >> result.txt 
    # echo "${information}" >> result.txt 
} 


# 编排文本
function Extended_Text_Compositor() {  
    Basic_Info 
    Business_Information_and_Address 
    Position_and_Requirements 

    # 更新时间
    echo "${up_time}" > result.txt    

    # 招聘标题
    echo -e "${title}\n" >> result.txt 
    
    # 招聘岗位
    echo "${job_name}" >> result.txt 

    # 招聘发起人;招聘人信息
    echo "${HR}    ${HR_info}" >> result.txt 
    
    # 招聘状态
    echo "${job_status}" >> result.txt 
    
    # 招聘基本要求
    echo "${basic_requirements}" >> result.txt 
    
    # 参考薪资
    echo "${job_money}" >> result.txt 

    # 招聘网页
    echo -e "招聘网页:\t${URL}\n" >> result.txt 

    # 工作福利
    echo -e  "${job_welfare}\n" >> result.txt 

    # 工作职责;招聘要求
    echo -e "${recruitment_info}\n" >> result.txt 

    # 工商信息
    echo "${job_information}" >> result.txt
    echo "${information_url}" >> result.txt 

    # 工作地址
    echo "${job_address}" >> result.txt 
}

Extended_Text_Compositor 


