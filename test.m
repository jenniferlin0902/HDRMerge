clear all; 

x = imread('.\test_imgs\set2\ref.bmp'); 
y = imread('.\test_imgs\set2\x_shift_0_y_shift_5.bmp');  

% x = imresize(x, 4); 
% y = imresize(y, 4);
raws(1, :, :) = x; 
raws(2, :, :) = y; 
raws = double(raws); 

A = alignAll(raws, 1); %[n_frame-1,x,y]

imshow(A(1, :, :)); 
figure 
imshow(A(2, :, :)); 
% 
%% Merge
M = mergeAll(raws, 1);

imshow(M); 
imwrite(M, 'with_align.png'); 