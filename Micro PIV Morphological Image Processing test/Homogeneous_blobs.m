%% Image normalisation and obtaning binary image (Otsu's method)
clear all
close all
I = imread('before.tif');
I_norm = mat2gray(I); % nomrlaised image
Threshold = graythresh(I_norm); % obtain threshold using Otsu's method
I_bin = (I_norm > 0.5);% binary image
imshow(I_bin)
%% Generating a gaussian kernel

n = 3; %size of the kernel, choose an odd number
kernel1 = zeros(n,n);
kernel2 = zeros(n,n);
x_c = (n+1)/2; %ceter
y_c = x_c;%center
sigma = 5;

for i=1:n
    for j = 1:n
        if sqrt((i-x_c)^2+(j-x_c)^2) < (n/2)
           kernel2(i,j) = exp(-((i-x_c)^2+(j-y_c)^2)/(2*sigma));
           kernel1(i,j) = 1;
        end
    end
end
I_bin = imopen(I_bin,kernel1); %Opening
imshow(I_bin)
I_bin = imresize(I_bin,0.3);
BinaryImage = I_bin;
%% Replacing the blobs with their centres of mass

I_com = zeros(size(I_bin)); %Matrix with centres of mass of blobs
b = 400; %Guess max number of blobs %max = ((m*n+1)/2) if m,n are odd % max = mn/2 else
for i = 1:b 
    if sum(sum(I_bin)) > 0
        [M,N] = max(I_bin(:));
        [seedx, seedy] = ind2sub(size(I_bin),N); %seeds are the indices of first "1"
        %[seedx,seedy] = findseedbyrow(I_bin);
        [I_bin,B] = regiongrowing(I_bin,seedx,seedy,[]);
        if size(B,1) > 5 %Getting rid of small patches/noise
            K = mean(B,1);
            x_com = floor(K(1));
            y_com = floor(K(2));
            I_com(x_com,y_com) = 1; 
        end
        if mod(i,0.1*b) == 0
            fprintf('%d percent. \n' ,i/(b/100))
        end
    end
end
figure

imshowpair(BinaryImage,I_com,'montage'), colormap(gray), colorbar
 %% Replacing the center of blobs with gaussian probabilities

[m,p] = size(I_com);
for i = 1:m
    for j = 1:p
        if I_com(i,j) ==1 
            if i-(n-1)/2 > 0 && i+(n-1)/2 < m && j-(n-1)/2 >0 && j+(n-1)/2 < p
                I_com(i-(n-1)/2:i+(n-1)/2,j-(n-1)/2:j+(n-1)/2) = kernel2;
            end
        end
    end
end
imshowpair(BinaryImage,I_com,'montage'), colormap(gray), colorbar
%% Save image
imwrite(I_com,'Image2.tif')
imshow('Image2.tif')
