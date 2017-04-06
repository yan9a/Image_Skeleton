%--------------------------------------------------------------------------
%Matlab program for two step thinning
%File: TSTeg.m
%WebSite: http://cool-emerald.blogspot.sg/
%License: Creative Commons Attribution-ShareAlike 3.0
%http://creativecommons.org/licenses/by-sa/3.0/
%Programmer: Yan Naing Aye
%Date: 07 Mar 2012
%--------------------------------------------------------------------------
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
i3=im2double(i2); % i2 = original image before thinning
[H,W]=size(i3); % height, width of image
IForTest=i3; % IForTest = image to test
IChanged=i3; % IChanged = Changed image in thinning process
N=0; % N = number of non-zero neighbors
T=0; % T = 0-1 patterns
ChangeCount=1; % number of pixels changed over iteration
P=zeros(8); % array to hold the 8-neighborhood values
%--------------------------------------------------------------------------
% OUTER LOOP - LOOP UNTIL NO PIXELS CHANGE
while (ChangeCount ~= 0)
    % reset #of changes
    ChangeCount =0;
    % FIRST SUB-ITERATION
    for r=2:H-1 % row
        for c=2:W-1 % column
            if(IForTest(r,c)==1)
                % find 8 neighborhood of pixel
                P(9) = IForTest(r-1,c-1); P(2) = IForTest(r-1,c); P(3) = IForTest(r-1,c+1);
                P(8) = IForTest(r,c-1); P(4) = IForTest(r,c+1);
                P(7) = IForTest(r+1,c-1); P(6) = IForTest(r+1,c); P(5) = IForTest(r+1,c+1);
                % calculate N
                N = P(2)+P(3)+P(4)+P(5)+P(6)+P(7)+P(8)+P(9);
                % COMPUTE T
                T=0;
                for i=2:8
                    if ( P(i)< P(i+1) )T=T+1; end % test whether P(i)=0 and P(i+1)=1
                end
                if ( P(9)<P(2) )T=T+1; end
                % DECIDE IF PIXEL SHOULD BE DELETED
                if( (N>=2) & (N<=6) & (T==1) & ((P(6)==0) | (P(4)==0) | (P(2)==0 & P(8)==0) ) )
                    IChanged(r,c)=0;
                    ChangeCount=ChangeCount+1;
                end
            end
        end
    end
    % SECOND SUB-ITERATION
    IForTest=IChanged;
    for r=2:H-1 % row
    for c=2:W-1 % column
    if(IForTest(r,c)==1)
    % find 8 neighborhood of pixel
    P(9) = IForTest(r-1,c-1); P(2) = IForTest(r-1,c); P(3) = IForTest(r-1,c+1);
    P(8) = IForTest(r,c-1); P(4) = IForTest(r,c+1);
    P(7) = IForTest(r+1,c-1); P(6) = IForTest(r+1,c); P(5) = IForTest(r+1,c+1);
    % calculate N
    N = P(2)+P(3)+P(4)+P(5)+P(6)+P(7)+P(8)+P(9);
    % COMPUTE T
    T=0;
    for i=2:8
    if ( P(i)< P(i+1) )T=T+1; end
    end
    if ( P(9)<P(2) )T=T+1; end
    % DECIDE IF PIXEL SHOULD BE DELETED
    if( (N>=2) & (N<=6) & (T==1) & ((P(2)==0) | (P(8)==0) | (P(4)==0 & P(6)==0) ) )
    IChanged(r,c)=0;
    ChangeCount=ChangeCount+1;
    end
    end
    end
    end
    ChangeCount % output # of changes this iteration
    % swap IForTest with IChanged
    IForTest=IChanged;
end % end outer loop
%display thinned image
figure(4)
imshow(IForTest); title('Resulting image after thinning')
% display reinverted image
IForTest=~IForTest;
figure(5)
imshow(IForTest);title('Result of two step thinning')