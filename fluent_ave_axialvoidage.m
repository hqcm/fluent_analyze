%ʱ�������϶�ʷֲ�%
clear;clc;
h=0.5:0.5:10.5;
j=1;m=0;
%��ȡ�ļ�%
my_dir=uigetdir('ѡ���ļ���');  %�ļ��е�·��
files=dir(my_dir);
Lengthfiles=length(files);  %�ļ������ļ��ĸ���
axialvoidage=zeros(length(h),2);
prompt={'��������λ�ļ���������λ����:','�����벽��:'};
answer=inputdlg(prompt);
number=str2double(answer(1));step=str2double(answer(2));
for i=0:Lengthfiles-3
    name=number+i*step;  %��ʼʱ���ʱ�䲽��
    openfilename=sprintf('%s%s%.2f',my_dir,'\fluent-',name);  %�õ��ļ���
    fid=fopen(openfilename,'r');  %���ļ�
    fidout=fopen('tempfile.txt','w');  %������ʱ�ļ��洢��һ������;'w':д�루�ļ��������ڣ��Զ�������
    %��ȡ����%
    while ~feof(fid)                                  % �ж��Ƿ�Ϊ�ļ�ĩβ
        tline=fgetl(fid);                                 % ���ļ�����
        if isspace(tline(1))     % �ж����ַ��Ƿ��ǿո񣨴���Ϊ�����У�
            fprintf(fidout,'%s\n\n',tline);                  % ����������У��Ѵ�������д����ʱ�ļ�
            data=fscanf(fid,'%f',[4 inf]);  %��ȡ���ݣ���ȡ��˳���ǰ��ж�ȡ���洢��ʱ���ǰ��д洢
            break
        end
    end
    line1=importdata('tempfile.txt');
    fclose(fidout);  %ע����ɾ���ļ�ǰҪ�ȹرմ��ļ�
    delete tempfile.txt;  %ɾ��������ʱ�ļ�
    data1=[line1;data'];
    if (i==0)
        temp=zeros(size(data1,1),1);
    end
    temp=temp+data1(:,4);
end
data1(:,4)=temp/(Lengthfiles-2);
data2=sortrows(data1,3);
%����ƽ��+�߶�ƽ��%
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
%�������ASCII�ķ�ʽ����Ϊtxt�ļ�%
[savefilename,pathname]=uiputfile('*.txt');
str=strcat(pathname,savefilename);  %�ַ�������
save(char(str), 'axialvoidage','-ascii');  %ע��save�����ĸ�ʽ
fclose all;