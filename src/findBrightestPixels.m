%whiteimg='.\data\Hyperspectral Data\sugarcane\SRA Invisible Pink 12 Feb\whitereference-2\processed\whiterefrence.mat';
%load(whiteimg);

% prgb(:,:,1)=finalMat(:,:,1);
% prgb(:,:,2)=finalMat(:,:,7);
% prgb(:,:,3)=finalMat(:,:,14);
b14=finalMat(:,:,14);
%figure,imshow(b14);

avgpx=sum(finalMat,3)./size(finalMat,3);
avgpx2=avgpx;
%figure,imshow(avgpx);


[mval,mi]=sort(avgpx(:),'descend');
avgpx(mi(1:60))=0;
figure,imshow(avgpx);

%Remove any pixel which are further
samInd=mi(1:60);
[r,c] = ind2sub(size(avgpx),samInd);
%avgpx2(sub2ind(size(avgpx),r,c))=0;
%figure,imshow(avgpx2); %testing

Dist=pdist2([r,c],[r,c]);
avgdis=sum(Dist,2)./length(r);

pixdis=20;
r(avgdis>pixdis)=[];
c(avgdis>pixdis)=[];
avgpx2(sub2ind(size(avgpx),r,c))=0;
figure,imshow(avgpx2);

%%%%%%%%
ind=sub2ind(size(avgpx),r,c);
bval=zeros(length(r),size(finalMat,3));
for i=1:size(finalMat,3)
bi=finalMat(:,:,i);
bval(:,i)=bi(ind);
end
avgBightpx=sum(bval)./size(finalMat,3);


