%%
%检查每个粒子位置是否符合要求
function particle_position_check=checkposition(particle_position,L)
particle_position_check=zeros(1,2*L+2);
particle_position_check(1)=particle_position(1);
particle_position_check(2)=particle_position(2);
a=[0 1 2 3 4 5 6 7];
for m=3:L+1
    if particle_position(m)<=3
        if a(particle_position(m+1)+1)==a(particle_position(m)+5)
            b=a;
            b(particle_position(m+1)+1)=[];
            particle_position(m+1)=b(ceil(rand(1,1)*length(b)));
        end
    else 
        if a(particle_position(m+1)+1)==a(particle_position(m)-3)
            b=a;
            b(particle_position(m+1)+1)=[];
            particle_position(m+1)=b(ceil(rand(1,1)*length(b)));
        end
    end
end
if particle_position(L+3)==particle_position(3)
    b=a;
    b(particle_position(L+3)+1)=[];
    particle_position(L+3)=b(ceil(rand(1,1)*length(b)));
end
for n=L+3:2*L+1
    if particle_position(n)<=3
        if a(particle_position(n+1)+1)==a(particle_position(n)+5)
            b=a;
            b(particle_position(n+1)+1)=[];
            particle_position(n+1)=b(ceil(rand(1,1)*length(b)));
        end
    else
        if a(particle_position(n+1)+1)==a(particle_position(n)-3)
            b=a;
            b(particle_position(n+1)+1)=[];
            particle_position(n+1)=b(ceil(rand(1,1)*length(b)));
        end
    end
end
for l=3:2*L+2
    particle_position_check(l)=particle_position(l);
end
