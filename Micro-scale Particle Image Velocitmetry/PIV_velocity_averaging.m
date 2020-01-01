%Written by Supreet Singh Bahga (IIT Delhi)
%v2: overlapping interrogation regions
%Correlation averaging 
clear all;
close all;

%----------------INPUT------------------------------------------
%load images
%Read image files
Nend = 20; %>10
for i = 1:9
    A(:,:,i) = double(imread(strcat('x_0000',num2str(i),'.tif')));
end
for i = 10:Nend
    A(:,:,i) = double(imread(strcat('x_000',num2str(i),'.tif')));
end

A = A - mean(A,3);

%define interrogation region
Lx=128; %pixels
Ly=128; %pixels
overlap=0.3; %fraction <=1 overlap of adjacent interrogation regions
%---------------------------------------------------------------


x_shift=floor(overlap*Lx);
y_shift=floor(overlap*Ly);
[Ny,Nx]=size(A(:,:,1)); %number of interrogation regions in x and y direction

x=1+Lx/2:x_shift:Nx-Lx/2;
y=1+Ly/2:y_shift:Ny-Ly/2;
nx=length(x);
ny=length(y);

[XX,YY]=meshgrid(x,y);
u=zeros(ny,nx);
v=zeros(ny,nx);
max_Corr=zeros(ny,nx);

%%
tic
for ix=1:nx
    for iy=1:ny
         for j = 1:Nend-1
    A1=A((iy-1)*y_shift+1:(iy-1)*y_shift+1+Ly, (ix-1)*x_shift+1:(ix-1)*x_shift+1+Lx,j);
    B1=A((iy-1)*y_shift+1:(iy-1)*y_shift+1+Ly, (ix-1)*x_shift+1:(ix-1)*x_shift+1+Lx,j+1);    
    Corr= fftshift(real(ifft2(fft2(A1).*conj(fft2(B1)))));
    [max_Corr(iy,ix),li]=max(Corr(:));
    [row,column]=ind2sub(size(Corr),li);
    u(iy,ix)=u(iy,ix)+ Lx/2-column+1;
    v(iy,ix)=v(iy,ix)+ row-Ly/2-1;
         end
    end
end
toc
%%
% figure(1);
% quiver(XX,YY,flipud(u),flipud(v))
% xlim([1 Nx]);
% ylim([1 Ny]);


figure(2);
imagesc(A(:,:,1)); colormap gray
hold on;
quiver(XX,YY,u,-v,'g-', 'linewidth',2)