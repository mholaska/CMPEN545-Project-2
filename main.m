% Calculations and plotting for img1
load mocapPoints3D.mat
load Parameters_V1_1.mat
img1 = imread('im1corrected.jpg');

Rmat = Parameters.Rmat;
Kmat = Parameters.Kmat;
C = Parameters.position;
pixel_coords = zeros(3,39);

% Iterate through each world coord pixel and calulate the corresponding
% film plane value
for i = 1:size(pts3D,2)
    Pw = pts3D(:,i);
    Pc = Rmat*(Pw-C');

    projected_coords = [Pc(1)/Pc(3), Pc(2)/Pc(3), 1]';
    
    pixel_coords(:,i) = Kmat*projected_coords;
end

% Plot the image with the pixels calculated above
figure(1);
imshow(img1);
axis([0 1920 0 1080])
hold on;
plot(pixel_coords(1,:),pixel_coords(2,:),'.','MarkerSize',10,'Color','#ff0000');
title("Film plane for Camera 1");
hold off;


% Calculations and plotting for img2

load Parameters_V2_1.mat
img2 = imread('im2corrected.jpg');

Rmat = Parameters.Rmat;
Kmat = Parameters.Kmat;
C = Parameters.position;
pixel_coords = zeros(3,39);

% Iterate through each world coord pixel and calulate the corresponding
% film plane value
for i = 1:size(pts3D,2)
    Pw = pts3D(:,i);
    Pc = Rmat*(Pw-C');

    projected_coords = [Pc(1)/Pc(3), Pc(2)/Pc(3), 1]';
    
    pixel_coords(:,i) = Kmat*projected_coords;
end

% Plot the image with the pixels calculated above
figure(2);
imshow(img2);
axis([0 1920 0 1080])
hold on;
plot(pixel_coords(1,:),pixel_coords(2,:),'.','MarkerSize',10,'Color','#ff0000');
title("Film plane for Camera 2");
hold off;