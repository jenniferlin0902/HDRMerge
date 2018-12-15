clear all;
n_frame = 5;
img_path = 'test_imgs/lowlight/warren_';
% % load all imgs 
for n = 1:n_frame
    rawFileName = char(strcat(img_path, string(n), '.jpg'))
    raw = imread(rawFileName);
    raw_size = size(raw);
    pad_size = ceil(raw_size(1:2)/64) * 64 - raw_size(1:2);
    assert(mod(pad_size(1)/2,2) == 0);
    assert(mod(pad_size(2)/2,2) == 0);
    raw = padarray(raw, pad_size/2);
    % pad to multiple of 64
    raws(n,:,:,:) = raw; % n_frame, x, y, 3
end

% 
% % align and merge each channel 
% for i = 1:3
%     A(:,:,:,i) = alignAll(raws(:,:,:,i), 1);
%     for n = 1:n_frame
%         filename = char(strcat(img_path, string(n),string(i), '_aligned_5frame.jpg'))
%         I = mat2gray(A(n,:,:,i),[0, 256]);
%         imshow(squeeze(I));
%         imwrite(squeeze(I),filename);
%     end
% end

%save('warren_aligned_jpg.mat', 'A');
load('warren_aligned_jpg.mat', 'A');
%A = raws;
for i = 1:3
    M(:,:,i) = mergeAll(A(:,:,:,i), 1, 1);
end
% imshow(M/256);
% imwrite(M/256, 'warren_5frame_align_merged.jpg');
imshow(M);

   


