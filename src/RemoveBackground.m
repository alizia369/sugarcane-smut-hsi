%%%% Remove Background using labels

%%%Black camera
% mainFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\indoor\';
% labelsFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\indoor_labels\';
% resultsFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\indoorWithoutBackground\';
mainFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\field-outdoor\';
labelsFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\outdoor_labels\';
resultsFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\outdoorWithoutBackground\';

dirFolder=[mainFolder,'*.mat'];
D = dir(dirFolder); % A is a struct ... first elements are '.' and '..' used for navigation.
 
for i = 1:length(D) % print folders and k values
 %k   
 filename=[mainFolder , D(i).name];
 load(filename);
 labelname=[labelsFolder , D(i).name(1:end-3),'png'];
 %labelname
 labelimg=imread(labelname);
 if ndims(label) >=2
    label=sum(labelimg,3)>0;
 else
    label=labelimg;
 end
 sz=size(normat);
 labelmat=repmat(label,1,1,sz(3));
 normat=normat.*double(labelmat);
 %[testimg] = neighbourhoodSAMFun(normat);
 %norimg=normaliseMap( testimg );
 %imwrite(norimg,[mainFolder ,'results\sam\' ,D(i).name , '_sam.png']);
 %imwrite( ind2rgb(im2uint8(norimg), parula(256)), [mainFolder ,'results\sam\' ,D(i).name , '_imagesc_sam.png']);
 savefilename= [resultsFolder , D(i).name];
 save(savefilename,'normat','bandName','-v7.3');
 %  imwrite(finalMat(:,:,30),[mainFolder , D(i).name , '_30band.png']);
 %%%%Save images
    for b = 1:length(bandName)
        slice = normat(:,:,b);
        %slice = imadjust(slice);   
        wl = bandName(b);
        imgname=[D(i).name '_'  num2str(wl) '.png'];
        %imgname
        imgdir=[resultsFolder , D(i).name,'_hyperimages']; 
        if (~(exist(imgdir,'dir')==7))
            mkdir(imgdir);
        end
        imwrite(slice,[imgdir , '\' , imgname]);    
        disp(b);

     end

  disp([num2str(i) '. ' D(i).name]);
end



%[testimg] = neighbourhoodSAMFun(normat)