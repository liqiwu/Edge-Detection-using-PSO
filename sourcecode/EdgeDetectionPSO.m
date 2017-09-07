clc;clear;close all;
pic=imread('C:\Users\Lee\Desktop\智能计算论文\粒子群优化算法在图像边缘检测中的应用实现\程序\图片\lena.bmp');
% pic=imnoise(pic, 'gaussian', 0, 0.9);
TH=graythresh(pic);%取图像最大类间方差阈值
% TH=0.4378;
[TotalEdgeMag,PScore,LocalEdgeMag,EdgeMagS,NMS,maxEdgeMag]=EdgeMagnitude(pic,TH);%返回图像中每个像素8个方向的边缘强度(hgt*wid*8)和同一个方向最大的边缘强度(hgt*wid)
[height,width]=size(pic);
% n=1;
% SquaresCoor=zeros(SqrSize,2*SqrSize,n);
% Check=zeros(height,width); 
SqrSize=4;
L=10;%curve的长度为2L+1
LocalEdgeMagS=zeros(height+2*L-2,width+2*L-2);
maxEdgeMagS=zeros(height+2*L-2,width+2*L-2);
picS=zeros(height+2*L-2,width+2*L-2);
PScoreS=zeros(height+2*L-2,width+2*L-2,8);
maxEdgeMagS(L+1:height+L-2,L+1:width+L-2)=maxEdgeMag(2:height-1,2:width-1);
LocalEdgeMagS(L+1:height+L-2,L+1:width+L-2)=LocalEdgeMag(2:height-1,2:width-1);%补零扩展成（height+2*L-2）*（width+2*L-2）
picS(L+1:height+L-2,L+1:width+L-2)=pic(2:height-1,2:width-1);%去除图像最外层边缘，补零扩展成（height+2*L-2）*（width+2*L-2）
PScoreS(L+1:height+L-2,L+1:width+L-2,:)=PScore(2:height-1,2:width-1,:);%去除最外层补零扩展成（height+2*L-2）*（width+2*L-2）
Square=zeros(SqrSize,SqrSize);%红色方框大小


%-------给定初始化条件--------
w=0.7298;%惯性权重
c1=1.4962;%学习因子1
c2=1.4962;%学习因子2
MaxIter=200;%最大迭代次数
it=1;
nPop=50;%初始化群体个体数目
HP=0.1119;%PScoreC判断阈值

particle_position=zeros(nPop,2*L+2);%[o1,o2,d1,d2,...,dL,dL+1,...,d2L]
particle_velocity=zeros(nPop,2*L+2);
particle_fitness=zeros(1,nPop);%粒子适应度
particle_best_fitness=zeros(1,nPop);%粒子最佳适应度
particle_pbest_position=zeros(nPop,2*L+2);%单个粒子最好位置
particle_gbest_position=zeros(1,2*L+2);%所有粒子中的最好位置
particle_decoded=zeros(nPop,2*L+1,2);%解码存放坐标，两层，1层存放i，2层存放j,[o,d1,d2,...,dL,...,d2L]
particle_best_decoded=zeros(1,2*L+1,2);%寻找到的最优位置解码结果

particle_min_velocity=-0.2*SqrSize;%粒子最小速度
particle_max_velocity=0.2*SqrSize;%粒子最大速度

particle_memory=zeros(MaxIter,2*L+2,nPop);%用于CrossC

center_particle_min_position=0;
center_particle_max_position=SqrSize-1;

particle_min_position=0;%粒子最小位置
particle_max_position=7;%粒子最大位置

pixel_unprocessed=unprocessed(L,height,width,LocalEdgeMagS,TH);%1 未处理  height+2*L-2,width+2*L-2
pixel_unmarkedge=unmarkedge(L,height,width,LocalEdgeMagS,TH);%1 未标记为边缘    height+2*L-2,width+2*L-2
% pixel_processed=zeros(height+2*L-2,width+2*L-2);%1 已处理 
% pixel_markedge=zeros(height+2*L-2,width+2*L-2);%1 已标记
pixel_finalmark_edge=zeros(height+2*L-2,width+2*L-2);%1 已标记 


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
            [u1,v1,w1]=find(pixel_unprocessed(i:i+SqrSize-1,j:j+SqrSize-1));%发现非零元素的行、列、值，可为空
            [u2,v2,w2]=find(pixel_unmarkedge(i:i+SqrSize-1,j:j+SqrSize-1));
            process= [u1,v1,w1];mark=[u2,v2,w2];%分别赋给process和mark
            if ~isempty(process)&&~isempty(mark) %如果像素P未被处理且未被标记     %find(pixel_unprocessed(i:i+SqrSize-1,j:j+SqrSize-1)) %if P is unprocessed and not marked as an edge 
                  for k=1:nPop
                    [particle_position_function,particle_decoded_function]=Initialization(i,j,u1,v1,L);%粒子群初始化编码及解码
                    particle_position(k,:)=particle_position_function(1,:); %初始化的50个粒子，
                    particle_decoded(k,:,:)=particle_decoded_function(1,:,:);%解码存放坐标，两层，1层存放i，2层存放j,[o,d1,d2,...,dL,...,d2L]
                  end
               while it<=MaxIter
%                   for k=1:nPop
%                     [particle_position_function,particle_decoded_function]=Initialization(i,j,aa,bb,L);%粒子群初始化编码
%                     particle_position(k,:)=particle_position_function(1,:); %初始化的50个粒子，
%                     particle_decoded(k,:,:)=particle_decoded_function(1,:,:);%解码存放坐标，两层，1层存放i，2层存放j,[o,d1,d2,...,dL,...,d2L]
%                   end
                  for m=1:nPop
                      [Fitness_function,~]=Fitness(particle_position(m,:),particle_decoded(m,:,:),picS,L,PScoreS);%评估U(C),PScore(C),CCost(C),Fitness(C)
                      particle_fitness(m)=Fitness_function;
                      if particle_fitness(m)>particle_best_fitness(m);
                         particle_pbest_position(m,:)=particle_position(m,:);
                         particle_best_fitness(m)=particle_fitness(m);
                      end
                      particle_memory(it,:,m)=particle_position(m,:);%记下每个粒子的位置
                  end
                  [~,I]=max(particle_best_fitness);%返回最大值对应的行号。[C,I]=max(a);->C表示的是矩阵a每列的最大值，I表示的是每个最大值对应的下标
                  particle_gbest_position=particle_pbest_position(I,:);%初始化时：将最好的粒子位置赋给particle_gbest_position
                  
                  for n=1:nPop
                      particle_velocity(n,:)=w.*particle_velocity(n,:)+c1.*rand([1,2*L+2]).*(particle_pbest_position(n,:)-particle_position(n,:))...
                          +c2.*rand([1,2*L+2]).*(particle_gbest_position(1,:)-particle_position(n,:));%粒子速度更新
                      for n1=1:2*L+2
                          particle_velocity(n,n1)=max(particle_velocity(n,n1),particle_min_velocity);
                          particle_velocity(n,n1)=min(particle_velocity(n,n1),particle_max_velocity);
                      end
                      particle_position(n,:)=particle_position(n,:)+particle_velocity(n,:);%[o1,o2,d1,d2,...,dL,dL+1,...,d2L],粒子位置更新
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
%                       particle_fitness(n)=Fitness_function;%更新粒子适应度、局部、全局最优值
%                       if particle_fitness(n)>particle_best_fitness(n);
%                          particle_pbest_position(n,:)=particle_position(n,:);
%                          particle_best_fitness(n)=particle_fitness(n);
%                       end

%                       particle_memory(it,:,n)=particle_position(n,:);
                      CrossC=ismember(particle_position(n,:),particle_memory(:,:,n),'rows'); %检测是否与历史粒子有重叠 
                      if CrossC~=0||PScoreC<=HP
                          [particle_position_function,particle_decoded_function]=Initialization(i,j,u1,v1,L);%粒子群初始化编码
                          particle_position(n,:)=particle_position_function(1,:); %nPop个粒子
                          particle_decoded(n,:,:)=particle_decoded_function(1,:,:);%解码存放坐标，两层，1层存放i，2层存放j,[o,d1,d2,...,dL,...,d2L]
                      end
                  end
%                   [~,P]=max(particle_best_fitness);
%                   particle_gbest_position=particle_pbest_position(P,:);%位置和速度更新时：将最好的粒子位置赋给particle_gbest_position
                  
                  it=it+1;
               end
%                 particle_memory=zeros(MaxIter,2*L+2,nPop);
                particle_best_decoded=Decoded(particle_gbest_position,i,j,L);%zeros(1,2*L+1,2)最好的粒子解码得到其坐标
                [~,PScoreC]=Fitness(particle_gbest_position(1,:),particle_best_decoded(1,:,:),picS,L, PScoreS);
                if PScoreC>HP
                    %mark all pixels on the curve C as edges and the pixels
                    %within the rectangle are not marked as processed
                    %pixels曲线上所有像素标记为边缘,但方框内的像素标记未处理
                    for t=1:2*L+1
                        pixel_finalmark_edge(particle_best_decoded(1,t,1),particle_best_decoded(1,t,2))=1;%标记为边缘
                        pixel_unmarkedge(particle_best_decoded(1,t,1),particle_best_decoded(1,t,2))=0;%已标记为边缘
                        if particle_best_decoded(1,t,1)>=i && particle_best_decoded(1,t,1)<=i+SqrSize-1 && particle_best_decoded(1,t,2)>=j && particle_best_decoded(1,t,2)<=j+SqrSize-1
                            pixel_unprocessed(particle_best_decoded(1,t,1),particle_best_decoded(1,t,2))=1;%方框内像素标记为未处理
                        else
                            pixel_unprocessed(particle_best_decoded(1,t,1),particle_best_decoded(1,t,2))=0;%标记为已处理
                        end
                    end
                else            
                    %if no feasible particle found 
                    %mark all pixels within the red rectangle as processed
                    %end
                    pixel_unprocessed(i:i+SqrSize-1,j:j+SqrSize-1)=0;  %方框内所有像素标记为已处理
                end
            end
        end 
    end
end

finalpic=pixel_finalmark_edge(L:height+L-1,L:width+L-1);
finalpic=mat2gray(finalpic);
figure;
imshow(finalpic);























