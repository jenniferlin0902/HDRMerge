function img = addnoise(original_img)
    noise = randn(size(original_img)); 
    img = double(original_img) + noise; 
end 