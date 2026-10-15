mainFolder='.\data\Hyperspectral Data\sugarcane\SRA Invisible Pink 12 Feb\';
whiteimg='.\data\Hyperspectral Data\sugarcane\SRA Invisible Pink extra\whitereference-2\processed\whiterefrence.mat';
load(whiteimg);
[avgboardSpec] = findBrightestPixelsFun(finalMat);
spmat1=repmat(avgboardSpec',size(finalMat,1),size(finalMat,2));
spmat2=reshape(spmat1,[size(finalMat,3) size(finalMat,2) size(finalMat,1)]);
spmat3=permute(spmat2,[3,2,1]);
%spmat3(30,33,:);
%dirFolder=[mainFolder,'*.hdr'];
%D = dir(dirFolder); % A is a struct ... first elements are '.' and '..' used for navigation.
D = dir(mainFolder); % A is a struct ... first elements are '.' and '..' used for navigation.

for i = 3:length(D) % print folders and k values
 %k   
 subdirName=D(i).name;  %Get the current subdirectory name
 subdirPath=[mainFolder subdirName '\processed\'];
 dirFolder=[subdirPath,'*.hdr'];
 D2=dir(dirFolder);
  %[  finalMat, bandName ]=saveCubeEnvi_SnapScan([subdirPath , D(1).name],'' );
  [  finalMat, bandName,savefilename ] = saveCube_pinkCam( [subdirPath , D2(1).name],'',false );
  finalMat=finalMat./spmat3;
   save(savefilename,'finalMat','bandName','-v7.3');
 %  imwrite(finalMat(:,:,30),[mainFolder , D(i).name , '_30band.png']);
 %%%%Save images
    for b = 1:length(bandName)
        slice = finalMat(:,:,b);
        %slice = imadjust(slice);   
        wl = bandName(b);
        imgname=[D2(1).name '_'  num2str(wl) '.png'];
        %imgname
        imgdir=[mainFolder , D(i).name,'_hyperimages']; 
        if (~(exist(imgdir,'dir')==7))
            mkdir(imgdir);
        end
        imwrite(slice,[imgdir , '\' , imgname]);    
        disp(b);

     end

  disp([num2str(i) '. ' D(i).name]);
end


%% Renormalise using board
% whiteimg='.\data\Hyperspectral Data\sugarcane\SRA Invisible Pink 12 Feb\whitereference-2\processed\whiterefrence.mat';
% load(whiteimg);
% [avgboardSpec] = findBrightestPixelsFun(finalMat);
% spmat1=repmat(avgboardSpec',size(finalMat,1),size(finalMat,2));
% spmat2=reshape(spmat1,[size(finalMat,3) size(finalMat,2) size(finalMat,1)]);
% spmat3=permute(spmat2,[3,2,1]);
% spmat3(30,33,:);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mainFolder='.\data\Hyperspectral Data\sugarcane\SRA Invisible Pink 12 Feb\';
% D = dir(mainFolder); % A is a struct ... first elements are '.' and '..' used for navigation.
% 
% for i = 3:length(D) % print folders and k values
%  %k   
%  subdirName=D(i).name;  %Get the current subdirectory name
%  subdirPath=[mainFolder subdirName '\processed\'];
%  dirFolder=[subdirPath,'*.mat'];
%  D2=dir(dirFolder);
%  load([subdirPath , D2(1).name]);
%  finalMat=finalMat./spmat3;
%   %[  finalMat, bandName ] = saveCube_pinkCam( [subdirPath , D2(1).name],'',true );
%    save([subdirPath , D2(1).name],'finalMat','bandName','-v7.3');%already_saved_in_saveCubeEnvi_SnapScan(---)
%  %  imwrite(finalMat(:,:,30),[mainFolder , D(i).name , '_30band.png']);
% 
%   disp([num2str(i) '. ' D(i).name]);
% end