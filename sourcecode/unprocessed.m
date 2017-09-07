%%
%将未处理像素（边缘强度值大于TH）的标记为1
function particle_unprocessed_function=unprocessed(L,height,width,LocalEdgeMagS,TH)
[C,I]=find(LocalEdgeMagS>TH);
A=[C,I]';
particle_unprocessed_function=zeros(height+2*L-2,width+2*L-2);
for i=1:size(A,2) %矩阵的列数
    particle_unprocessed_function(A(1,i),A(2,i))=1;
end

