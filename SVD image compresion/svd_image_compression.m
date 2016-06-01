% Read the picture of the img, and convert to black and white.
img_gray = rgb2gray(imread('White-browed bush robin.jpg'));
% Downsample, just to avoid dealing with high-res images.
img_gray = im2double(img_gray);

% Compute SVD of this img
[U, S, V] = svd(img_gray);
% Plot the magnitude of the singular values (log scale)
sigmas = diag(S);
figure; plot(log10(sigmas)); title('Singular Values (Log10 Scale)');
figure; plot(cumsum(sigmas) / sum(sigmas)); title('Cumulative Percent of Total Sigmas');

% Show full-rank img
figure; subplot(4, 2, 1), imshow(img_gray), title('Full-Rank img');

% Compute low-rank approximations of the img, and show them
ranks = [200, 100, 50, 30, 20, 10, 3];
for i = 1:length(ranks)
    % Keep largest singular values, and nullify others.
    approx_sigmas = sigmas; approx_sigmas(ranks(i):end) = 0;
    % Form the singular value matrix, padded as necessary
    ns = length(sigmas);
    approx_S = S; approx_S(1:ns, 1:ns) = diag(approx_sigmas);
    % Compute low-rank approximation by multiplying out component matrices.
    approx_img = U * approx_S * V';
    % Plot approximation
    subplot(4, 2, i + 1), imshow(approx_img), title(sprintf('Rank %d img', ranks(i)));
end