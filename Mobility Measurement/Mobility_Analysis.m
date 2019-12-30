clc
clear
close all

field = 14/22/(35e-3)*1000; % volts
frame_rate = 32; % fps
scaling = 50e-6/27;% 27 px = 50 um



BG = double(imread('BG.tif'));
BG = BG(40:69,:);
FF = double(imread('FF.tif'));

nstart = 50;
nend = 180;
peaks = zeros(nend-nstart+1,2);

for i = nstart:nend
      Img = double(imread(['1_X',num2str(i),'.tif']));
      Img = Img(40:69,:); % channel ROI
      img_mean = mean(Img); % mean

      [~,peak_loc1] = max(img_mean);
      img_new = img_mean(peak_loc1+50:end);% taking location after mean
      [~,peak_loc2] = max(img_new);

      peaks(i-nstart+1,:) = [peak_loc1;peak_loc1+50+peak_loc2]*scaling;
end

x = (1:nend-nstart+1)/frame_rate; % number of frames
% plot(x,peaks(:,1),'.')
% hold on
% plot(x,peaks(:,2),'.')
% xlabel('time (s)')
% ylabel('distance of peak')


P1 = polyfit(x',peaks(:,1),1);
velocity1 = P1(1); % EOF+EK velocity
P2 = polyfit(x',peaks(:,2),1);
velocity2 = P2(1); % EOF velocity

EOF_mobility = velocity1/field
EP_mobility = (velocity2-velocity1)/field
