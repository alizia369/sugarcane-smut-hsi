mainFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\machineLearning\indoor\';
%mainFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\machineLearning\outdoor\';


D = dir(mainFolder); % A is a struct ... first elements are '.' and '..' used for navigation.
D=D([D.isdir]);%only directories, current and parent directories included
%D
allPatches=[];% All patches of a particular label
allPCol=[];% All patches in column form of a particular label
traningPatches=[];
trainingPCol=[];
trainingLab=[];
trainingLinLab=[];

testingPatches=[];
testingPCol=[];
testingLab=[];
testingLinLab=[];

validationPatches=[];
validationPCol=[];
validationLab=[];
validationLinLab=[];

%windowsize=[19 19];
windowsize=[17 17];
stride=11;
for i = 3:length(D) % print folders and k values
 %k   
 subdirName=D(i).name;  %Get the current subdirectory name
 subdirPath=[mainFolder, subdirName, '\'];
 dirFolder=[subdirPath,'*.mat'];
 D2=dir(dirFolder);
 patchdir=[mainFolder , D(i).name,'\patches\']; 
 patchdir
    if (~(exist(patchdir,'dir')==7))
          mkdir(patchdir);
    end
    
    for j = 1:length(D2)
        filename=[subdirPath , D2(j).name];
        load(filename);
        [patches,imcol,I] = im2patches(normat,windowsize, stride);%[11 11], 5
        %size(patches)
        colind=all(imcol,1); % And operation for each col to get non-zero patches
        nonzeroind=find(colind~=0);
        nonzeroPatches=patches(:,:,:,nonzeroind);
%         disp('Number of Non Zero Patches= ');
%         disp(size(nonzeroPatches));
        nonzeroPatchesCol=imcol(:,nonzeroind);
        %size(nonzeroPatches)
        allPatches=cat(4,allPatches,nonzeroPatches);
        allPCol=cat(2,allPCol,nonzeroPatchesCol);
        
        disp(filename);

    end
     label=repelem(""+subdirName, size(allPCol,2));
     % Label mapping
     % 1->0 , 2->1 ,5->2, 6->3 , 7-> 4 , 8->5 ,9->6
     linLabel=repelem(i-3, size(allPCol,2));
     
     %save(savefilename,'finalMat','bandName','-v7.3');
     save([patchdir, subdirName,'_', int2str(windowsize(1)),'x',int2str(windowsize(2)),'_',int2str(stride), '_patches.mat'],'allPatches','allPCol','label');
     disp('Number of Non Zero Patches in one label= ');
     disp(size(allPatches));
     disp('Label size= ');
     disp(size(label));

     
     ind=(1:numel(label));
     ind2= randperm(numel(ind), ceil(numel(ind) * 0.60));
     trainind=ind(ind2);
     ind(ind2)=[];
     ind3=randperm(numel(ind), ceil(numel(ind) * 0.50));
     testind=ind(ind3);
     ind(ind3)=[];
     valind=ind;
    %%%%Training 
    trainPData=allPatches(:,:,:,trainind);
    trainPColData=allPCol(:,trainind);
    traningPatches=cat(4,traningPatches,trainPData);
    trainingPCol=cat(2,trainingPCol,trainPColData);
    trainingLab=cat(2,trainingLab,label(trainind));
    trainingLinLab=cat(2,trainingLinLab,linLabel(trainind));
    %%%%%Testing
    testPData=allPatches(:,:,:,testind);
    testPColData=allPCol(:,testind);
    testingPatches=cat(4,testingPatches,testPData);
    testingPCol=cat(2,testingPCol,testPColData);
    testingLab=cat(2,testingLab,label(testind));
    testingLinLab=cat(2,testingLinLab,linLabel(testind));
    %%%%%Validation
    valPData=allPatches(:,:,:,valind);
    valPColData=allPCol(:,valind);
    validationPatches=cat(4,validationPatches,valPData);
    validationPCol=cat(2,validationPCol,valPColData);
    validationLab=cat(2,validationLab,label(valind));
    validationLinLab=cat(2,validationLinLab,linLabel(valind));
     
     allPatches=[];% All patches of a particular label
     allPCol=[];% All patches in column form of a particular label

  disp([num2str(i) '. ' D(i).name]);
end
trainingLabInt=str2double(trainingLab);
testingLabInt=str2double(testingLab);
validationLabInt=str2double(validationLab);

save([mainFolder, 'training_', int2str(windowsize(1)),'x',int2str(windowsize(2)),'_',int2str(stride), '_patches.mat'],'traningPatches','trainingPCol','trainingLabInt','trainingLinLab');
save([mainFolder, 'testing_', int2str(windowsize(1)),'x',int2str(windowsize(2)),'_',int2str(stride), '_patches.mat'],'testingPatches','testingPCol','testingLabInt','testingLinLab');
save([mainFolder, 'validation_', int2str(windowsize(1)),'x',int2str(windowsize(2)),'_',int2str(stride), '_patches.mat'],'validationPatches','validationPCol','validationLabInt','validationLinLab');

