function [testimg] = neighbourhoodSAMFun(normat)
%NEIGHBOURHOODSAMFUN Summary of this function goes here
%   Detailed explanation goes here
I=normat;

eps=0.0000001;
r=1;
 [h w c] = size(I);

wr = (2*r+1) * (2*r+1);
cc = zeros(h,w);
tlen=sum(sum(1-cc(r+1:end-r,r+1:end-r)))*(wr^2);
M_idx = reshape([1:h*w], h, w);
vals=zeros(tlen,1);
vals2=zeros(tlen,1);
len = 0;

vecpro=zeros([wr*wr c]);
%%%%%%%%%%%% norms %%%%%%%%%%%
normatrs=reshape(I,[h*w c]);
matnorms=sqrt(sum(normatrs.^2,2));

tic
for y=1+r:h-r
    for x=1+r:w-r
%         Sigma = [varI_rr(y, x), varI_rg(y, x), varI_rb(y, x);
%             varI_rg(y, x), varI_gg(y, x), varI_gb(y, x);
%             varI_rb(y, x), varI_gb(y, x), varI_bb(y, x)];
%         meanI = [meanI_r(y,x), meanI_g(y,x), meanI_b(y,x)];
     
%        Sigma = Sigma + eps * eye(3);
        win_idx = M_idx(y-r:y+r,x-r:x+r);
        win_idx=win_idx(:);
        
        winI=I(y-r:y+r,x-r:x+r,:);
        
        winI=reshape(winI,wr,c);
        
        
        ind=find(winI==0); %added later to remove extra calculation for background
        
%         if(length(ind)>(length(winI(:))/16))
        if(length(ind)< 3)
     %%%%%%%%% Calculating Spectral Angular Mapper for Similirity %%%%%%%%%%%%%%%%%%%%%%%%   
        
            for i=1:wr
                tempvals=winI.*winI(i,:);
                vecpro(((i-1)*wr)+1:wr*i,:)=tempvals;
            end
            %size(vecpro)
            sumVec=sum(vecpro,2);
            sumVecRs=reshape(sumVec(:),[wr wr]);
            %size(sumVecRs)

            curnorms=matnorms(win_idx);
            allcombnorms=curnorms*curnorms';
            %size(allcombnorms)

            divVec=sumVecRs./allcombnorms;

            %sad=round(acos(divVec),6); % Spectral Angular Distance for all Vectors for sad 0 is same and 1 is different.
            sad=acos(divVec);% Spectral Angular Distance for all Vectors for sad 0 is same and 1 is different.
        else
            sad=zeros([wr wr]);
        end
        
        %%%%%% Test %%%%%
        %sad=sad+diag(sum(sad,2)); %%%put sum instead of zeros in diagnoal 
        
%         similirity=1-sad; %similirity values filped 1 for same and 0 for different
        
        
        
        
        % repmat is too slow, replace repmat with indexing
        % meanI(ones(wr,1),:) <=> repmat(meanI,wr,1) 
        %winI=winI-meanI(ones(wr,1),:);
        
        %tvals=(1+winI*inv(Sigma)*winI')/wr;
        
        % win_idx(:,ones(wr,1))<=>repmat(win_idx,1,wr)
        row_idx(1+len:wr^2+len)=reshape(win_idx(:,ones(wr,1)),wr^2,1);
        
        % t(ones(wr,1),:)<=>repmat(win_idx',wr,1)
        t = win_idx';
        col_idx(1+len:wr^2+len)=reshape(t(ones(wr,1),:),wr^2,1);
        
        vals(1+len:wr^2+len)=sad(:);%tvals(:);
%         vals2(1+len:wr^2+len)=similirity(:);
        
        len=len+wr^2;
    end
end

toc
%%
vals=vals(1:len);
%%%%%%%%%%%%%%%%%%%%Normalise values %%%%%%%%
%vals=normaliseMap(vals);

row_idx=row_idx(1:len);
col_idx=col_idx(1:len);
Lsam=sparse(row_idx,col_idx,vals,h*w,h*w);
sumL=sum(Lsam,2);
Lsam=spdiags(sumL(:),0,h*w,h*w)-Lsam;

if(~issymmetric(Lsam))% if not symmetric due to round off error do the following
Lsam = (Lsam+Lsam.')/2; % make sure matrix is semetric without any roundoff error
end
%% %%% values 2
% vals2=vals2(1:len);
% row_idx=row_idx(1:len);
% col_idx=col_idx(1:len);
% Lflipsam=sparse(row_idx,col_idx,vals2,h*w,h*w);
% sumL2=sum(Lflipsam,2);
% Lflipsam=spdiags(sumL2(:),0,h*w,h*w)-Lflipsam;
% 
% if(~issymmetric(Lflipsam))% if not symmetric due to round off error do the following
% Lflipsam = (Lflipsam+Lflipsam.')/2; % make sure matrix is semetric without any roundoff error
% end


%% Testing

testd=diag(Lsam);
testimg=reshape(testd,[h w]);
testimg=full(testimg);
%figure,imshow(testimg,[]);
%%%%%%%%%%%%%%%%%%%
% testd2=diag(Lflipsam);
% testimg2=reshape(testd2,[h w]);
% testimg2=full(testimg2);
% figure,imshow(testimg2,[]);

% outputArg1 = testimg;
% outputArg2 = inputArg2;
end

