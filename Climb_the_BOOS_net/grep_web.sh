#! /bin/bash 


# 网页源码
source_file='./web_file/cp_web.html'

# 临时存储结果文件
result_file='./web_file/result.txt'
rm -rf ${result_file}


################
# 基本信息     #  
################
function Basic_Info() { 
    
    # 招聘信息URL
    URL=$(cat ${source_file} | grep '<link rel="canonical" href=' | gawk -F [\"\"] '{print "招聘网页:\t"$4}')

    # 删除匹配到关键字一下所有行
    sed -i '/<p>点击查看地图<\/p>/,$d' ${source_file}  
    
    # 更新时间
    up_time=$(cat ${source_file} | grep -E '<p class="gray".*[0-9]</p>' | gawk -F [\>\<] '{print $3}')  

    # 招聘标题
    title=$(cat ${source_file} | grep '<title>【' | grep '<title>【' | gawk -F [\>\<] '{print "\t"$3"\n"}')
    
    # 招聘状态
    job_status=$(cat ${source_file} | grep '<div class="job-status"' | gawk -F [\>\<] '{print "招聘状态:\t"$3"\n"}')
    
    # 招聘基本要求
    basic_requirements=$(cat ${source_file} | grep '<p>.*<em class=' | gawk -F [\>\<] '{print "基本要求:\t"$3,$7,$11,$15}')
    
    # 招聘岗位
    row_num=$(cat ${source_file} | grep -n '<h1>' | gawk -F : 'END{print $1}')
    next_row_num=$[ $row_num + 1 ] 
    job_name=$(sed -n ''$row_num'p' ${source_file} | gawk -F [\>\<] '{print "招聘岗位:\t"$3}')  

    # 参考薪资
    job_money=$(sed -n ''$next_row_num'p' ${source_file} | gawk -F [\>\<] '{print "参考薪资:\t"$3}')  
    
    # 工作福利
    job_welfare=$(cat ${source_file} | grep '</span><span>'| gawk -F [\>\<] 'END{print "工作福利:\n","\t"$3,$7,$11,$15,$19,$23,$27,$31,$35,$39}')
    
    # 招聘人
    HR=$(cat ${source_file} | grep '<h2 class="name">' | gawk -F [\>\<] '{print "信息发起:\t"$3"\n"}') 
    
    # 招聘人信息
    HR_info=$(cat ${source_file} | grep -E '<p class="gray">.*<em' | gawk -F [\>\<] 'END{print $3,$5,$7}')
 
    # 删除匹配到关键字以上所有行
    row_num=$(cat ${source_file} | gawk '/<h3>职位描述<\/h3>/{print NR}') 
    #let $row_num-- 
    sed -i '1,'$row_num'd' ${source_file}     
} 


###############################
# 工商信息;公司介绍;工作地址  #
###############################
function Business_Information_and_Address() { 

    # 获取公司工商信息和工作地址
    information=$(cat ${source_file} | sed -n '/<h3>工商信息<\/h3>/,$p')
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
    # echo "${job_information}" > ${result_file}
    # echo "${information_url}" >> ${result_file} 


    # 筛选工作地址
    string_03=$(echo "$information" | sed -n ''$job_address_row',$p')
    string_04=$(echo "${string_03}" | gawk -F [\>\<] '{print $3}')
    job_address=$(echo "${string_03}" | grep 'address' | gawk -F [\>\<] '{print "工作地址:\n\t"$3}')
    # echo "${job_address}" >> ${result_file} 


    # 删除工商信息标签文件 
    row_num=$(cat ${source_file} | gawk '/<h3>竞争力分析<\/h3>/{print NR}')
    sed -i ''$row_num',$d' ${source_file} 
} 



#######################
# 招聘要求            # 
#######################
function Position_and_Requirements() { 

    # 筛选公司简介
    row_num=$(cat ${source_file} |  grep -n '<div class="text">' | gawk -F : 'END{print $1}')
    new_row_num=$[ $row_num - 3 ] 
    sed -i ''$new_row_num',$d' ${source_file} 
    

    # 筛选招聘要求
    str_01=$(cat ${source_file}  | sed  's/<\/*[a-z]*>//g') 
    str_02=$(echo "${str_01}" | gawk -F [\>\<] '{print $1"\n",$3"\n",$5"\n",$7"\n",$9"\n",$11"\n",$13"\n",$15"\n",$17"\n",$19"\n",$21"\n",$23"\n",$25"\n",$27"\n",$29"\n",$31"\n"}') 
    str_03=$(echo "${str_02}" | sed -n '/ ./p' | sed 's/\ //g;s/\r//g' | grep -v '^$' | sed -n 's/^/\t/p')
    str_04=$(echo "${str_03}" | sed  '/公司介绍/,$d;/团队介绍/,$d')
    # str_05=$(echo "${str_04}" | )
    recruitment_info=$(echo "$str_04") 
    
    
    # echo "${recruitment_info}" > ${result_file} 
    # work_info=$(cat ${source_file} | sed  '/<.*>/d')
    # echo "${work_info}" >> ${result_file} 
    # echo "${information}" >> ${result_file} 
} 


# 编排文本
function Extended_Text_Compositor() {  

    Basic_Info 
    Business_Information_and_Address 
    Position_and_Requirements 

    # 更新时间
    echo "${up_time}" > ${result_file}    

    # 招聘标题
    echo -e "${title}\n" >> ${result_file} 
    
    # 招聘岗位
    echo "${job_name}" >> ${result_file} 

    # 招聘发起人;招聘人信息
    echo "${HR}    ${HR_info}" >> ${result_file} 
    
    # 招聘状态
    echo "${job_status}" >> ${result_file} 
    
    # 招聘基本要求
    echo "${basic_requirements}" >> ${result_file} 
    
    # 参考薪资
    echo "${job_money}" >> ${result_file} 

    # 招聘网页
    echo -e "${URL}\n" >> ${result_file} 

    # 工作福利
    echo -e  "${job_welfare}\n" >> ${result_file} 

    # 工作职责;招聘要求
    echo -e "${recruitment_info}\n" >> ${result_file} 

    # 工商信息
    echo "${job_information}" >> ${result_file}
    echo "${information_url}" >> ${result_file} 

    # 工作地址
    echo "${job_address}" >> ${result_file} 
    
    echo -e "\n\n\n############################################################################" >> ${result_file}
}

Extended_Text_Compositor 


