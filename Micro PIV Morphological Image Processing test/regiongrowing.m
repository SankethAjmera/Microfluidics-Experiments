function [BinImage,memory_matrix] = regiongrowing(BinImage,seedx,seedy,memory_matrix)
% Finds all the white pixels and their indices in the connected region
[m,n] = size(BinImage);
for i = 1:m
    for j = 1:n
    if seedx > 1 && BinImage(seedx-1,seedy) == 1
        BinImage(seedx-1,seedy) = 0;
        memory_matrix = [memory_matrix;[seedx-1,seedy]];
        [BinImage,memory_matrix] = regiongrowing(BinImage,seedx-1,seedy,memory_matrix);
    elseif seedx < m && BinImage(seedx+1,seedy) == 1
        BinImage(seedx+1,seedy) = 0;
        memory_matrix = [memory_matrix;[seedx+1,seedy]];
        [BinImage,memory_matrix] = regiongrowing(BinImage,seedx+1,seedy,memory_matrix);
    elseif seedy > 1 && BinImage(seedx,seedy-1) == 1
        BinImage(seedx,seedy-1) = 0;
        memory_matrix = [memory_matrix;[seedx,seedy-1]];
        [BinImage,memory_matrix] = regiongrowing(BinImage,seedx,seedy-1,memory_matrix);
    elseif seedy < n && BinImage(seedx,seedy+1) == 1
        BinImage(seedx,seedy+1) = 0;
        memory_matrix = [memory_matrix;[seedx,seedy+1]];
        [BinImage,memory_matrix] = regiongrowing(BinImage,seedx,seedy+1,memory_matrix);    
    end
    end
end
BinImage(seedx,seedy) = 0;
memory_matrix = [memory_matrix;[seedx,seedy]];
memory_matrix= unique(memory_matrix,'rows');
end

