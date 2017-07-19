function [ im_blended ] = blend( im_input1, im_input2 )
%BLEND Blends two images together via feathering
% Pre-conditions:
%     `im_input1` and `im_input2` are both RGB images of the same size
%     and data type
% Post-conditions:
%     `im_blended` has the same size and data type as the input images
    
    assert(all(size(im_input1) == size(im_input2)));
    assert(size(im_input1, 3) == 3);

    im_blended = zeros(size(im_input1), 'like', im_input1);

    %------------- YOUR CODE STARTS HERE -----------------
    
    alpha1 = rgb2alpha(im_input1);
    alpha2 = rgb2alpha(im_input2);
    sum = alpha1 + alpha2;
    red1 = im_input1(:, :, 1);
    red2 = im_input2(:, :, 1);
    red = ((alpha1 .* red1) + (alpha2 .* red2)) ./ sum;
    green1 = im_input1(:, :, 2);
    green2 = im_input2(:, :, 2);
    green = ((alpha1 .* green1) + (alpha2 .* green2)) ./ sum;
    blue1 = im_input1(:, :, 3);
    blue2 = im_input2(:, :, 3);
    blue = ((alpha1 .* blue1) + (alpha2 .* blue2)) ./ sum;
    im_blended(:, :, 1) = red;
    im_blended(:, :, 2) = green;
    im_blended(:, :, 3) = blue;
    
    %------------- YOUR CODE ENDS HERE -----------------

end

function im_alpha = rgb2alpha(im_input, epsilon)
% Returns the alpha channel of an RGB image.
% Pre-conditions:
%     im_input is an RGB image.
% Post-conditions:
%     im_alpha has the same size as im_input. Its intensity is between
%     epsilon and 1, inclusive.

    if nargin < 2
        epsilon = 0.001;
    end
    
    %------------- YOUR CODE STARTS HERE -----------------
    d = im_input;
    d(d == 0) = 1;
    d(d ~= 1) = 0;
    d = im2bw(d);
    d = bwdist(d);
    d = im2double(d);  
    d = mat2gray(d);
    d(d == 0) = epsilon;
    
    im_alpha = d;
    
    %------------- YOUR CODE ENDS HERE -----------------

end
