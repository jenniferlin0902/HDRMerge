function downsampled = downsample2(img, k)
%% Downsample a bayer layer to grayscale by avg over kxk box 
    fun = @(block_struct) mean(block_struct.data(:));
    downsampled = blockproc (img, [k k], fun); 
    % some magic trick that does avg pooling 
end