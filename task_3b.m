load mocapPoints3D.mat
load Parameters_V1_1.mat

Rmat1 = Parameters.Rmat;
Kmat1 = Parameters.Kmat;
C1 = Parameters.position;

load Parameters_V2_1.mat

Rmat2 = Parameters.Rmat;
Kmat2 = Parameters.Kmat;
C2 = Parameters.position;

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