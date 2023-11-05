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

% Perform triangulation
constructed_3Dpts = zeros(3, 39);  % To store the 3D world coordinates

for i = 1:size(pts3D, 2)
    x1 = pixel_coords1(1, i);
    y1 = pixel_coords1(2, i);
    x2 = pixel_coords2(1, i);
    y2 = pixel_coords2(2, i);

    % Projection matrix
    P1 = Kmat1 * [Rmat1, -Rmat1 * C1'];
    P2 = Kmat2 * [Rmat2, -Rmat2 * C2'];

    % Perform triangulation
    point = triangulate([x1, y1], [x2, y2], P1, P2); % This is from the Computer Vision Toolbox extension
    constructed_3Dpts(:, i) = point;
end

% Mean Square error of points:
error = mean(sum((constructed_3Dpts-pts3D).^2,1));
fprintf("The mean squared error between the triangulated points and mocap points is: %d\n\n",error);

% Task 3
% A)
im1pts = [333,709;931,602;978,934];
im2pts = [930,892;500,597;1710,697];
floor_points = zeros(3,3);

for i = 1:3
    x1 = im1pts(i, 1);
    y1 = im1pts(i, 2);
    x2 = im2pts(i, 1);
    y2 = im2pts(i, 2);

    % Projection matrix
    P1 = Kmat1 * [Rmat1, -Rmat1 * C1'];
    P2 = Kmat2 * [Rmat2, -Rmat2 * C2'];
    % Perform triangulation
    point = triangulate([x1, y1], [x2, y2], P1, P2); % This is from the Computer Vision Toolbox extension
    floor_points(:, i) = point;
end

fvector1 = floor_points(:,2)-floor_points(:,1);
fvector2 = floor_points(:,3)-floor_points(:,1);
point_on_plane = floor_points(:,1);
norm_floor_plane = cross(fvector1,fvector2)/norm(cross(fvector1,fvector2));
D = dot(norm_floor_plane,point_on_plane);
disp("The floor plane equation takes the form: Ax + By + Cz + D = 0:");
fprintf("Floor plane equation: %fx + %fy + %fz + %f = 0 \n\n",norm_floor_plane(1),norm_floor_plane(2),norm_floor_plane(3),D);

%B)
im1pts = [1425,216;1213,288;1707,623];
im2pts = [611,108;356,177;877,460];
wall_points = zeros(3,3);

for i = 1:3
    x1 = im1pts(i, 1);
    y1 = im1pts(i, 2);
    x2 = im2pts(i, 1);
    y2 = im2pts(i, 2);

    % Projection matrix
    P1 = Kmat1 * [Rmat1, -Rmat1 * C1'];
    P2 = Kmat2 * [Rmat2, -Rmat2 * C2'];
    % Perform triangulation
    point = triangulate([x1, y1], [x2, y2], P1, P2); % This is from the Computer Vision Toolbox extension
    wall_points(:, i) = point;
end

wvector1 = wall_points(:,2)-wall_points(:,1);
wvector2 = wall_points(:,3)-wall_points(:,1);
point_on_plane = wall_points(:,1);
norm_wall_plane = cross(wvector1,wvector2)/norm(cross(wvector1,wvector2));
D = dot(norm_wall_plane,point_on_plane);
disp("The wall plane equation takes the form: Ax + By + Cz + D = 0:");
fprintf("Wall plane equation: %fx + %fy + %fz + %f = 0 \n\n",norm_wall_plane(1),norm_wall_plane(2),norm_wall_plane(3),D);


% C)
top_of_doorim1 = [1128,290];
bottom_of_doorim1 = [1117,547];
top_of_doorim2 = [222,176];
bottom_of_doorim2 = [250,514];

% Projection matrix
P1 = Kmat1 * [Rmat1, -Rmat1 * C1'];
P2 = Kmat2 * [Rmat2, -Rmat2 * C2'];

x1 = top_of_doorim1(1, 1);
y1 = top_of_doorim1(1, 2);
x2 = top_of_doorim2(1, 1);
y2 = top_of_doorim2(1, 2);

point_top = triangulate([x1, y1], [x2, y2], P1, P2); % This is from the Computer Vision Toolbox extension

x1 = bottom_of_doorim1(1, 1);
y1 = bottom_of_doorim1(1, 2);
x2 = bottom_of_doorim2(1, 1);
y2 = bottom_of_doorim2(1, 2);

point_bottom = triangulate([x1, y1], [x2, y2], P1, P2); % This is from the Computer Vision Toolbox extension

height_of_door = point_top(3)-point_bottom(3);
fprintf("Height of door is approimately %.2f meters\n\n",height_of_door/1000);

top_of_personim1 = [575,392];
bottom_of_personim1 = [551,717];
top_of_personim2 = [1040,346];
bottom_of_personim2 = [1042,780];

% Projection matrix
P1 = Kmat1 * [Rmat1, -Rmat1 * C1'];
P2 = Kmat2 * [Rmat2, -Rmat2 * C2'];

x1 = top_of_personim1(1, 1);
y1 = top_of_personim1(1, 2);
x2 = top_of_personim2(1, 1);
y2 = top_of_personim2(1, 2);

point_top = triangulate([x1, y1], [x2, y2], P1, P2); % This is from the Computer Vision Toolbox extension

x1 = bottom_of_personim1(1, 1);
y1 = bottom_of_personim1(1, 2);
x2 = bottom_of_personim2(1, 1);
y2 = bottom_of_personim2(1, 2);

point_bottom = triangulate([x1, y1], [x2, y2], P1, P2); % This is from the Computer Vision Toolbox extension

height_of_person = point_top(3)-point_bottom(3);
fprintf("Height of person is approimately %.2f meters\n\n",height_of_person/1000);

centerim1 = [960,540];
centerim2 = [960,540];

% Projection matrix
P1 = Kmat1 * [Rmat1, -Rmat1 * C1'];
P2 = Kmat2 * [Rmat2, -Rmat2 * C2'];

x1 = centerim1(1, 1);
y1 = centerim1(1, 2);
x2 = centerim2(1, 1);
y2 = centerim2(1, 2);

point_center = triangulate([x1, y1], [x2, y2], P1, P2); % This is from the Computer Vision Toolbox extension

fprintf("The 3D coordinate of the centers of the cameras in mm is (%.2f,%.2f,%.2f)\n\n",point_center);




