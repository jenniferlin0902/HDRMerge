function A_all = alignAll(raws, ref)
    % constants
    ds_factors = [2,4,4];
    search_radius = [1, 4, 4, 4];
    tile_sizes = [4, 4, 4, 2];
    n_frames = size(raws, 1);
    
    %% downsample imgs 
    ds1 = downsample(raws, 2); % bayer to grayscale
    ds2 = downsample(ds1, ds_factors(1));
    ds3 = downsample(ds2, ds_factors(2));
    ds4 = downsample(ds3, ds_factors(3));
   
    %% Align 
    A_all = zeros(size(raws));
    for i = 1:n_frames
        if i ~= ref
            no_align = zeros(size(ds4,2), size(ds4,3),2);
            % level 4:
            l4align = L2Align(ds4(ref,:,:), ds4(i,:,:), no_align, tile_sizes(4), search_radius(4)); 
            % map up l4align ds4_size/tile_size -> ds4_size * ds_factor(3)
            % and scale up by ds_factor
            l4align = repelem(l4align, tile_sizes(4) * ds_factors(3), tile_sizes(4) * ds_factors(3),1)*ds_factors(3);

            % level 3:
            l3align = L2Align(ds3(ref,:,:), ds3(i,:,:), l4align, tile_sizes(3), search_radius(3));
            % map up l3align 
            l3align = repelem(l3align, tile_sizes(3) * ds_factors(2), tile_sizes(3) * ds_factors(2),1)*ds_factors(2);

            % level 2:
            l2align = L2Align(ds2(ref,:,:), ds2(i,:,:), l3align, tile_sizes(2), search_radius(2));
            % map up l2align 
            l2align = repelem(l2align, tile_sizes(2) * ds_factors(1), tile_sizes(2) * ds_factors(1),1)*ds_factors(1);

            % level 1:
            l1align = L1Align(ds1(ref,:,:), ds1(i,:,:), l2align, tile_sizes(1), search_radius(1));
            % map up l2align 
            l1align = repelem(l1align, tile_sizes(1) * 2, tile_sizes(1) * 2,1)*2; % dim = x, y, 2
            
            % apply the final alignment to raws 
            A_all(i,:,:) = applyAlign(squeeze(raws(i,:,:)), l1align); 
        else
            A_all(i,:,:) = raws(ref, :, :);
        end
    end
end

%% Helpers
function aligned = applyAlign(img, align)
    aligned = zeros(size(img));
    abs_disp = abs(align);
    pad_size = max(abs_disp(:));
    img_pad = padarray(img,[pad_size,pad_size], 'symmetric');
    for i = 1:size(img,1)
        for j = 1:size(img,2)
            aligned(i,j) = img_pad(i+align(i,j,1)+pad_size, j+align(i,j,2)+pad_size);
        end
    end
end

function out = downsample(imgs, k)
    n_img = size(imgs,1);
    out = zeros(n_img, size(imgs,2)/k, size(imgs,3)/k);
    for i = 1:n_img
        out(i,:,:) = downsample2(squeeze(imgs(i,:,:)), k);
    end
end
