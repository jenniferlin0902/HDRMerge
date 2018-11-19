%% Lens Shading Correction 
function corrected = lensShading(raw, lens)
    % TODO vectorize this function. This is super slow rn
    lens_dim = size(lens);
    raw_dim = size(raw);
    
    scale_up = [raw_dim(1)/lens_dim(1), raw_dim(2)/lens_dim(2)];
    corrected = zeros(raw_dim);
    raw = double(raw);
    for i = 1:raw_dim(1)
        for j = 1:raw_dim(2)
            % select gain channel, i -> y, j -> x
            corrected(i,j) = lens(bound(i/scale_up(1), lens_dim(1)), ...
                    bound(j/scale_up(2), lens_dim(2))) *raw(i,j);
        end
    end
end

function index = bound(n, max)
    index = min(round(n)+1, max);
end