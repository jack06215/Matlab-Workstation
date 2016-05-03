function c = simocost_HR(x,orthoX,L,K,A,talk)

%% Computes the cost function of H on line normal vectors
% x 3X3 represents a guesstimate RECTIFYING parameter that rotate about Z-axis
% orthoX 3X3 represents a known RECTIFYING parameters  that rotate about X-axis and Y-axis
% L is 3Xn matrix, containing n lines, the first 2 elements must make a unit norm normal vector
% A is the (symmetric) adjacency matrix for planes
% talk tells the function to print out intermediate results

% Obtain row and col index of the inliers
[ar, ac] = find(A>0);

% Obtain rotation parameter for each axis
ax = orthoX(1);
ay = orthoX(2);
az = x;

% Construct the homography based on the rotation parameters
R1 = makehgtform('xrotate',ax,'yrotate',ay); R1 = R1(1:3,1:3);
R2 = makehgtform('zrotate', az); R2 = R2(1:3,1:3);
Hinv = K * R1' * R2' * inv(K);

% Setup Vi and Vj
Lp = Hinv'*L;
Vp = Lp(1:2,:);
Vp=Vp./repmat(sqrt(sum(Vp.^2)),2,1);

% Pre-defind horizontal and vertical Vi and Vj
horzVector = [1,0];
vertVector = [0,1];

% Initialise cost matrix
C = zeros(size(A,1));
% Calculate the cost for each combination of inliers line-pairs
for i=1:size(ar,1)
    horzangle_L = dot(horzVector, abs(Vp(:,ar(i))));
    vertangle_L = dot(vertVector, abs(Vp(:,ar(i))));
    if(horzangle_L < vertangle_L)
%         disp('ar is probably aligned with Horizontal');
        inplane_cost = (horzVector * Vp(:,ar(i)))^2 + (vertVector * Vp(:,ac(i)))^2;
    else
%         disp('ar is probably aligned with Vertical');
        inplane_cost = (vertVector * Vp(:,ar(i)))^2 + (horzVector * Vp(:,ac(i)))^2;
    end
    C(ar(i), ac(i)) = inplane_cost;
end
c = sum(sum(C));