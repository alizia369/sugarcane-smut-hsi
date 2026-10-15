labelsFolder='.\data\Hyperspectral Data\sugarcane\small infrared camera black\outdoor_labels\';
files = dir([labelsFolder,'*.png']);
% Loop through each file 
for i = 1:length(files)
    % Get the file name 
    kind = strfind(files(i).name, '_');
    fname=files(i).name(1:(kind(1)-1));
    %fname
    rename=[labelsFolder,fname,'.png'];
    %[~, f,ext] = fileparts(files(i).name);
    %rename = strcat(f,'_',ext) ; 
    rename
    movefile([labelsFolder,files(i).name], rename); 
end