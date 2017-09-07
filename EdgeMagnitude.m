 function [TotalEdgeMag,PScore,LocalEdgeMag,EdgeMagS,NMS,maxEdgeMag]=EdgeMagnitude(pic,TH)
% pic=imread('C:\Users\Lee\Desktop\���ܼ������ҵ\����Ⱥ�Ż��㷨��ͼ���Ե����е�Ӧ��ʵ��\����\ͼƬ\lena.BMP');
[hgt,wid]=size(pic);
pics=zeros(hgt+6,wid+6);  %����ͼ�����ؾ��󣬲�0
pics(4:hgt+3,4:wid+3)=pic;  
EdgeIntensity=zeros(8,hgt*wid);
avgB=zeros(1,8);%8������light����ҶȾ�ֵ
avgD=zeros(1,8);%8������dark����ҶȾ�ֵ
% B=zeros(1,9);D=zeros(1,9); %light��dark����9������ֵ
w1=90;
w2=40;
InterDis=zeros(1,8);%����һ��1��8�е����飬װ��8����������ҶȲԽ��Խ��
IntraDis=zeros(1,8);%װ��8����������ڻҶȲԽСԽ��
EdgeMag=zeros(1,8);%װ��8������ı�Եǿ��
% neibourofp=zeros(1,7);%��������P���ڵ�7������
totalD=0;%dark�������
totalB=0;%light�������
n_mx=nchoosek(9,2);
BeforeNMS=zeros(hgt+2,wid+2,8);
NMS=zeros(hgt,wid,8);%�Ǽ���ֵ����
TotalEdgeMag=zeros(hgt,wid,8);%8�������ÿ�����ر�Եǿ��
PScore=zeros(hgt,wid,8);%8�������ÿ�����صı�Ե�����Ե÷�
LocalEdgeMag=zeros(hgt,wid);%����P��8������TotalEdgeMagֵ�е����ֵ
maxTotalEdgeMag=zeros(1,8);
EdgeMag8=zeros(1,8);
maxEdgeMag=zeros(hgt,wid);%8������EdgeMag�е����ֵ
%%
for u=4:hgt+3
    for v=4:wid+3
       
       %0����
           %Dark����
           avgD(1)=(pics(u-1,v)+pics(u-1,v+1)+pics(u-1,v+2)+pics(u,v)+pics(u,v+1)+pics(u,v+2)+pics(u+1,v)+pics(u+1,v+1)+pics(u+1,v+2))/9;                

            D=[pics(u+1,v),pics(u,v),pics(u-1,v),pics(u+1,v+1),pics(u,v+1),pics(u-1,v+1),pics(u+1,v+2),pics(u,v+2),pics(u-1,v+2)];
           %Light����
           avgB(1)=(pics(u-1,v-1)+pics(u-1,v-2)+pics(u-1,v-3)+pics(u,v-1)+pics(u,v-2)+pics(u,v-3)+pics(u+1,v-1)+pics(u+1,v-2)+pics(u+1,v-3))/9;            

            B=[pics(u+1,v-3),pics(u,v-3),pics(u-1,v-3),pics(u+1,v-2),pics(u,v-2),pics(u-1,v-2),pics(u+1,v-1),pics(u,v-1),pics(u-1,v-1)];
            InterDis(1)=min(1,abs(avgD(1)-avgB(1))/w1);
            IpD=nchoosek(D,2);subtractD=abs(IpD(:,2)-IpD(:,1))/w2;
            IpB=nchoosek(B,2);subtractB=abs(IpB(:,2)-IpB(:,1))/w2;
            
            for k=1:length(subtractD)
                totalD=totalD+min(1,subtractD(k));
            end
            for l=1:length(subtractB)
                totalB=totalB+min(1,subtractB(l));
            end
            IntraDis(1)=(totalD+totalB)/n_mx;
            EdgeMag(1)=InterDis(1)/(1+IntraDis(1));

        %4����
            EdgeMag(5)=EdgeMag(1);
            totalD=0;%dark�������
            totalB=0;
        %2����
            %dark����
            avgD(3)=(pics(u,v-1)+pics(u,v)+pics(u,v+1)+pics(u+1,v-1)+pics(u+1,v)+pics(u+1,v+1)+pics(u+2,v-1)+pics(u+2,v)+pics(u+2,v+1))/9;

            D=[pics(u,v-1),pics(u,v),pics(u,v+1),pics(u+1,v-1),pics(u+1,v),pics(u+1,v+1),pics(u+2,v-1),pics(u+2,v),pics(u+2,v+1)];
            %Light����
            avgB(3)=(pics(u-1,v-1)+pics(u-1,v)+pics(u-1,v+1)+pics(u-2,v-1)+pics(u-2,v)+pics(u-2,v+1)+pics(u-3,v-1)+pics(u-3,v)+pics(u-3,v+1))/9;           

            B=[pics(u-1,v-1),pics(u-1,v),pics(u-1,v+1),pics(u-2,v-1),pics(u-2,v),pics(u-2,v+1),pics(u-3,v-1),pics(u-3,v),pics(u-3,v+1)];
            InterDis(3)=min(1,abs(avgD(3)-avgB(3))/w1);
            IpD=nchoosek(D,2);subtractD=abs(IpD(:,2)-IpD(:,1))/w2;
            IpB=nchoosek(B,2);subtractB=abs(IpB(:,2)-IpB(:,1))/w2;
            
            for k=1:length(subtractD)
                totalD=totalD+min(1,subtractD(k));
            end
            for l=1:length(subtractB)
                totalB=totalB+min(1,subtractB(l));
            end
            IntraDis(3)=(totalD+totalB)/n_mx;
            EdgeMag(3)=InterDis(3)/(1+IntraDis(3));
            
         %6����
            EdgeMag(7)=EdgeMag(2);
            totalD=0;%dark�������
            totalB=0;
            
         %1����
            %dark����
            avgD(2)=(pics(u-1,v+1)+pics(u-1,v+2)+pics(u-1,v+3)+pics(u,v)+pics(u,v+1)+pics(u,v+2)+pics(u+1,v)+pics(u+1,v+1)+pics(u+2,v))/9;     

            D=[pics(u-1,v+1),pics(u-1,v+2),pics(u-1,v+3),pics(u,v),pics(u,v+1),pics(u,v+2),pics(u+1,v),pics(u+1,v+1),pics(u+2,v)];
            %Light����
            avgB(2)=(pics(u,v-1)+pics(u,v-2)+pics(u,v-3)+pics(u-1,v)+pics(u-1,v-1)+pics(u-1,v-2)+pics(u-2,v)+pics(u-2,v-2)+pics(u-3,v))/9;          

            B=[pics(u,v-1),pics(u,v-2),pics(u,v-3),pics(u-1,v),pics(u-1,v-1),pics(u-1,v-2),pics(u-2,v),pics(u-2,v-2),pics(u-3,v)];
            InterDis(2)=min(1,abs(avgD(2)-avgB(2))/w1);
            IpD=nchoosek(D,2);subtractD=abs(IpD(:,2)-IpD(:,1))/w2;
            IpB=nchoosek(B,2);subtractB=abs(IpB(:,2)-IpB(:,1))/w2;
            
            for k=1:length(subtractD)
                totalD=totalD+min(1,subtractD(k));
            end
            for l=1:length(subtractB)
                totalB=totalB+min(1,subtractB(l));
            end
            IntraDis(2)=(totalD+totalB)/n_mx;
            EdgeMag(2)=InterDis(2)/(1+IntraDis(2));
            totalD=0;%dark�������
            totalB=0;
            
         %5����
            %dark����
            avgD(6)=(pics(u,v)+pics(u,v+1)+pics(u,v+2)+pics(u+1,v-1)+pics(u+1,v)+pics(u+1,v+1)+pics(u+2,v-1)+pics(u+2,v)+pics(u+3,v-1))/9;           

            D=[pics(u,v),pics(u,v+1),pics(u,v+2),pics(u+1,v-1),pics(u+1,v),pics(u+1,v+1),pics(u+2,v-1),pics(u+2,v),pics(u+3,v-1)];
            %Light����
            avgB(6)=(pics(u,v-1)+pics(u,v-2)+pics(u,v-3)+pics(u-1,v)+pics(u-1,v-1)+pics(u-1,v-2)+pics(u-2,v)+pics(u-2,v-1)+pics(u-3,v))/9;            

            B=[pics(u,v-1),pics(u,v-2),pics(u,v-3),pics(u-1,v),pics(u-1,v-1),pics(u-1,v-2),pics(u-2,v),pics(u-2,v-1),pics(u-3,v)];
            InterDis(6)=min(1,abs(avgD(6)-avgB(6))/w1);
            IpD=nchoosek(D,2);subtractD=abs(IpD(:,2)-IpD(:,1))/w2;
            IpB=nchoosek(B,2);subtractB=abs(IpB(:,2)-IpB(:,1))/w2;
            
            for k=1:length(subtractD)
                totalD=totalD+min(1,subtractD(k));
            end
            for l=1:length(subtractB)
                totalB=totalB+min(1,subtractB(l));
            end
            IntraDis(6)=(totalD+totalB)/n_mx;
            EdgeMag(6)=InterDis(6)/(1+IntraDis(6));
            totalD=0;%dark�������
            totalB=0;
            
        %3����
            %dark����
            avgD(4)=(pics(u,v)+pics(u,v-1)+pics(u,v-2)+pics(u+1,v+1)+pics(u+1,v)+pics(u+1,v-1)+pics(u+2,v)+pics(u+2,v+1)+pics(u+3,v+1))/9;

            D=[pics(u,v),pics(u,v-1),pics(u,v-2),pics(u+1,v+1),pics(u+1,v),pics(u+1,v-1),pics(u+2,v),pics(u+2,v+1),pics(u+3,v+1)];
            %Light����
            avgB(4)=(pics(u,v+1)+pics(u,v+2)+pics(u,v+3)+pics(u-1,v)+pics(u-1,v+1)+pics(u-1,v+2)+pics(u-2,v)+pics(u-2,v+1)+pics(u-3,v))/9;           

            B=[pics(u,v+1),pics(u,v+2),pics(u,v+3),pics(u-1,v),pics(u-1,v+1),pics(u-1,v+2),pics(u-2,v),pics(u-2,v+1),pics(u-3,v)];
            InterDis(4)=min(1,abs(avgD(4)-avgB(4))/w1);
            IpD=nchoosek(D,2);subtractD=abs(IpD(:,2)-IpD(:,1))/w2;
            IpB=nchoosek(B,2);subtractB=abs(IpB(:,2)-IpB(:,1))/w2;
            
            for k=1:length(subtractD)
                totalD=totalD+min(1,subtractD(k));
            end
            for l=1:length(subtractB)
                totalB=totalB+min(1,subtractB(l));
            end
            IntraDis(4)=(totalD+totalB)/n_mx;
            EdgeMag(4)=InterDis(4)/(1+IntraDis(4));
            totalD=0;%dark�������
            totalB=0;
        %7����
            %dark����
            avgD(8)=(pics(u-1,v-1)+pics(u-1,v-2)+pics(u-1,v-3)+pics(u,v)+pics(u,v-1)+pics(u,v-2)+pics(u+1,v)+pics(u+1,v-1)+pics(u+2,v))/9;            

            D=[pics(u-1,v-1),pics(u-1,v-2),pics(u-1,v-3),pics(u,v),pics(u,v-1),pics(u,v-2),pics(u+1,v),pics(u+1,v-1),pics(u+2,v)];
            %Light����
            avgB(8)=(pics(u,v+1)+pics(u,v+2)+pics(u,v+3)+pics(u-1,v)+pics(u-1,v+1)+pics(u-1,v+2)+pics(u-2,v)+pics(u-2,v+1)+pics(u-3,v))/9;            

            B=[pics(u,v+1),pics(u,v+2),pics(u,v+3),pics(u-1,v),pics(u-1,v+1),pics(u-1,v+2),pics(u-2,v),pics(u-2,v+1),pics(u-3,v)];
            InterDis(8)=min(1,abs(avgD(8)-avgB(8))/w1);
            IpD=nchoosek(D,2);subtractD=abs(IpD(:,2)-IpD(:,1))/w2;
            IpB=nchoosek(B,2);subtractB=abs(IpB(:,2)-IpB(:,1))/w2;
            
            for k=1:length(subtractD)
                totalD=totalD+min(1,subtractD(k));
            end
            for l=1:length(subtractB)
                totalB=totalB+min(1,subtractB(l));
            end
            IntraDis(8)=(totalD+totalB)/n_mx;
            EdgeMag(8)=InterDis(8)/(1+IntraDis(8)); 
            EdgeIntensity(:,(u-3)*(v-3)+(wid-v+3)*(u-4))=EdgeMag';
    end
end

% EdgeMagS(:,:,1)=reshape(EdgeIntensity(1,:),hgt,wid);
%8������ı�Ե�ݶ�ֵ��ÿ������hgt*wid
%cat:�������飬��C = cat(dim,A1,A2,A3,A4,...)
EdgeMagS=cat(3,(reshape(EdgeIntensity(1,:),wid,hgt))',(reshape(EdgeIntensity(2,:),wid,hgt))',(reshape(EdgeIntensity(3,:),wid,hgt))',(reshape(EdgeIntensity(4,:),wid,hgt))',(reshape(EdgeIntensity(5,:),wid,hgt))',(reshape(EdgeIntensity(6,:),wid,hgt))',(reshape(EdgeIntensity(7,:),wid,hgt))',(reshape(EdgeIntensity(8,:),wid,hgt))');
for n=1:8
    BeforeNMS(2:hgt+1,2:wid+1,n)=EdgeMagS(:,:,n);
end
%%
%����LocalEdgeMag��TotalEdgeMag
for i=2:hgt+1
    for j=2:wid+1
        %0����
        neibourofp=[BeforeNMS(i-1,j-1,1),BeforeNMS(i,j-1,1),BeforeNMS(i+1,j-1,1),BeforeNMS(i-1,j+1,1),BeforeNMS(i,j+1,1),BeforeNMS(i+1,j+1,1),BeforeNMS(i,j,1)];
        NMS(i-1,j-1,1)=sum(neibourofp<BeforeNMS(i,j,1));
        %4����
        NMS(i-1,j-1,5)= NMS(i-1,j-1,1);
        %2����
        neibourofp=[BeforeNMS(i-1,j-1,3),BeforeNMS(i-1,j,3),BeforeNMS(i-1,j+1,3),BeforeNMS(i+1,j+1,3),BeforeNMS(i+1,j,3),BeforeNMS(i+1,j-1,3),BeforeNMS(i,j,3)];
        NMS(i-1,j-1,3)=sum(neibourofp<BeforeNMS(i,j,3));
        %6����
        NMS(i-1,j-1,7)=NMS(i-1,j-1,3);
        %1����
        neibourofp=[BeforeNMS(i,j-1,2),BeforeNMS(i-1,j-1,2),BeforeNMS(i-1,j,2),BeforeNMS(i,j+1,2),BeforeNMS(i+1,j+1,2),BeforeNMS(i+1,j,2),BeforeNMS(i,j,2)];
        NMS(i-1,j-1,2)=sum(neibourofp<BeforeNMS(i,j,2));
        %5����
        neibourofp=[BeforeNMS(i-1,j,6),BeforeNMS(i-1,j-1,6),BeforeNMS(i,j-1,6),BeforeNMS(i+1,j,6),BeforeNMS(i+1,j+1,6),BeforeNMS(i,j+1,6),BeforeNMS(i,j,6)];
        NMS(i-1,j-1,6)=sum(neibourofp<BeforeNMS(i,j,6));
        %3����
        neibourofp=[BeforeNMS(i-1,j,4),BeforeNMS(i-1,j+1,4),BeforeNMS(i,j+1,4),BeforeNMS(i+1,j,4),BeforeNMS(i+1,j-1,4),BeforeNMS(i,j-1,4),BeforeNMS(i,j,4)];
        NMS(i-1,j-1,4)=sum(neibourofp<BeforeNMS(i,j,4));
        %7����
        neibourofp=[BeforeNMS(i-1,j,8),BeforeNMS(i-1,j+1,8),BeforeNMS(i,j+1,8),BeforeNMS(i+1,j,8),BeforeNMS(i+1,j-1,8),BeforeNMS(i,j-1,8),BeforeNMS(i,j,8)];
        NMS(i-1,j-1,8)=sum(neibourofp<BeforeNMS(i,j,8));
        
        for k=1:8
            TotalEdgeMag(i-1,j-1,k)=EdgeMagS(i-1,j-1,k)/(1+exp(-2*(NMS(i-1,j-1,k)-4)));
            PScore(i-1,j-1,k)=1/(1+exp((-3.317/TH)*(TotalEdgeMag(i-1,j-1,k)-0.6229*TH)));
%             PScore(i-1,j-1,k)=1/((1+exp(-10*(EdgeMagS(i-1,j-1,k)-TH)))*(1+exp(-2*(NMS(i-1,j-1,k)-4))));
            maxTotalEdgeMag(k)=TotalEdgeMag(i-1,j-1,k);
            EdgeMag8(k)=EdgeMagS(i-1,j-1,k);
        end
            LocalEdgeMag(i-1,j-1)=max(maxTotalEdgeMag);
            maxEdgeMag(i-1,j-1)=max(EdgeMag8);
    end
end

































