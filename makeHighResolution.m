function img = makeHighResolution(original_img)
[m, n] = size(original_img);

if m < 512
    ups_m = 512 / m;
else
    ups_m = m;
end

img = imresize(original_img, ups_m);

end