% Task 3
% Calculations and plotting for img1
load mocapPoints3D.mat
load Parameters_V1_1.mat

Rmat1 = Parameters.Rmat;
Kmat1 = Parameters.Kmat;
C1 = Parameters.position;

load Parameters_V2_1.mat

Rmat2 = Parameters.Rmat;
Kmat2 = Parameters.Kmat;
C2 = Parameters.position;

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