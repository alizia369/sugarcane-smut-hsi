function [LineraLab] = linearLab(nonLineraLab)
%LINEARLAB Summary of this function goes here
%   Detailed explanation goes here
% 1->0 , 2->1 ,5->2, 6->3 , 7-> 4 , 8->5 ,9->6

LineraLab=zeros(size(nonLineraLab))-1;

LineraLab(nonLineraLab==1)=0;
LineraLab(nonLineraLab==2)=1;
LineraLab(nonLineraLab==5)=2;
LineraLab(nonLineraLab==6)=3;
LineraLab(nonLineraLab==7)=4;
LineraLab(nonLineraLab==8)=5;
LineraLab(nonLineraLab==9)=6;


end

