
[x,map] = imread('test_imgs/set2/ref.bmp'); 
[y,map] = imread('test_imgs/set2/x_shift_0_y_shift_5.bmp');
imshow(x,map)
imshow(y,map)
x = imresize(x, 4); 
y = imresize(y, 4);
imshow(x,map)
imshow(y,map)
raws = zeros(2, 1024, 1024);
raws(1, :, :) = x; 
raws(2, :, :) = y; 
raws = double(raws); 


A = alignAll(raws, 1); %[n_frame-1,x,y]
imshow(squeeze(A(1,:,:)))
imshow(squeeze(A(2,:,:)))

% 
%% Merge
M = mergeAll(A, 1);

imshow(M); 

imwrite(M, 'with_align.png'); 