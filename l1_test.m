%% L1Align test 
test_ref = reshape(1:16,[4,4])'
test_src = test_ref;
test_src(1,1) = 10;
test_src(2,1) = 10;
test_src(1,2) = 1;
test_src(2,2) = 2

%% Test case 1:
%  -- ref frame 
% 1 , 2, 3, 4
% 5 , 6, 7, 8
% 9 ,10,11,12
% 13,14,15,16
% -- frame to align 
% 10, 1, 3, 4
% 10, 2, 7, 8
% 9 ,10,11,0
% 13,14,15,0
[A, A_tile] = L1Align(test_ref, test_src, 2, 0, 1) 

