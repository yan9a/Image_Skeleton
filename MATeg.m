%--------------------------------------------------------------------------
%Medial Axis Transform
%File: MATeg.m
%WebSite: http://cool-emerald.blogspot.sg/
%License: Creative Commons Attribution-ShareAlike 3.0
%http://creativecommons.org/licenses/by-sa/3.0/
%Programmer: Yan Naing Aye
%Date: 07 Mar 2012
%--------------------------------------------------------------------------
%clear command windows
clc;
%clear workspace
clear all;
%close all windows
close all;
%--------------------------------------------------------------------------
%Get an image
[uFileName,uPathName] = uigetfile('*.jpg','Select an image');
[i1 m1]=imread(uFileName);
%--------------------------------------------------------------------------
%Show the image
figure(1);
imshow(i1);
title('Original image');
%--------------------------------------------------------------------------
%get the image global image threshold using Otsu's method
Threshold=graythresh(i1);
%--------------------------------------------------------------------------
%make it binary (black and white)
i2=im2bw(i1,Threshold);
% objects should be white=1 and background should be black=0
i2= ~i2;
figure(2);
imshow(i2); 
title('Binary image');
%--------------------------------------------------------------------------
%Morphological opening to remove noise
%Make structuring element
se=strel('disk',5);
%opening
i3=imopen(i2,se);
figure(3);
imshow(i3); 
title('Image aftering opening');
%--------------------------------------------------------------------------
%Perform distance transform
i4=bwdist(~i3);
figure(4);
imshow(i4,[]); 
title('Distance transform');
%--------------------------------------------------------------------------
%Perform medial axis transform
[h w]=size(i4);
i5=zeros(h,w);% to speed up
for i=2:h-2
    for j=2:w-2
        if((i4(i,j)>i4(i+1,j))&&(i4(i,j)>i4(i-1,j)))
            i5(i,j)=i4(i,j);
        elseif((i4(i,j)>i4(i,j+1))&&(i4(i,j)>i4(i,j-1)))
            i5(i,j)=i4(i,j);
        elseif((i4(i,j)>i4(i-1,j))&&(i4(i,j)==i4(i+1,j))&&(i4(i+1,j)>i4(i+2,j)))
            i5(i,j)=i4(i,j);
        elseif((i4(i,j)>i4(i,j-1))&&(i4(i,j)==i4(i,j+1))&&(i4(i,j+1)>i4(i,j+2)))
            i5(i,j)=i4(i,j);                   
        end
    end
end
figure(5);
imshow(i5,[]); 
title('MAT');
%--------------------------------------------------------------------------
%Make binary skeleton
i6=im2bw(i5,1);
figure(6);
imshow(i6,[]); 
title('Skeleton');
%--------------------------------------------------------------------------
