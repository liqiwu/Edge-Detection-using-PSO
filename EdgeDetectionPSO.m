clc;clear;close all;
pic=imread('C:\Users\Lee\Desktop\���ܼ�������\����Ⱥ�Ż��㷨��ͼ���Ե����е�Ӧ��ʵ��\����\ͼƬ\lena.bmp');
% pic=imnoise(pic, 'gaussian', 0, 0.9);
TH=graythresh(pic);%ȡͼ�������䷽����ֵ
% TH=0.4378;
[TotalEdgeMag,PScore,LocalEdgeMag,EdgeMagS,NMS,maxEdgeMag]=EdgeMagnitude(pic,TH);%����ͼ����ÿ������8������ı�Եǿ��(hgt*wid*8)��ͬһ���������ı�Եǿ��(hgt*wid)
[height,width]=size(pic);
% n=1;
% SquaresCoor=zeros(SqrSize,2*SqrSize,n);
% Check=zeros(height,width); 
SqrSize=4;
L=10;%curve�ĳ���Ϊ2L+1
LocalEdgeMagS=zeros(height+2*L-2,width+2*L-2);
maxEdgeMagS=zeros(height+2*L-2,width+2*L-2);
picS=zeros(height+2*L-2,width+2*L-2);
PScoreS=zeros(height+2*L-2,width+2*L-2,8);
maxEdgeMagS(L+1:height+L-2,L+1:width+L-2)=maxEdgeMag(2:height-1,2:width-1);
LocalEdgeMagS(L+1:height+L-2,L+1:width+L-2)=LocalEdgeMag(2:height-1,2:width-1);%������չ�ɣ�height+2*L-2��*��width+2*L-2��
picS(L+1:height+L-2,L+1:width+L-2)=pic(2:height-1,2:width-1);%ȥ��ͼ��������Ե��������չ�ɣ�height+2*L-2��*��width+2*L-2��
PScoreS(L+1:height+L-2,L+1:width+L-2,:)=PScore(2:height-1,2:width-1,:);%ȥ������㲹����չ�ɣ�height+2*L-2��*��width+2*L-2��
Square=zeros(SqrSize,SqrSize);%��ɫ�����С


%-------������ʼ������--------
w=0.7298;%����Ȩ��
c1=1.4962;%ѧϰ����1
c2=1.4962;%ѧϰ����2
MaxIter=200;%����������
it=1;
nPop=50;%��ʼ��Ⱥ�������Ŀ
HP=0.1119;%PScoreC�ж���ֵ

particle_position=zeros(nPop,2*L+2);%[o1,o2,d1,d2,...,dL,dL+1,...,d2L]
particle_velocity=zeros(nPop,2*L+2);
particle_fitness=zeros(1,nPop);%������Ӧ��
particle_best_fitness=zeros(1,nPop);%���������Ӧ��
particle_pbest_position=zeros(nPop,2*L+2);%�����������λ��
particle_gbest_position=zeros(1,2*L+2);%���������е����λ��
particle_decoded=zeros(nPop,2*L+1,2);%���������꣬���㣬1����i��2����j,[o,d1,d2,...,dL,...,d2L]
particle_best_decoded=zeros(1,2*L+1,2);%Ѱ�ҵ�������λ�ý�����

particle_min_velocity=-0.2*SqrSize;%������С�ٶ�
particle_max_velocity=0.2*SqrSize;%��������ٶ�

particle_memory=zeros(MaxIter,2*L+2,nPop);%����CrossC

center_particle_min_position=0;
center_particle_max_position=SqrSize-1;

particle_min_position=0;%������Сλ��
particle_max_position=7;%�������λ��

pixel_unprocessed=unprocessed(L,height,width,LocalEdgeMagS,TH);%1 δ����  height+2*L-2,width+2*L-2
pixel_unmarkedge=unmarkedge(L,height,width,LocalEdgeMagS,TH);%1 δ���Ϊ��Ե    height+2*L-2,width+2*L-2
% pixel_processed=zeros(height+2*L-2,width+2*L-2);%1 �Ѵ��� 
% pixel_markedge=zeros(height+2*L-2,width+2*L-2);%1 �ѱ��
pixel_finalmark_edge=zeros(height+2*L-2,width+2*L-2);%1 �ѱ�� 


for i=L+1:height+L-2-SqrSize
    for j=L+1:width+L-2-SqrSize
        Square=LocalEdgeMagS(i:i+SqrSize-1,j:j+SqrSize-1);
        if find(Square>TH)
%             [aa,bb]=find(Square>TH);
%             cc=[aa,bb]';
%             for cci=1:size(cc,2)
%                 pixel_unprocessed(cc(1,cci)-1+i,cc(2,cci)-1+j)=1;
%                 pixel_unmarkedge(cc(1,cci)-1+i,cc(2,cci)-1+j)=1;
%             end
            [u1,v1,w1]=find(pixel_unprocessed(i:i+SqrSize-1,j:j+SqrSize-1));%���ַ���Ԫ�ص��С��С�ֵ����Ϊ��
            [u2,v2,w2]=find(pixel_unmarkedge(i:i+SqrSize-1,j:j+SqrSize-1));
            process= [u1,v1,w1];mark=[u2,v2,w2];%�ֱ𸳸�process��mark
            if ~isempty(process)&&~isempty(mark) %�������Pδ��������δ�����     %find(pixel_unprocessed(i:i+SqrSize-1,j:j+SqrSize-1)) %if P is unprocessed and not marked as an edge 
                  for k=1:nPop
                    [particle_position_function,particle_decoded_function]=Initialization(i,j,u1,v1,L);%����Ⱥ��ʼ�����뼰����
                    particle_position(k,:)=particle_position_function(1,:); %��ʼ����50�����ӣ�
                    particle_decoded(k,:,:)=particle_decoded_function(1,:,:);%���������꣬���㣬1����i��2����j,[o,d1,d2,...,dL,...,d2L]
                  end
               while it<=MaxIter
%                   for k=1:nPop
%                     [particle_position_function,particle_decoded_function]=Initialization(i,j,aa,bb,L);%����Ⱥ��ʼ������
%                     particle_position(k,:)=particle_position_function(1,:); %��ʼ����50�����ӣ�
%                     particle_decoded(k,:,:)=particle_decoded_function(1,:,:);%���������꣬���㣬1����i��2����j,[o,d1,d2,...,dL,...,d2L]
%                   end
                  for m=1:nPop
                      [Fitness_function,~]=Fitness(particle_position(m,:),particle_decoded(m,:,:),picS,L,PScoreS);%����U(C),PScore(C),CCost(C),Fitness(C)
                      particle_fitness(m)=Fitness_function;
                      if particle_fitness(m)>particle_best_fitness(m);
                         particle_pbest_position(m,:)=particle_position(m,:);
                         particle_best_fitness(m)=particle_fitness(m);
                      end
                      particle_memory(it,:,m)=particle_position(m,:);%����ÿ�����ӵ�λ��
                  end
                  [~,I]=max(particle_best_fitness);%�������ֵ��Ӧ���кš�[C,I]=max(a);->C��ʾ���Ǿ���aÿ�е����ֵ��I��ʾ����ÿ�����ֵ��Ӧ���±�
                  particle_gbest_position=particle_pbest_position(I,:);%��ʼ��ʱ������õ�����λ�ø���particle_gbest_position
                  
                  for n=1:nPop
                      particle_velocity(n,:)=w.*particle_velocity(n,:)+c1.*rand([1,2*L+2]).*(particle_pbest_position(n,:)-particle_position(n,:))...
                          +c2.*rand([1,2*L+2]).*(particle_gbest_position(1,:)-particle_position(n,:));%�����ٶȸ���
                      for n1=1:2*L+2
                          particle_velocity(n,n1)=max(particle_velocity(n,n1),particle_min_velocity);
                          particle_velocity(n,n1)=min(particle_velocity(n,n1),particle_max_velocity);
                      end
                      particle_position(n,:)=particle_position(n,:)+particle_velocity(n,:);%[o1,o2,d1,d2,...,dL,dL+1,...,d2L],����λ�ø���
                      for r=1:2
                          if particle_position(n,r)-floor(particle_position(n,r))>rand(1)
                              particle_position(n,r)=floor(particle_position(n,r))+1;
                              particle_position(n,r)=max(particle_position(n,r),center_particle_min_position);
                              particle_position(n,r)=min(particle_position(n,r),center_particle_max_position);
                          else
                              particle_position(n,r)=floor(particle_position(n,r));
                              particle_position(n,r)=max(particle_position(n,r),center_particle_min_position);
                              particle_position(n,r)=min(particle_position(n,r),center_particle_max_position);
                          end
                      end
                      for s=3:2*L+2
                          if particle_position(n,s)-floor(particle_position(n,s))>rand(1)
                              particle_position(n,s)=mod(floor(particle_position(n,r))+1,8);
                              particle_position(n,r)=max(particle_position(n,r),particle_min_position);
                              particle_position(n,r)=min(particle_position(n,r),particle_max_position);
                          else
                              particle_position(n,s)=mod(floor(particle_position(n,r)),8);
                              particle_position(n,r)=max(particle_position(n,r),particle_min_position);
                              particle_position(n,r)=min(particle_position(n,r),particle_max_position);
                          end
                      end
                      particle_position(n,:)=checkposition(particle_position(n,:),L);
                      particle_decoded(n,:,:)=Decoded(particle_position(n,:),i,j,L);
                      [~,PScoreC]=Fitness(particle_position(n,:),particle_decoded(n,:,:),picS,L,PScoreS);%Evaluate U(C), PScore(C) and CCost(C) Evaluate Fitness(C)
%                       particle_fitness(n)=Fitness_function;%����������Ӧ�ȡ��ֲ���ȫ������ֵ
%                       if particle_fitness(n)>particle_best_fitness(n);
%                          particle_pbest_position(n,:)=particle_position(n,:);
%                          particle_best_fitness(n)=particle_fitness(n);
%                       end

%                       particle_memory(it,:,n)=particle_position(n,:);
                      CrossC=ismember(particle_position(n,:),particle_memory(:,:,n),'rows'); %����Ƿ�����ʷ�������ص� 
                      if CrossC~=0||PScoreC<=HP
                          [particle_position_function,particle_decoded_function]=Initialization(i,j,u1,v1,L);%����Ⱥ��ʼ������
                          particle_position(n,:)=particle_position_function(1,:); %nPop������
                          particle_decoded(n,:,:)=particle_decoded_function(1,:,:);%���������꣬���㣬1����i��2����j,[o,d1,d2,...,dL,...,d2L]
                      end
                  end
%                   [~,P]=max(particle_best_fitness);
%                   particle_gbest_position=particle_pbest_position(P,:);%λ�ú��ٶȸ���ʱ������õ�����λ�ø���particle_gbest_position
                  
                  it=it+1;
               end
%                 particle_memory=zeros(MaxIter,2*L+2,nPop);
                particle_best_decoded=Decoded(particle_gbest_position,i,j,L);%zeros(1,2*L+1,2)��õ����ӽ���õ�������
                [~,PScoreC]=Fitness(particle_gbest_position(1,:),particle_best_decoded(1,:,:),picS,L, PScoreS);
                if PScoreC>HP
                    %mark all pixels on the curve C as edges and the pixels
                    %within the rectangle are not marked as processed
                    %pixels�������������ر��Ϊ��Ե,�������ڵ����ر��δ����
                    for t=1:2*L+1
                        pixel_finalmark_edge(particle_best_decoded(1,t,1),particle_best_decoded(1,t,2))=1;%���Ϊ��Ե
                        pixel_unmarkedge(particle_best_decoded(1,t,1),particle_best_decoded(1,t,2))=0;%�ѱ��Ϊ��Ե
                        if particle_best_decoded(1,t,1)>=i && particle_best_decoded(1,t,1)<=i+SqrSize-1 && particle_best_decoded(1,t,2)>=j && particle_best_decoded(1,t,2)<=j+SqrSize-1
                            pixel_unprocessed(particle_best_decoded(1,t,1),particle_best_decoded(1,t,2))=1;%���������ر��Ϊδ����
                        else
                            pixel_unprocessed(particle_best_decoded(1,t,1),particle_best_decoded(1,t,2))=0;%���Ϊ�Ѵ���
                        end
                    end
                else            
                    %if no feasible particle found 
                    %mark all pixels within the red rectangle as processed
                    %end
                    pixel_unprocessed(i:i+SqrSize-1,j:j+SqrSize-1)=0;  %�������������ر��Ϊ�Ѵ���
                end
            end
        end 
    end
end

finalpic=pixel_finalmark_edge(L:height+L-1,L:width+L-1);
finalpic=mat2gray(finalpic);
figure;
imshow(finalpic);























