% Calculations and plotting for img1
load mocapPoints3D.mat
load Parameters_V1_1.mat

Rmat1 = Parameters.Rmat;
Kmat1 = Parameters.Kmat;
C1 = Parameters.position;
pixel_coords1 = zeros(3,39);

for i = 1:size(pts3D,2)
    Pw1 = pts3D(:,i);
    Pc1 = Rmat1*(Pw1-C1');

    projected_coords1 = [Pc1(1)/Pc1(3), Pc1(2)/Pc1(3), 1]';
    
    pixel_coords1(:,i) = Kmat1*projected_coords1;
end

load Parameters_V2_1.mat

Rmat2 = Parameters.Rmat;
Kmat2 = Parameters.Kmat;
C2 = Parameters.position;
pixel_coords2 = zeros(3,39);

for i = 1:size(pts3D,2)
    Pw2 = pts3D(:,i);
    Pc2 = Rmat2*(Pw2-C2');

    projected_coords2 = [Pc2(1)/Pc2(3), Pc2(2)/Pc2(3), 1]';
    
    pixel_coords2(:,i) = Kmat2*projected_coords2;
end

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