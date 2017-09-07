function [particle_position_function,particle_decoded_function]=Initialization(i,j,aa,bb,L)
particle_position_function=zeros(1,2*L+2); %一个粒子位置初始化
particle_decoded_function=zeros(1,2*L+1,2); %粒子上的像素坐标
ab=[aa,bb]';
ablength=size(ab,2);
anyrow=ceil(rand(1,1)*ablength);%提取任意一列

% for m=1:nPop
    %%
    %编码
    particle_position_function(1)=ab(1,anyrow)-1;%o1
    particle_position_function(2)=ab(2,anyrow)-1;%o2
    particle_position_function(3)=round(rand(1,1)*7); %d1
    %d2,d3,d4,..dL
    for n=3:L+2
        if n==L+2
            break;
        end
      switch particle_position_function(n)
          case 0
               a=[0,1,2,3,5,6,7];
               b=ceil(rand(1,1)*7);
               particle_position_function(n+1)=a(b);
          case 1
               a=[0,1,2,3,4,6,7];
               b=ceil(rand(1,1)*7);
               particle_position_function(n+1)=a(b);
          case 2
               a=[0,1,2,3,4,5,7];
               b=ceil(rand(1,1)*7);
               particle_position_function(n+1)=a(b);
          case 3
               a=[0,1,2,3,4,5,6];
               b=ceil(rand(1,1)*7);
               particle_position_function(n+1)=a(b);
          case 4
               a=[1,2,3,4,5,6,7];
               b=ceil(rand(1,1)*7);
               particle_position_function(n+1)=a(b);
          case 5
               a=[0,2,3,4,5,6,7];
               b=ceil(rand(1,1)*7);
               particle_position_function(n+1)=a(b);
          case 6
               a=[0,1,3,4,5,6,7];
               b=ceil(rand(1,1)*7);
               particle_position_function(n+1)=a(b);
          case 7
               a=[0,1,2,4,5,6,7];
               b=ceil(rand(1,1)*7);
               particle_position_function(n+1)=a(b);
      end
    end 
     switch  particle_position_function(3)
        case 0
             a=[1,2,3,4,5,6,7];
             b=ceil(rand(1,1)*7);
             particle_position_function(L+3)=a(b); %dL+1
        case 1
             a=[0,2,3,4,5,6,7];
             b=ceil(rand(1,1)*7);
             particle_position_function(L+3)=a(b);
        case 2
             a=[0,1,3,4,5,6,7];
             b=ceil(rand(1,1)*7);
             particle_position_function(L+3)=a(b);
        case 3
             a=[0,1,2,4,5,6,7];
             b=ceil(rand(1,1)*7);
             particle_position_function(L+3)=a(b);
        case 4
             a=[0,1,2,3,5,6,7];
             b=ceil(rand(1,1)*7);
             particle_position_function(L+3)=a(b);
        case 5
             a=[0,1,2,3,4,6,7];
             b=ceil(rand(1,1)*7);
             particle_position_function(L+3)=a(b);
        case 6
             a=[0,1,2,3,4,5,7];
             b=ceil(rand(1,1)*7);
             particle_position_function(L+3)=a(b);
        case 7
             a=[0,1,2,3,4,5,6];
             b=ceil(rand(1,1)*7);
             particle_position_function(L+3)=a(b);
     end
     %dL+2,...,d2L
    for u=L+3:2*L+2
        if u==2*L+2
            break;
        end
        switch particle_position_function(L+3)
            case 0
                 a=[0,1,2,3,5,6,7];
                 b=ceil(rand(1,1)*7);
                 particle_position_function(u+1)=a(b);
            case 1
                 a=[0,1,2,3,4,6,7];
                 b=ceil(rand(1,1)*7);
                 particle_position_function(u+1)=a(b);
            case 2
                 a=[0,1,2,3,4,5,7];
                 b=ceil(rand(1,1)*7);
                 particle_position_function(u+1)=a(b);
            case 3
                 a=[0,1,2,3,4,5,6];
                 b=ceil(rand(1,1)*7);
                 particle_position_function(u+1)=a(b);
            case 4
                 a=[1,2,3,4,5,6,7];
                 b=ceil(rand(1,1)*7);
                 particle_position_function(u+1)=a(b);
            case 5
                 a=[0,2,3,4,5,6,7];
                 b=ceil(rand(1,1)*7);
                 particle_position_function(u+1)=a(b);
            case 6
                 a=[0,1,3,4,5,6,7];
                 b=ceil(rand(1,1)*7);
                 particle_position_function(u+1)=a(b);
            case 7
                 a=[0,1,2,4,5,6,7];
                 b=ceil(rand(1,1)*7);
                 particle_position_function(u+1)=a(b);
        end
    end
    %%
    %解码
    particle_decoded_function(1,1,1)=i+particle_position_function(1);%o1在图像上的坐标，对应图像高i
    particle_decoded_function(1,1,2)=j+particle_position_function(2);%o2在图像上的坐标，对应图像宽j
    for g=3:L+2
        switch particle_position_function(g)
            case 0
                particle_decoded_function(1,g-1,1)=particle_decoded_function(1,g-2,1)-1;
                particle_decoded_function(1,g-1,2)=particle_decoded_function(1,g-2,2);
            case 1
                particle_decoded_function(1,g-1,1)=particle_decoded_function(1,g-2,1)-1;
                particle_decoded_function(1,g-1,2)=particle_decoded_function(1,g-2,2)+1;
            case 2
                particle_decoded_function(1,g-1,1)=particle_decoded_function(1,g-2,1);
                particle_decoded_function(1,g-1,2)=particle_decoded_function(1,g-2,2)+1;
            case 3
                particle_decoded_function(1,g-1,1)=particle_decoded_function(1,g-2,1)+1;
                particle_decoded_function(1,g-1,2)=particle_decoded_function(1,g-2,2)+1;
            case 4
                particle_decoded_function(1,g-1,1)=particle_decoded_function(1,g-2,1)+1;
                particle_decoded_function(1,g-1,2)=particle_decoded_function(1,g-2,2);
            case 5
                particle_decoded_function(1,g-1,1)=particle_decoded_function(1,g-2,1)+1;
                particle_decoded_function(1,g-1,2)=particle_decoded_function(1,g-2,2)-1;
            case 6
                particle_decoded_function(1,g-1,1)=particle_decoded_function(1,g-2,1);
                particle_decoded_function(1,g-1,2)=particle_decoded_function(1,g-2,2)-1;
            case 7
                particle_decoded_function(1,g-1,1)=particle_decoded_function(1,g-2,1)-1;
                particle_decoded_function(1,g-1,2)=particle_decoded_function(1,g-2,2)-1;
        end
    end
   
         switch particle_position_function(L+3)
            case 0
                particle_decoded_function(1,L+2,1)=particle_decoded_function(1,1,1)-1;
                particle_decoded_function(1,L+2,2)=particle_decoded_function(1,1,2);
            case 1
                particle_decoded_function(1,L+2,1)=particle_decoded_function(1,1,1)-1;
                particle_decoded_function(1,L+2,2)=particle_decoded_function(1,1,2)+1;
            case 2
                particle_decoded_function(1,L+2,1)=particle_decoded_function(1,1,1);
                particle_decoded_function(1,L+2,2)=particle_decoded_function(1,1,2)+1;
            case 3
                particle_decoded_function(1,L+2,1)=particle_decoded_function(1,1,1)+1;
                particle_decoded_function(1,L+2,2)=particle_decoded_function(1,1,2)+1;
            case 4
                particle_decoded_function(1,L+2,1)=particle_decoded_function(1,1,1)+1;
                particle_decoded_function(1,L+2,2)=particle_decoded_function(1,1,2);
            case 5
                particle_decoded_function(1,L+2,1)=particle_decoded_function(1,1,1)+1;
                particle_decoded_function(1,L+2,2)=particle_decoded_function(1,1,2)-1;
            case 6
                particle_decoded_function(1,L+2,1)=particle_decoded_function(1,1,1);
                particle_decoded_function(1,L+2,2)=particle_decoded_function(1,1,2)-1;
            case 7
                particle_decoded_function(1,L+2,1)=particle_decoded_function(1,1,1)-1;
                particle_decoded_function(1,L+2,2)=particle_decoded_function(1,1,2)-1;
         end
         
      for h=L+3:2*L+1
          switch particle_position_function(h+1)
            case 0
                particle_decoded_function(1,h,1)=particle_decoded_function(1,h-1,1)-1;
                particle_decoded_function(1,h,2)=particle_decoded_function(1,h-1,2);
            case 1
                particle_decoded_function(1,h,1)=particle_decoded_function(1,h-1,1)-1;
                particle_decoded_function(1,h,2)=particle_decoded_function(1,h-1,2)+1;
            case 2
                particle_decoded_function(1,h,1)=particle_decoded_function(1,h-1,1);
                particle_decoded_function(1,h,2)=particle_decoded_function(1,h-1,2)+1;
            case 3
                particle_decoded_function(1,h,1)=particle_decoded_function(1,h-1,1)+1;
                particle_decoded_function(1,h,2)=particle_decoded_function(1,h-1,2)+1;
            case 4
                particle_decoded_function(1,h,1)=particle_decoded_function(1,h-1,1)+1;
                particle_decoded_function(1,h,2)=particle_decoded_function(1,h-1,2);
            case 5
                particle_decoded_function(1,h,1)=particle_decoded_function(1,h-1,1)+1;
                particle_decoded_function(1,h,2)=particle_decoded_function(1,h-1,2)-1;
            case 6
                particle_decoded_function(1,h,1)=particle_decoded_function(1,h-1,1);
                particle_decoded_function(1,h,2)=particle_decoded_function(1,h-1,2)-1;
            case 7
                particle_decoded_function(1,h,1)=particle_decoded_function(1,h-1,1)-1;
                particle_decoded_function(1,h,2)=particle_decoded_function(1,h-1,2)-1;
                  
          end
      end
   
% end

