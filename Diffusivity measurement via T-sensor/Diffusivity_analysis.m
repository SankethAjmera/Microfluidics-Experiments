clear all;
close all;
clc;
    
% Read image, Background and flatfield

Img = double(imread(strcat('0.05_0000',num2str(2),'.tif')));
Img = imrotate(flip(Img ,2),0.5); % image registration
BG = double(imread('bg_00001.tif'));
BG = imrotate(flip(BG ,2),0.5);
FF = double(imread('ff_00001.tif'));
FF = imrotate(flip(FF ,2),0.5);

%% Selecting the region of interest = channel only

X1 = 385;
X2 = 645;
Y1 = 367;
Y2 = 1395;

% Background and fluorescent field subtraction
Img1= Img;
Img = (Img1(X1:X2,Y1:Y2)-BG(X1:X2,Y1:Y2))./(FF(X1:X2,Y1:Y2)-BG(X1:X2,Y1:Y2));

%% Selecting intenmsity along [three] locations across the channel

scaling = 1.8797e-6;
nu_locations = 5; % number of locations along the channel where intensity is taken
x_loc = round(linspace(1,Y2-Y1,nu_locations));

n = size(Img,1);
x = linspace(-250e-6,250e-6,n);
I_avg = zeros(nu_locations,n);
var = zeros(1,nu_locations);


for i = 1:nu_locations
    I = Img(:,x_loc(i));
    window_size = 10;
    I_avg(i,:) = normalise(tsmovavg(I,'s',window_size,1));  
    y = I_avg(i,:);
    ft = fittype( '0.5+0.5.*erf(0.5.*x./b);', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = 0.89854827782633;
    idx = isfinite(x) & isfinite(y); % excluding NaN and infinity values
    [fitresult, gof] = fit( x(idx)', y(idx)', ft, opts );
    var(i) = (fitresult.b);
end

flow_rate = 0.05*1e-9/60;
area = 500*100*1e-12;
velocity  = flow_rate/area;

x_loc = x_loc*scaling;

fit = polyfit(x_loc,var,1);

slope = fit(1);

diffusivity = slope*velocity/4; % slope = 4.D/u


%% Similarity solution

x0 = 500e-6; % virtual start location of diffusion

y = I_avg(1,:);


for i = 1:nu_locations
    plot(x/sqrt(x_loc(i)+500e-6),I_avg(i,:),'.')
    hold on
end


xlabel('$\frac{y}{\sqrt{x}} ({\it{a.u.}}) $','Interpreter','latex')
ylabel('Intensity ({\it{a.u.}})')
set(gca,'FontSize',15)

%%

for i = 1:3:nu_locations
    txt = ([num2str(round(x_loc(i)*1e6)),' \mum']);
    plot(x,I_avg(i,:),'.','DisplayName',txt,'MarkerSize',10)
    hold on
    legend;
end



xlabel('y($\mu m$) ','Interpreter','latex')
ylabel('Intensity ({\it{a.u.}})')
annotation('textbox', [0.2, 0.8, 0.1, 0.1], 'String', 'Location along channel')
set(gca,'FontSize',15)



function [out] = normalise(I)
    mini = min(I(:));
    maxi = max(I(:));
    out = (I-mini)/(maxi-mini);
end


