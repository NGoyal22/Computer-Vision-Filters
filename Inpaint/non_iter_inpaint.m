clc;
close all;
clear all;
% read the damaged image
J = double(imread('damaged_cameraman.bmp'));
% show images
figure(1),subplot(2,2,1),imagesc(J),colormap(gray),axis image;
title('Damaged image');
xlabel('Press a key to do non-iterative inpainting.');
pause;
xlabel('');

% read the damage mask - 0 where image is damaged, 1 where image is fine
M = double(imread('damage_mask.bmp'));
% normalise M
M(:) = (M-min(M(:)))/(max(M(:))-min(M(:)));
M = logical(M);

[h,w]=size(J);

D5 = zeros(h*w,5);
% D5(:,1)=1; D5(:,2)=1; D5(:,3)=-4; D5(:,4)=1; D5(:,5)=1;
D5(:,1)=-1; D5(:,2)=-1; D5(:,3)=4; D5(:,4)=-1; D5(:,5)=-1;

% Dirichlet BC
D5([M(1+h:end) M(1:h)]',1) = 0; D5([M(2:end) M(1)]',2) = 0;
D5(M(:),3)=1; 
D5([M(end) M(1:end-1)]',4) = 0; D5([M(end-h+1:end) M(1:end-h)]',5) = 0;
% form the Laplacian matrix including the BC
A = spdiags(D5,[-h -1 0 1 h],h*w,h*w);

% right hand side of the equation
b = J(:);
b(~M(:))=0;

% solve and respahe
J = reshape(A\b, h, w);

% show inpainted result
figure(1),subplot(2,2,2),imagesc(J),colormap(gray),axis image;
title('Inpainted image');

% read the original image
I = double(imread('cameraman.bmp'));
% show the original for visual comparison
figure(1),subplot(2,2,4),imagesc(I),colormap(gray),axis image;
title('Original image');

% BC_diff_TD(i-starti+1) = min(1,(i-starti)/offset)*BC_Top -
% min(1,(endi-i)/offset)*BC_Bottom;