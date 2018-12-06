original_img = '.\test_imgs\original.png';

shifts = [0 0
    0 5
    5 0 
    5 5 
    10 10]; 

[m, ~] = size(shifts); 

for i = 1:m 
    img = shiftTestImg(original_img, [shifts(i, :)]);
    figure
    imshow(img)
    imwrite(img, ['.\test_imgs\x_shift_' num2str(shifts(i, 1)) '_yshift_' num2str(shifts(i, 2)) '.png']) 
end 

function img = shiftTestImg(filename, shifts)

img = imread(filename);
img = imresize(img, [256 256]); 
img = circshift(img, shifts); 
end 


