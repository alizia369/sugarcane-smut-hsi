
trainingDataFile=".\data\Hyperspectral Data\sugarcane\small infrared camera black\machineLearning\indoor\training_19x19_9_patches.mat";
validationDataFile=".\data\Hyperspectral Data\sugarcane\small infrared camera black\machineLearning\indoor\validation_19x19_9_patches.mat";
testDataFile=".\data\Hyperspectral Data\sugarcane\small infrared camera black\machineLearning\indoor\testing_19x19_9_patches.mat";

% trainingDataFile=".\data\Hyperspectral Data\sugarcane\small infrared camera black\machineLearning\outdoor\training_19x19_9_patches.mat";
% validationDataFile=".\data\Hyperspectral Data\sugarcane\small infrared camera black\machineLearning\outdoor\validation_19x19_9_patches.mat";
% testDataFile=".\data\Hyperspectral Data\sugarcane\small infrared camera black\machineLearning\outdoor\testing_19x19_9_patches.mat";

load(trainingDataFile);% load training data 
load(validationDataFile);% load validation data
load(testDataFile);% load test data

szpatches=size(traningPatches);
imageSize = [szpatches(1), szpatches(2), szpatches(3)]; %  Patch size example [19 19 11]
% Training data= traningPatches ; Training Label=trainingLabInt

%trainLabCatagorical=categorical(trainingLabInt'); % keeping original can be mapped later

%%
% Label mapping
% 1->0 , 2->1 ,5->2, 6->3 , 7-> 4 , 8->5 ,9->6

% trainingLinearLab=zeros(size(trainingLabInt))-1;
% 
% trainingLinearLab(trainingLabInt==1)=0;
% trainingLinearLab(trainingLabInt==2)=1;
% trainingLinearLab(trainingLabInt==5)=2;
% trainingLinearLab(trainingLabInt==6)=3;
% trainingLinearLab(trainingLabInt==7)=4;
% trainingLinearLab(trainingLabInt==8)=5;
% trainingLinearLab(trainingLabInt==9)=6;

%trainingLinearLab=linearLab(trainingLabInt);
%validationLinearLab=linearLab(validationLabInt);

trainingLinearLabCat=categorical(trainingLinLab');% convert it to categorial for classification
validationLinearLabCat=categorical(validationLinLab');% convert it to categorial for classification
testingLinearLabCat=categorical(testingLinLab');% convert it to categorial for classification
%%
%Create an imageDataAugmenter object that specifies preprocessing options for image augmentation, such as resizing, rotation, translation, and reflection. Randomly translate the images up to three pixels horizontally and vertically, and rotate the images with an angle up to 20 degrees.
imageAugmenter = imageDataAugmenter( ...
    'RandRotation',[-20,20], ...
    'RandXTranslation',[-3 3], ...
    'RandYTranslation',[-3 3]);

augimds = augmentedImageDatastore(imageSize,traningPatches,trainingLinearLabCat,'DataAugmentation',imageAugmenter);
%%
[lgraph] = resNet18Structure(imageSize);
miniBatchSize = 16;
learnRate = 0.01*miniBatchSize/128; %0.0003
valFrequency = floor(size(traningPatches,4)/miniBatchSize);
options = trainingOptions('sgdm', ...
    'InitialLearnRate',learnRate, ...
    'MaxEpochs',100, ...
    'MiniBatchSize',miniBatchSize, ...
    'VerboseFrequency',valFrequency, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress', ...
    'Verbose',false, ...
    'ValidationData',{validationPatches,validationLinearLabCat}, ...
    'ValidationFrequency',valFrequency, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.1, ...
    'LearnRateDropPeriod',60);
%%
trainedNet = trainNetwork(augimds,lgraph,options);

%%
disp("Validation Data results")
[YValPred,probs] = classify(trainedNet,validationPatches);
validationError = mean(YValPred ~= validationLinearLabCat);
YTrainPred = classify(trainedNet,traningPatches);
trainError = mean(YTrainPred ~= trainingLinearLabCat);
disp("Training error: " + trainError*100 + "%")

disp("Validation error: " + validationError*100 + "%")

accuracy = sum(YValPred == validationLinearLabCat)/numel(validationLinearLabCat);
disp("Validation Accuracy: " + accuracy*100 + "%")


%%
%Confussion matrix for validation data
figure('Units','normalized','Position',[0.2 0.2 0.4 0.4]);
cm = confusionchart(validationLinearLabCat,YValPred);
cm.Title = 'Confusion Matrix for Validation Data';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';

%%
disp("Testing Data results");

[YTestPred,tprobs] = classify(trainedNet,testingPatches);
testingError = mean(YTestPred ~= testingLinearLabCat);
YTrainPred2 = classify(trainedNet,traningPatches);
trainError = mean(YTrainPred2 ~= trainingLinearLabCat);
disp("Training error: " + trainError*100 + "%")

disp("Testing error: " + testingError*100 + "%")

taccuracy = sum(YTestPred == testingLinearLabCat)/numel(testingLinearLabCat);
disp("Testing Accuracy: " + taccuracy*100 + "%")



