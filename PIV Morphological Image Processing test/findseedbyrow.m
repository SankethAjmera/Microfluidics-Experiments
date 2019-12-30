function [seedx,seedy] = findseedbyrow(BinaryImage)
% Finds the seed in the first blob/white patch (row wise iteration)
[m,n] = size(BinaryImage);
for i = 1:m
    for j = 1:n
        if BinaryImage(i,j) == 1
            seedx = i;
            seedy = j;
        end
    end
end
end

