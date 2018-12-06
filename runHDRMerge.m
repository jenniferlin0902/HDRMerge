%% HDR+ Burst Photography Pipeleline 

%% configs 
n_frames = 2;

%% load data
% data names 
imageId = '0006_20160727_185921_651';
burstPath = 'data/20171106_subset/bursts/';

% first load first frame to get meta data 
frameName = 'N000';
rawFileName = strcat(burstPath, imageId,'/payload_', frameName, '_uncompressed.dng')
[raw, raw_info, tiff_info] = loadDng(rawFileName);

% make sure img size is multiple of 64
raw_size = size(raw);
pad_size = ceil(raw_size/64)*64 - raw_size;
assert(mod(pad_size(1)/2,2) == 0);
assert(mod(pad_size(2)/2,2) == 0);
raw = padarray(raw, pad_size/2);

% store all data in raws (n_frames, w, h)
raws = zeros([n_frames,size(raw)]);
raws(1, :, :) = raw;

% read all frames 
for i = 2:n_frames
    frameName = strcat('N00', string(i-1))
    rawFileName = strcat(burstPath, imageId,'/payload_', frameName, '_uncompressed.dng')
    [raw, a, b] = loadDng(char(rawFileName));
    raw = padarray(raw, pad_size/2);
     raws(i, :, :) = raw;
end

%% Pick reference frame
% always pick the first frame for now
ref_frame = 1;
% crop img 
%raws = raws(:,1:1024,1:512);
img_size = size(squeeze(raws(1,:,:)));

%% Align
A = alignAll(raws, 1); %[n_frame-1,x,y]

% cropped out padding
A = A(:, pad_size(1):end-pad_size(1),pad_size(2):end-pad_size(2));
%% Merge 
M = mergeAll(A, 1);

%% Post Processing 
% step 1: Black Level subtraction 
%M = squeeze(raws(1,:,:));  % comment this out after we have align and merge 
black_level = reshape(tiff_info.BlackLevel, [2,2]);
white_level = tiff_info.WhiteLevel;
B = repmat(black_level, img_size(1)/2, img_size(2)/2);
W = 65535./(white_level - B);
raw_bs = (M - B).*W;
%imshow(raw_bs./(65535/256))

% step 2: Lens shading correction 
% get lens shading 
lensfileName = char(strcat(burstPath, imageId,'/lens_shading_map_', frameName, '.tiff'));
info = imfinfo(lensfileName);
lensData = importdata(lensfileName);
corrected = lensShading(raw_bs, lensData);
%imshow(corrected)

% step3: White Balancing 
% scales each channel by the white_coeff found in TIFF tag
white_coeff = raw_info.AsShotNeutral; 
white_coeff = [white_coeff(1), white_coeff(2), white_coeff(2), white_coeff(3)];
white_coeff = reshape(white_coeff, [2,2]);
WB = repmat(white_coeff, img_size(1)/2, img_size(2)/2);
corrected = corrected./ WB;

% step4: Demosaic 
options.filter='rggb';
img=demosaic(uint16(corrected),options.filter);

% step5: convert to sRGB space 
srgbfileName = strcat(burstPath, imageId,'/rgb2rgb.txt');
srgb_matrix = reshape(importdata(srgbfileName), [3,3]);
img_dim = size(img); % save img dim to reshape back 
flat_img = double(reshape(img, [], 3));
srgb_flat_img = flat_img * srgb_matrix;
srgb_img = uint16(reshape(srgb_flat_img, [img_dim(1), img_dim(2), 3]));
imshow(srgb_img)
size(srgb_img)


%% Done
