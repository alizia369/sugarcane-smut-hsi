mainFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\field-outdoor\';
dirFolder=[mainFolder,'*.png'];
D = dir(dirFolder); % A is a struct ... first elements are '.' and '..' used for navigation.
 
for i = 1:length(D) % print folders and k values
 %k   
 %D(k).name  %Get the current subdirectory name
  %[  finalMat, bandName ]=saveCubeEnvi_SnapScan([mainFolder , D(i).name],'' );
   [  finalMat, bandName ]=saveCube_smallCam( [mainFolder , D(i).name],25,'',true);
   %save([mainFolder,D(i).name,'.mat'],'finalMat','bandName','-v7.3');%already_saved_in_saveCubeEnvi_SnapScan(---)
   %imwrite(finalMat(:,:,30),[mainFolder , D(i).name , '_30band.png']);

  disp([num2str(i) '. ' D(i).name]);
end