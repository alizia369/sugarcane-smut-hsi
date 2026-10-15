
%%%%% Pink Camera save test

%filenamepath='.\data\Hyperspectral Data\sugarcane\SRA Invisible Pink 12 Feb\Pindar-A-X\processed\Pindar-A-X.hdr';


%[  finalMat, bandName ] = saveCube_pinkCam(  filenamepath,'',true );


%%

%%%% Small Black Camera save test
%filenamepath='.\data\Hyperspectral Data\sugarcane\small infrared camera black\field-outdoor\cp29-116-2.png';
%[ normat, bandName ] = saveCube_smallCam( filenamepath,25,'',true);
%%
filenamepath='.\data\Hyperspectral Data\sugarcane\small infrared camera black\field-outdoor\cp29-116-2.mat';
load(filenamepath);
figure,imshow(normat(:,:,9));
%%
% a_gray = testimg;%normat(:,:,9);
% %a_gray = rgb2gray(a);
% %level = 0.1;
% level = graythresh(a_gray);
% a_bw = imbinarize(a_gray,level*4);
% figure,imshow(a_bw);
% Icomp = imcomplement(a_bw);
% 
% figure,
% hold on
% [B,L] = bwboundaries(a_bw);
% imshow(label2rgb(L, @jet, [.5 .5 .5]))
% %imshow(a_bw);
% hold on
% for k = 1:length(B)
%    boundary = B{k};
%    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 1)
% end
%%
crop_cube=normat(1:213,135:200,:);
neighbourhoodSAM;
