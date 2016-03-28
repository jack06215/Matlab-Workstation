
function B = fitline(X)

% Normalise the w dimension (in terms of prespective coordinate system)
if size(X,1)==3
    X=X./repmat(X(3,:),3,1);
    X=X(1:2,:);
end

  [rows,npts] = size(X);    
  
  if rows ~=2
    error('data is not 2D');
  end
  
  if npts < 2
    error('too few points to fit line');
  end
  
  % Set up constraint equations of the form  AB = 0,
  % where B is a column vector of the line coefficients
  % in the form   b(1)*X + b(2)*Y + b(3) = 0.
  
  A = [X' ones(npts,1)]; % Build constraint matrix
  
  if npts == 2             % Pad A with zeros
    A = [A; zeros(1,3)]; 
  end

  [u d v] = svd(A);        % Singular value decomposition.
  B = v(:,3);              % Solution is last column of v.



  
       
       