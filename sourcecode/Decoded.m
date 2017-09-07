%%
%解码
function Decoded_function=Decoded(particle_position,i,j,L)
Decoded_function=zeros(1,2*L+1,2);
Decoded_function(1,1,1)=i+particle_position(1);%o1在图像上的坐标，对应图像高i
Decoded_function(1,1,2)=j+particle_position(2);%o2在图像上的坐标，对应图像宽j
    for g=3:L+2
        switch particle_position(g)
            case 0
                Decoded_function(1,g-1,1)=Decoded_function(1,g-2,1)-1;
                Decoded_function(1,g-1,2)=Decoded_function(1,g-2,2);
            case 1
                Decoded_function(1,g-1,1)=Decoded_function(1,g-2,1)-1;
                Decoded_function(1,g-1,2)=Decoded_function(1,g-2,2)+1;
            case 2
                Decoded_function(1,g-1,1)=Decoded_function(1,g-2,1);
                Decoded_function(1,g-1,2)=Decoded_function(1,g-2,2)+1;
            case 3
                Decoded_function(1,g-1,1)=Decoded_function(1,g-2,1)+1;
                Decoded_function(1,g-1,2)=Decoded_function(1,g-2,2)+1;
            case 4
                Decoded_function(1,g-1,1)=Decoded_function(1,g-2,1)+1;
                Decoded_function(1,g-1,2)=Decoded_function(1,g-2,2);
            case 5
                Decoded_function(1,g-1,1)=Decoded_function(1,g-2,1)+1;
                Decoded_function(1,g-1,2)=Decoded_function(1,g-2,2)-1;
            case 6
                Decoded_function(1,g-1,1)=Decoded_function(1,g-2,1);
                Decoded_function(1,g-1,2)=Decoded_function(1,g-2,2)-1;
            case 7
                Decoded_function(1,g-1,1)=Decoded_function(1,g-2,1)-1;
                Decoded_function(1,g-1,2)=Decoded_function(1,g-2,2)-1;
        end
    end
   
         switch particle_position(L+3)
            case 0
                Decoded_function(1,L+2,1)=Decoded_function(1,1,1)-1;
                Decoded_function(1,L+2,2)=Decoded_function(1,1,2);
            case 1
                Decoded_function(1,L+2,1)=Decoded_function(1,1,1)-1;
                Decoded_function(1,L+2,2)=Decoded_function(1,1,2)+1;
            case 2
                Decoded_function(1,L+2,1)=Decoded_function(1,1,1);
                Decoded_function(1,L+2,2)=Decoded_function(1,1,2)+1;
            case 3
                Decoded_function(1,L+2,1)=Decoded_function(1,1,1)+1;
                Decoded_function(1,L+2,2)=Decoded_function(1,1,2)+1;
            case 4
                Decoded_function(1,L+2,1)=Decoded_function(1,1,1)+1;
                Decoded_function(1,L+2,2)=Decoded_function(1,1,2);
            case 5
                Decoded_function(1,L+2,1)=Decoded_function(1,1,1)+1;
                Decoded_function(1,L+2,2)=Decoded_function(1,1,2)-1;
            case 6
                Decoded_function(1,L+2,1)=Decoded_function(1,1,1);
                Decoded_function(1,L+2,2)=Decoded_function(1,1,2)-1;
            case 7
                Decoded_function(1,L+2,1)=Decoded_function(1,1,1)-1;
                Decoded_function(1,L+2,2)=Decoded_function(1,1,2)-1;
         end
         
      for h=L+3:2*L+1
          switch particle_position(h+1)
            case 0
                Decoded_function(1,h,1)=Decoded_function(1,h-1,1)-1;
                Decoded_function(1,h,2)=Decoded_function(1,h-1,2);
            case 1
                Decoded_function(1,h,1)=Decoded_function(1,h-1,1)-1;
                Decoded_function(1,h,2)=Decoded_function(1,h-1,2)+1;
            case 2
                Decoded_function(1,h,1)=Decoded_function(1,h-1,1);
                Decoded_function(1,h,2)=Decoded_function(1,h-1,2)+1;
            case 3
                Decoded_function(1,h,1)=Decoded_function(1,h-1,1)+1;
                Decoded_function(1,h,2)=Decoded_function(1,h-1,2)+1;
            case 4
                Decoded_function(1,h,1)=Decoded_function(1,h-1,1)+1;
                Decoded_function(1,h,2)=Decoded_function(1,h-1,2);
            case 5
                Decoded_function(1,h,1)=Decoded_function(1,h-1,1)+1;
                Decoded_function(1,h,2)=Decoded_function(1,h-1,2)-1;
            case 6
                Decoded_function(1,h,1)=Decoded_function(1,h-1,1);
                Decoded_function(1,h,2)=Decoded_function(1,h-1,2)-1;
            case 7
                Decoded_function(1,h,1)=Decoded_function(1,h-1,1)-1;
                Decoded_function(1,h,2)=Decoded_function(1,h-1,2)-1;
                  
          end
      end