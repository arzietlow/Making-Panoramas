function H = calcHWithRANSAC(p1, p2)
% Returns the homography that maps p2 to p1 under RANSAC.
% Pre-conditions:
%     Both p1 and p2 are nx2 matrices where each row is a feature point.
%     p1(i, :) corresponds to p2(i, :) for i = 1, 2, ..., n
%     n >= 4
% Post-conditions:
%     Returns H, a 3 x 3 homography matrix

    assert(all(size(p1) == size(p2)));  % input matrices are of equal size
    assert(size(p1, 2) == 2);  % input matrices each have two columns
    assert(size(p1, 1) >= 4);  % input matrices each have at least 4 rows

    %------------- YOUR CODE STARTS HERE -----------------
    % 
    % The following code computes a homography matrix using all feature points
    % of p1 and p2. Modify it to compute a homography matrix using the inliers
    % of p1 and p2 as determined by RANSAC.
    %
    % Your implementation should use the helper function calcH in two
    % places - 
    % 1) finding the homography between four point-pairs within
    % the RANSAC loop, 
    % 2) finding the homography between the inliers
    % after the RANSAC loop.

    numIter = 100;
    maxDist = 3;
    [n,~] = size(p1);
    
    mostMatches = 0;
    pairs = 0;
    
    for p = 1:numIter
        
        inds = randperm(n, 4); % inds is a vector of 4 random unique integers in [1, n]
        newP1 = p1(inds, 1:2);
        newP2 = p2(inds, 1:2);
        H = calcH(newP1, newP2);     
        matches = 0;
        
        for j = 1:n
 
            point1 = p1(j, 1:2);
            point2 = p2(j, 1:2);
            point2(1, 3) = 1;
            Qi = H * transpose(point2); % Qi and point2 are 1 x 3 matrices and H is a 3 x 3 matrix
            Qi = Qi / Qi(3, 1);
            Qi = transpose(Qi(1:2));
            dist(j) = sqrt(sum((Qi - point1).^2)); % A and B are n x 3 matrices and dist is a 1 x n matrix
            
        end
        
        matches = sum(dist < maxDist);
        if (matches > mostMatches) 
            for t = 1:size(dist, 2);
                if dist(t) < maxDist
                    pairs(t) = t;
                end
            end
            inliers = pairs(pairs ~= 0);
            mostMatches = matches;
        end
        
        
    end
    bestP1 = p1(transpose(inliers), 1:2);
    bestP2 = p2(transpose(inliers), 1:2);
    H = calcH(bestP1, bestP2);
    

    %------------- YOUR CODE ENDS HERE -----------------
end

% The following function has been implemented for you.
% DO NOT MODIFY THE FOLLOWING FUNCTION
function H = calcH(p1, p2)
% Returns the homography that maps p2 to p1 in the least squares sense
% Pre-conditions:
%     Both p1 and p2 are nx2 matrices where each row is a feature point.
%     p1(i, :) corresponds to p2(i, :) for i = 1, 2, ..., n
%     n >= 4
% Post-conditions:
%     Returns H, a 3 x 3 homography matrix
    
    assert(all(size(p1) == size(p2)));
    assert(size(p1, 2) == 2);
    
    n = size(p1, 1);
    if n < 4
        error('Not enough points');
    end
    H = zeros(3, 3);  % Homography matrix to be returned

    A = zeros(n*3,9);
    b = zeros(n*3,1);
    for i=1:n
        A(3*(i-1)+1,1:3) = [p2(i,:),1];
        A(3*(i-1)+2,4:6) = [p2(i,:),1];
        A(3*(i-1)+3,7:9) = [p2(i,:),1];
        b(3*(i-1)+1:3*(i-1)+3) = [p1(i,:),1];
    end
    x = (A\b)';
    H = [x(1:3); x(4:6); x(7:9)];

end
