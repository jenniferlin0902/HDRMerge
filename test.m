
x = imread('test_imgs/set2/ref.png'); 
y = imread('test_imgs/set2/x_shift_0_y_shift_5.png');
x = imresize(x, 4); 
y = imresize(y, 4);
imshow(x)
imshow(y)
x_grayscale = mean(x, 3);
y_grayscale = mean(y, 3);
size(x_grayscale)
raws = zeros(2, 1024, 1024);
raws(1, :, :) = x_grayscale; 
raws(2, :, :) = y_grayscale; 
raws = double(raws); 


A = alignAll(raws, 1); %[n_frame-1,x,y]
imshow(squeeze(A(1,:,:)))
imshow(squeeze(A(2,:,:)))

% 
%% Merge
M = mergeAll(raws, 1);

imshow(M); 

imwrite(M, 'with_align.png'); 