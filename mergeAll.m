function M = mergeAll(A, ref, robust)
    % Temporary
    if robust == 0
        M = squeeze(mean(A,1));
    else
        tilesize = 4;
        %% Try to merge with a simpler algorithm presented here
        %http://timothybrooks.com/tech/hdr-plus/
        n_frames = size(A, 1);
        ref = squeeze(A(1,:,:));
        % find distance between pixels 
        acc = ref;
        min_dist = 1;
        max_dist = 200;
        f = 8;
        x_size = size(ref,1);
        y_size = size(ref,2);
        total_weight = ones(size(ref));
        for n = 2:n_frames
            weight = zeros(size(ref));
            alt = squeeze(A(n,:,:));
            for i = 1:x_size/tilesize
                for j = 1:y_size/tilesize
                    x1 = (i-1)*tilesize+1;
                    x2 = i*tilesize;
                    y1 = (j-1)*tilesize+1;
                    y2 = j*tilesize;
                    dist = sum(sum(abs(ref(x1:x2, y1:y2) - alt(x1:x2,y1:y2))));
                    norm_dist = max(1, dist/4 - min_dist/4);
                    select_weight = norm_dist >= min_dist; % 
                    weight(x1:x2,y1:y2) = (select_weight*1/norm_dist)*ones(4);
                end
            end
            acc = double(acc) + double(alt).* weight;
            total_weight = total_weight + weight;
        end
        M = acc ./ total_weight;
    end
end