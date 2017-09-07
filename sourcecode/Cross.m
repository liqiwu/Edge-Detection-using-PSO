function Cross_times=Cross(it,n,particle_position)
particle_memory=[];
particle_memory(it,:,n)=particle_position;
Cross_times=ismember(particle_position,particle_memory(:,:,n),'rows');


