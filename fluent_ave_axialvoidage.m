%时均轴向空隙率分布%
clear;clc;
h=0.5:0.5:10.5;
j=1;m=0;
%读取文件%
my_dir=uigetdir('选择文件夹');  %文件夹的路径
files=dir(my_dir);
Lengthfiles=length(files);  %文件夹中文件的个数
axialvoidage=zeros(length(h),2);
prompt={'请输入首位文件名的整数位数字:','请输入步长:'};
answer=inputdlg(prompt);
number=str2double(answer(1));step=str2double(answer(2));
for i=0:Lengthfiles-3
    name=number+i*step;  %起始时间和时间步长
    openfilename=sprintf('%s%s%.2f',my_dir,'\fluent-',name);  %得到文件名
    fid=fopen(openfilename,'r');  %打开文件
    fidout=fopen('tempfile.txt','w');  %创建临时文件存储第一行数据;'w':写入（文件若不存在，自动创建）
    %读取数据%
    while ~feof(fid)                                  % 判断是否为文件末尾
        tline=fgetl(fid);                                 % 从文件读行
        if isspace(tline(1))     % 判断首字符是否是空格（此行为数据行）
            fprintf(fidout,'%s\n\n',tline);                  % 如果是数字行，把此行数据写入临时文件
            data=fscanf(fid,'%f',[4 inf]);  %读取数据，读取的顺序是按行读取，存储的时候是按列存储
            break
        end
    end
    line1=importdata('tempfile.txt');
    fclose(fidout);  %注意在删除文件前要先关闭此文件
    delete tempfile.txt;  %删除创建临时文件
    data1=[line1;data'];
    if (i==0)
        temp=zeros(size(data1,1),1);
    end
    temp=temp+data1(:,4);
end
data1(:,4)=temp/(Lengthfiles-2);
data2=sortrows(data1,3);
%截面平均+高度平均%
for i=1:size(data2,1)
    if (data2(i,3)<=h(j))
        axialvoidage(j,1)=axialvoidage(j,1)+data2(i,4);
        axialvoidage(j,2)=axialvoidage(j,2)+data2(i,3);
    else
        axialvoidage(j,:)=axialvoidage(j,:)/m;
        j=j+1;m=0;
        axialvoidage(j,1)=axialvoidage(j,1)+data2(i,4);
        axialvoidage(j,2)=axialvoidage(j,2)+data2(i,3);
    end
    m=m+1;
    if (i==size(data2,1))
        axialvoidage(j,:)=axialvoidage(j,:)/m;
    end
end
%将结果以ASCII的方式保存为txt文件%
[savefilename,pathname]=uiputfile('*.txt');
str=strcat(pathname,savefilename);  %字符串连接
save(char(str), 'axialvoidage','-ascii');  %注意save函数的格式
fclose all;