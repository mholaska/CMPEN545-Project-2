% Calculations and plotting for img1
load mocapPoints3D.mat
load Parameters_V1_1.mat
img1 = imread('im1corrected.jpg');

Rmat1 = Parameters.Rmat;
Kmat1 = Parameters.Kmat;
C1 = Parameters.position;
pixel_coords1 = zeros(3,39);

% Iterate through each world coord pixel and calulate the corresponding
% film plane value
for i = 1:size(pts3D,2)
    Pw1 = pts3D(:,i);
    Pc1 = Rmat1*(Pw1-C1');

    projected_coords1 = [Pc1(1)/Pc1(3), Pc1(2)/Pc1(3), 1]';
    
    pixel_coords1(:,i) = Kmat1*projected_coords1;
end

% Plot the image with the pixels calculated above
figure(1);
imshow(img1);
axis([0 1920 0 1080])
hold on;
plot(pixel_coords1(1,:),pixel_coords1(2,:),'.','MarkerSize',10,'Color','#ff0000');
title("Film plane for Camera 1");
% Show image pixels on images
h = impixelinfo;
set(h, 'Position', [10, 10, 300, 20]); % Adjust the position as needed
hold off;


% Calculations and plotting for img2

load Parameters_V2_1.mat
img2 = imread('im2corrected.jpg');

Rmat2 = Parameters.Rmat;
Kmat2 = Parameters.Kmat;
C2 = Parameters.position;
pixel_coords2 = zeros(3,39);

% Iterate through each world coord pixel and calulate the corresponding
% film plane value
for i = 1:size(pts3D,2)
    Pw2 = pts3D(:,i);
    Pc2 = Rmat2*(Pw2-C2');

    projected_coords2 = [Pc2(1)/Pc2(3), Pc2(2)/Pc2(3), 1]';
    
    pixel_coords2(:,i) = Kmat2*projected_coords2;
end

% Plot the image with the pixels calculated above
figure(2);
imshow(img2);
axis([0 1920 0 1080])
hold on;
plot(pixel_coords2(1,:),pixel_coords2(2,:),'.','MarkerSize',10,'Color','#ff0000');
title("Film plane for Camera 2");
% Show image pixels on images
h = impixelinfo;
set(h, 'Position', [10, 10, 300, 20]); % Adjust the position as needed
hold off;