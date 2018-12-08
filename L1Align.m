function A_tile = L1Align(ref, alt, prev_align, tilesize, r)
    % L1Align align frame to ref frame 
    % args
    %   ref     -- reference frame [x_size, y_size]
    %   frame   -- frame to align to ref [x_size, y_size]
    %   tilesize 
    %   prev_alignment -- not used for now 
    %   r       -- search radius. This will align tiles in frame with +- r
    %              offsets
    % returns
    %   A       -- aligned frame [x_size, y_size]
    %   A_tile  -- aligned index for each tiel [2, x_size/tilesize,
    %                                                      y_size/tilesize]
    ref = squeeze(ref);
    alt = squeeze(alt);
    % create grid that contain all possible displacement 
    i = -r : r;
    [I,I] = meshgrid(i,i);
    grid=cat(2,I',I);
    alignments = reshape(grid,[],2); % possible alignment indices
    
    % pad raw and alt so that each dimension is multiple of tile_size 
    t_pad_size = ceil(size(ref)/tilesize)*tilesize - size(ref);
    ref = padarray(ref, t_pad_size, 0, 'post');
    alt = padarray(alt, t_pad_size, 0, 'post');
    [x_size, y_size] = size(ref);
    
    % mirror pad alt
    abs_disp = abs(prev_align);
    pad_size = max(r, max(abs_disp(:)))+4;
    alt_pad = padarray(alt,[pad_size,pad_size], 'symmetric');
        
    % apply each displacement to pixel
    n_alignment = size(alignments,1);
    A_tile = ones(x_size/tilesize, y_size/tilesize,2); % alignment per tile
    % loop through tiles 
    for u = 1:x_size/tilesize
        for v = 1:y_size/tilesize
            % loop through each alignment scenario
            D = zeros(n_alignment,1);
            aligned_tiles = zeros(tilesize, tilesize, n_alignment);
            
            % tile index range
            x1 = (u-1)*tilesize+1;
            x2 = u*tilesize;
            y1 = (v-1)*tilesize+1;
            y2 = v*tilesize;
            % assume every pixel in the same tile has the same prev
            % alignment
            prev_tile_align = prev_align(x1,y1,:);
            for idx = 1:n_alignment
                a = alignments(idx,:);
                ax = a(1);
                ay = a(2);
                tile_pixels_ref = ref(x1:x2, y1:y2);
                tile_pixels_frame = alt_pad(x1+ax+pad_size+prev_tile_align(1):x2+ax+pad_size+prev_tile_align(1), y1+ay+pad_size+prev_tile_align(2):y2+ay+pad_size+prev_tile_align(2));
                aligned_tiles(:,:,idx) = tile_pixels_frame;
                % calculate distance between two tiles 
                D(idx) = distL1(tile_pixels_ref, tile_pixels_frame);  
            end
            % find best alignment for this tile
            [d,opt_align] = min(D);
            A_tile(u,v,:) = alignments(opt_align,:) + squeeze(prev_tile_align).';
            % A(x1:x2,y1:y2) = aligned_tiles(:,:,opt_align);
        end
    end
end

% calculate the L1 distance between two frame
function d = distL1(A, B)
    d = sum(sum(abs(A-B)));
end