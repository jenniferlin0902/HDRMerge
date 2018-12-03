function A_all = alignAll(raws, ref)
    % This is just for testing. Should organize this into a 
    % alignment pyramid 
    n_frame = size(raws,1);
    x_size = size(raws,2)
    y_size = size(raws,3)
    ref_frame = squeeze(raws(ref,:,:));
    search_radius = 2;
    tile_size = 4;
    A_all = zeros(n_frame, x_size, y_size);
    for n = 1:n_frame
        if n ~= ref_frame
            [A, A_tile] = L1Align(ref_frame, squeeze(raws(n,:,:)), tile_size, 0, search_radius);
            size(A)
            A_all(n,:,:) = A;
        else
            A_all(n,:,:) = ref_frame;
        end
    end    
end