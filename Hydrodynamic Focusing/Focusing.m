%Calculating the width of the focused stream at a given location

%% Selecting the image file 
% Make sure you have saved images in the working directory

[filename,pathname] = uigetfile('multiselect','on','*');


%% Cleaning the Image and selecting ROI

Img = imread(fullfile(pathname,filename));

Int_image = double(rgb2gray(Img)); % Colour to intensity conversion

maxi = double(max(max(Int_image))); %Maximum intensity 
mini = double(min(min(Int_image))); %Minimum intensity

Int_image = (Int_image-mini)/(maxi-mini); %Scaling to [0,1]

figure, imshow(Int_image), colorbar, axis on, axis image; %Show image to select two points

uiwait(msgbox('Select any point along the outlet channel')) %User interface wait

[xpoint,ypoint] = ginput; % you get x and y coordinates in this 

%% Selecting the intensity dips at the channel boundary and in the focused fluid

x1 = round(xpoint(1)); %Looking at a particular cross section

figure, plot(Int_image(:,x1)); % To select the intensity peaks

uiwait(msgbox('Select the channel peaks first and then of the focused fluid')) %User interface wait

[xpoint,ypoint] = ginput; %Select the peaks here

%% Calculating the width of focused fluid

width_channel = xpoint(2)-xpoint(1);

width_focus = xpoint(4)-xpoint(3);

Actual_width_of_focus = width_focus*500/width_channel;

fprintf('Calculated width of the channel is %.2f', Actual_width_of_focus);



