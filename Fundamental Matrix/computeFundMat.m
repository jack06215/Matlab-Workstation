function [ F ] = computeFundMat( m, m_prime, SVD_or_LS, num_of_points)
Un = [];
for i = 1:num_of_points
    Un = [Un; [m_prime(1, i) * m(1, i), m_prime(2, i) * m(1, i), m(1, i),...
              m_prime(1, i) * m(2, i), m_prime(2, i) * m(2, i), m(2, i),...
                 m_prime(1, i), m_prime(2, i), 1]];
end
if ~SVD_or_LS
    U_prime = Un;
    U_prime(:, end) = [];
    f = -inv(U_prime.'*U_prime)*U_prime.'*ones(20,1);
    f_8p = reshape([f;1], 3, 3);
    F = f_8p;
else
    [U, S, W] = svd(Un);
    f = W(:,end) / W(end, end);
    f_svd = reshape(f, 3, 3);
    F = f_svd;
end
end

