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

vecpro=zeros([wr*wr 1]);

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
     
         
         sumWinI=sum(winI,2);
         pw=winI./sumWinI;
         
         for i=1:wr
            smX=sum(pw.*log(pw./pw(i,:)),2); %size(smX)=9x1
            smY=sum(pw(i,:).*log(pw(i,:)./pw),2);
            SID=smX+smY;%size(SID)=9x1
%             tempvals=winI.*winI(i,:);
            vecpro(((i-1)*wr)+1:wr*i)=SID;
         end
         
         tvals=vecpro;
            

        
        % win_idx(:,ones(wr,1))<=>repmat(win_idx,1,wr)
        row_idx(1+len:wr^2+len)=reshape(win_idx(:,ones(wr,1)),wr^2,1);
        
        % t(ones(wr,1),:)<=>repmat(win_idx',wr,1)
        t = win_idx';
        col_idx(1+len:wr^2+len)=reshape(t(ones(wr,1),:),wr^2,1);
        
        vals(1+len:wr^2+len)=tvals(:);
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
Lsid=sparse(row_idx,col_idx,vals,h*w,h*w);
sumL=sum(Lsid,2);
Lsid=spdiags(sumL(:),0,h*w,h*w)-Lsid;

if(~issymmetric(Lsid))% if not symmetric due to round off error do the following
Lsid = (Lsid+Lsid.')/2; % make sure matrix is semetric without any roundoff error
end

%% %%%%%%%%%Testing
testd=diag(Lsid);
testimg=reshape(testd,[h w]);
testimg=full(testimg);
figure,imshow(testimg,[]);
%% %%%%%%%%%%%%%%%%%Testing2
testd=diag(Lsid,-1);
testimg=reshape([testd ;0],[h w]);
testimg=full(testimg);
figure,imshow(testimg,[]);