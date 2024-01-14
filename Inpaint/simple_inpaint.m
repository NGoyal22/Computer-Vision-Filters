% this program illustrates a way to solve Laplace equation by convolution with a
% Gaussian kernel along with imposing a Dirichlet boundary condition
% we can call this simple inpainting (interpolation)
clc;
close all;
clear all;

% read the original image
I = double(imread('cameraman.bmp'));
% read the damaged image
J = double(imread('damaged_cameraman.bmp'));
% show images
figure(1),subplot(1,2,1),imagesc(I),colormap(gray),axis image;
title('Original image');
figure(1),subplot(1,2,2),imagesc(J),colormap(gray),axis image;
title('Damaged image');
xlabel('Press a key to start inpainting.');
pause;
set(gcf,'doublebuffer','on');

% read the damage mask - 0 where image is damaged, 1 where image is fine
M = double(imread('damage_mask.bmp'));
% normalise M
M(:) = (M-min(M(:)))/(max(M(:))-min(M(:)));
M = logical(M);

[m n] = size(I);
rowC = [1:m];         rowN = [1 1:m-1];    rowS = [2:m m];
colC = [1:n];         colE = [1 1:n-1];    colW = [2:n n];

% start iterative inpainting
for n=1:50,
    % update J
    % your way
%     J(:) = 0.25*(J(rowN,colC) + J(rowS,colC) + J(rowC,colE) + J(rowC,colW));
    % using matlab's del2
    J(:) = J + del2(J);
    % impose Dirichlet boundary condition
    J(M)=I(M);
    % show the result
    figure(1),subplot(1,2,2),imagesc(J),colormap(gray),axis image;
    title('Inpainting in progress...');
    xlabel(['Inpainting iteration #' num2str(n)]);
    drawnow;
    pause(0.1); % for a faster result comment out this line
end
figure(1),subplot(1,2,2),imagesc(J),colormap(gray),axis image;
title(['Inpainted image after ' num2str(n) ' iterations']);