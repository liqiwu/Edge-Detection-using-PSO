%%
%��δ���Ϊ��Ե�����أ���Եǿ��ֵ����TH�����Ϊ1
function particle_unmarkedge_function=unmarkedge(L,height,width,LocalEdgeMagS,TH)
[C,I]=find(LocalEdgeMagS>TH);
A=[C,I]';
particle_unmarkedge_function=zeros(height+2*L-2,width+2*L-2);
for i=1:size(A,2) %��������
    particle_unmarkedge_function(A(1,i),A(2,i))=1;
end

