layer=2;

w1=net.Layers(layer).Weights;

w2=mat2gray(w1);
w3=imresize(w2,5);

figure,
montage(w3(:,:,1,1:8),'size',[2 4]);