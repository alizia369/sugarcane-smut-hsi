% readFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\indoorWithoutBackground\';%background removed
% resultFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\AnalysisandResult\indoor\';

readFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\outdoorWithoutBackground\';%background removed
resultFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\AnalysisandResult\ourdoor\';
% 
%mainFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\indoor\';
dirFolder=[readFolder,'*.mat'];
D = dir(dirFolder); % A is a struct ... first elements are '.' and '..' used for navigation.
 
for i = 1:length(D) % print folders and k values
 i   
 filename=[readFolder , D(i).name];
 load(filename);%notmat

%%% Mean curve
% sumval3=sum(normat,3);
% 
% ind=find(sumval3>0);
% 
% sumval12=sum(normat,[1 2]);
% meancurve=squeeze(sumval12)./length(ind);
%  
%  %%%%SAM
%  [samimg] = neighbourhoodSAMFun(normat);
%  samNorImg=normaliseMap( samimg );

samFilename=[resultFolder, D(i).name(1:end-4),'_sam.mat'];
load(samFilename);%samNorImg
samNorImg=abs( samNorImg );% remove comple double data type
bwsam=imbinarize(samNorImg,'adaptive','ForegroundPolarity','bright','Sensitivity',0.05);
%figure,imshow(bwsam);
sz=size(normat);
rsnormat=reshape(normat,[sz(1)*sz(2) , sz(3)]);
ind=find(bwsam==1);
selspec=rsnormat(ind,:);
mselspec=mean(selspec);

%save([resultFolder, D(i).name(1:end-4),'_sam.mat'],'samNorImg');


%%%% Save Results
 imgdir=[resultFolder , D(i).name,'_analysis\']; 
 if (~(exist(imgdir,'dir')==7))
            mkdir(imgdir);
 end
 
figure,
subplot(2,2,1);
imshow(normat(:,:,7));
subplot(2,2,2);
imagesc(samNorImg);
subplot(2,2,3);
imshow(bwsam);
subplot(2,2,4);
plot(bandName',mselspec,'b-o');

%saveas(gcf,[imgdir,'selSpec_meanCurve.png'])
F(i) = getframe(gcf) ;
 
imwrite(bwsam,[imgdir,D(i).name,'_bin.png']);
%imwrite( ind2rgb(im2uint8(samNorImg), parula(256)), [imgdir, D(i).name , '_imagesc_sam.png']);


  disp([num2str(i) '. ' D(i).name]);
end
%%
% create the video writer with 1 fps
  writerObj = VideoWriter([resultFolder , 'VideoResults.avi']);
  writerObj.FrameRate = 1;
  % set the seconds per image
% open the video writer
open(writerObj);
% write the frames to the video
for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;    
    writeVideo(writerObj, frame);
end
% close the writer object
close(writerObj);

%%
%%%%%%%%%%%Mean curve of single band
clear;
fname='.\data\Hyperspectral Data\sugarcane\small infrared camera black\indoorWithoutBackground\Q78-1.mat';
load(fname);
samFilename='.\data\Hyperspectral Data\sugarcane\small infrared camera black\AnalysisandResult\indoor\Q78-1_sam.mat'
load(samFilename);%samNorImg
samNorImg=abs( samNorImg );% remove comple double data type
bwsam=imbinarize(samNorImg,'adaptive','ForegroundPolarity','bright','Sensitivity',0.05);
%figure,imshow(bwsam);
sz=size(normat);
rsnormat=reshape(normat,[sz(1)*sz(2) , sz(3)]);
ind=find(bwsam==1);
selspec=rsnormat(ind,:);
mselspec=mean(selspec);

bName=bandName';

plot(bName,mselspec,'b-o');
text(bName(2),mselspec(2),['   ','(',num2str(round(bName(2))),',',num2str(mselspec(2)),')']);
text(bName(3),mselspec(3),['   ','(',num2str(round(bName(3))),',',num2str(mselspec(3)),')']);

text(bName(5),mselspec(5),['   ','(',num2str(round(bName(5))),',',num2str(mselspec(5)),')']);
text(bName(6),mselspec(6),['   ','(',num2str(round(bName(6))),',',num2str(mselspec(6)),')']);
saveas(gcf,'selSpec_meanCurve2.png');