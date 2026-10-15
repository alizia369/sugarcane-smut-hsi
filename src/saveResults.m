%%%%%%Old File. Current is AnalysisandResults_...m
%%%Black camera
% mainFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\indoor\';
% dirFolder=[mainFolder,'*.mat'];
% D = dir(dirFolder); % A is a struct ... first elements are '.' and '..' used for navigation.
%  
% for i = 1:length(D) % print folders and k values
%  %k   
%  filename=[mainFolder , D(i).name];
%  load(filename);
%  [testimg] = neighbourhoodSAMFun(normat);
%  norimg=normaliseMap( testimg );
%  imwrite(norimg,[mainFolder ,'results\sam\' ,D(i).name , '_sam.png']);
%  imwrite( ind2rgb(im2uint8(norimg), parula(256)), [mainFolder ,'results\sam\' ,D(i).name , '_imagesc_sam.png']);
% 
%   disp([num2str(i) '. ' D(i).name]);
% end



%[testimg] = neighbourhoodSAMFun(normat)
%%
%%%%Pink camera
mainFolder='.\data\Hyperspectral Data\sugarcane\SRA Invisible Pink 12 Feb\';

D = dir(mainFolder); % A is a struct ... first elements are '.' and '..' used for navigation.

for i = 3:length(D) % print folders and k values
 %k   
 subdirName=D(i).name;  %Get the current subdirectory name
 subdirPath=[mainFolder subdirName '\processed\'];
 dirFolder=[subdirPath,'*.mat'];
 D2=dir(dirFolder);
 filename=[subdirPath , D2(1).name];
 %filename
 load(filename);
 [testimg] = neighbourhoodSAMFun(finalMat);
 norimg=normaliseMap( testimg );
 imwrite(norimg,[mainFolder ,'results\sam\' ,D(i).name , '_sam.png']);
 imwrite( ind2rgb(im2uint8(norimg), parula(256)), [mainFolder ,'results\sam\' ,D(i).name , '_imagesc_sam.png']); 

  disp([num2str(i) '. ' D(i).name]);
end