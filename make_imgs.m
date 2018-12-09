img_path = 'test_imgs/set3/ref.png';
I = imread(img_path);
x_range = 380:600; 
y_range = 850:1010; 

%% random shift
I_shift = circshift(I, [0 50]); 
% figure
% imshow(I_shift); 
imwrite(I_shift, '.\test_imgs\set3\shifted.png');

%% shift 1 down by 100 pixels
xshift = 100; 
yshift= 0; 
I_shift1 = I; 
I_shift1(x_range, y_range) = 255;
I_shift1(x_range + xshift, y_range + yshift) = I(x_range, y_range); 
imwrite(I_shift1, '.\test_imgs\set3\x_shift_100_y_shift_0.png'); 

%% shift 1 right by 100 pixels
xshift = 300; 
yshift= -100; 
I_shift1 = I; 
I_shift1(x_range, y_range) = 255;
I_shift1(x_range + xshift, y_range + yshift) = I(x_range, y_range); 
imwrite(I_shift1, '.\test_imgs\set3\x_shift_300_y_shift_-100.png'); 

%%
m = I(x_range, y_range); 
m(m == 0) = 100; 
m = imrotate(m, 15, 'crop'); 
m(m == 0) = 255; 
m(m == 100) = 0; 

xshift = 300; 
yshift= -100; 
I_shift1 = I; 
I_shift1(x_range, y_range) = 255;
I_shift1(x_range + xshift, y_range + yshift) = m; 
imwrite(I_shift1, '.\test_imgs\set3\shifted_and_rotated.png'); 

%% add noise
I_noise = double(I) + randn(size(I));
imwrite(I_noise, '.\test_imgs\set3\noise.png');

%% rotation 45 degrees
I_rotate = I;

I_rotate(x_range, y_range) = 255;
m = I(x_range, y_range); 
m(m == 0) = 100; 
m = imrotate(m, 45, 'crop'); 
m(m == 0) = 255; 
m(m == 100) = 0; 
I_rotate(x_range, y_range) = I_rotate(x_range, y_range) .* m; 
imwrite(I_rotate, '.\test_imgs\set3\rotate_45.png');

%% rotate 90 degrees

I_rotate(x_range, y_range) = 255;
m = I(x_range, y_range); 
m(m == 0) = 100; 
m = imrotate(m, 90, 'crop'); 
m(m == 0) = 255; 
m(m == 100) = 0; 
I_rotate(x_range, y_range) = I_rotate(x_range, y_range) .* m; 
imwrite(I_rotate, '.\test_imgs\set3\rotate_90.png');

%% rotation 135 degrees
I_rotate = I;

I_rotate(x_range, y_range) = 255;
m = I(x_range, y_range); 
m(m == 0) = 100; 
m = imrotate(m, 135, 'crop'); 
m(m == 0) = 255; 
m(m == 100) = 0; 
I_rotate(x_range, y_range) = I_rotate(x_range, y_range) .* m; 
imwrite(I_rotate, '.\test_imgs\set3\rotate_45.png');

