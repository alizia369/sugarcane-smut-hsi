% readFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\indoorWithoutBackground\';%background removed
% resultFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\AnalysisandResult\indoor\';

readFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\outdoorWithoutBackground\';%background removed
resultFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\AnalysisandResult\ourdoor\';

%mainFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\indoor\';
dirFolder=[readFolder,'*.mat'];
D = dir(dirFolder); % A is a struct ... first elements are '.' and '..' used for navigation.
 
for i = 1:length(D) % print folders and k values
 i   
 filename=[readFolder , D(i).name];
 load(filename);

%%% Mean curve
sumval3=sum(normat,3);

ind=find(sumval3>0);

sumval12=sum(normat,[1 2]);
meancurve=squeeze(sumval12)./length(ind);
 
 %%%%SAM
 [samimg] = neighbourhoodSAMFun(normat);
 samNorImg=normaliseMap( samimg );

save([resultFolder, D(i).name(1:end-4),'_sam.mat'],'samNorImg');


%%%% Save Results
 imgdir=[resultFolder , D(i).name,'_analysis\']; 
 if (~(exist(imgdir,'dir')==7))
            mkdir(imgdir);
 end
 
 figure,plot(bandName',meancurve,'b-o');
 saveas(gcf,[imgdir,'linechart.png'])
 
imwrite(samNorImg,[imgdir,D(i).name,'_sam.png']);
imwrite( ind2rgb(im2uint8(samNorImg), parula(256)), [imgdir, D(i).name , '_imagesc_sam.png']);


  disp([num2str(i) '. ' D(i).name]);
end

%%


%%%%%%%%%Mean curve of single band

% clear;
% fname='.\data\Hyperspectral Data\sugarcane\small infrared camera black\indoorWithoutBackground\Pindar-1.mat';
% load(fname);
% 
% %%% Mean curve
% sumval3=sum(normat,3);
% 
% ind=find(sumval3>0);
% 
% sumval12=sum(normat,[1 2]);
% meancurve=squeeze(sumval12)./length(ind);
% bName=bandName';
% figure,plot(bName,meancurve,'b-o');
% text(bName(2),meancurve(2),['   ','(',num2str(round(bName(2))),',',num2str(meancurve(2)),')']);
% text(bName(3),meancurve(3),['   ','(',num2str(round(bName(3))),',',num2str(meancurve(3)),')']);
% 
% text(bName(5),meancurve(5),['   ','(',num2str(round(bName(5))),',',num2str(meancurve(5)),')']);
% text(bName(6),meancurve(6),['   ','(',num2str(round(bName(6))),',',num2str(meancurve(6)),')']);




