function [Fitness_function,PScoreC]=Fitness(position,decoded,picS,L,PScoreS)
%position:particle_position=zeros(nPop,2*L+2)-[o1,o2,d1,d2,...,dL,dL+1,...,d2L]
%decoded:particle_decoded=zeros(nPop,2*L+1,2)-解码存放坐标，两层，1层存放i，2层存放j,[o,d1,d2,...,dL,...,d2L]
%%
%连续边缘的可能性得分
x=zeros(1,2*L+1);
y=zeros(1,2*L+1);
Pixelsum=0;
PScoresum=0;
for u=1:2*L+1
    x(u)=decoded(:,u,1);
    y(u)=decoded(:,u,2);
end

for v=1:2*L
    Pixelsub=abs(picS(x(v+1),y(v+1))-picS(x(v),y(v)));
    Pixelsum=Pixelsum+Pixelsub;
end
UC=Pixelsum*(1/(255*2*L));

for p=1:L
    PScoresum=PScoresum+PScoreS(x(p),y(p),position(:,p+2)+1);
end
PScoresum=PScoresum+PScoreS(x(1),y(1),position(:,L+3)+1);
for q=L+2:2*L
    PScoresum=PScoresum+PScoreS(x(q),y(q),position(:,q+2)+1);
end
PScoreC=(PScoresum/(2*L+1))/(1+UC);
%%
%连续边缘的曲率成本
w3=40;
CCsum1=0;
CCsum2=0;
for s=3:L+1
    if abs(position(:,s)-position(:,s+1))<=4
        CC1=abs(position(:,s)-position(:,s+1))/w3;
    else
        CC1=(8-abs(position(:,s)-position(:,s+1)))/w3;
    end
    CCsum1=CCsum1+CC1;
end
for s=L+3:2*L+1
    if abs(position(:,s)-position(:,s+1))<=4
        CC2=abs(position(:,s)-position(:,s+1))/w3;
    else
        CC2=(8-abs(position(:,s)-position(:,s+1)))/w3;
    end
    CCsum2=CCsum2+CC2;
end
CCost=(CCsum1+CCsum2)/(2*L-2);
%%
%粒子适应度
Fitness_function=PScoreC-CCost;


