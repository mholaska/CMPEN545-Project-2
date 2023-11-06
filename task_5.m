% Check to see if previous task has been run and assign that value to the
% F-Matrix, if not initialize to a previously found F-Matrix
if ~exist('F', 'var')
    F = [-0.000228314,0.00744931,-2.34198;0.0102348,0.00406473,6.3661;-1.76466,-28.8899,7127.18 ];
end


load mocapPoints3D.mat
load Parameters_V1_1.mat

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

load Parameters_V2_1.mat

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


sum = 0;
for i = 1:size(pts3D,2)
    x1 = pixel_coords1(1,i);
    y1 = pixel_coords1(2,i);
    x2 = pixel_coords2(1,i);
    y2 = pixel_coords2(2,i);
    
    e2 = F*[x1,y1,1]';
    sgd2 = ((e2(1)*x2+e2(2)*y2+e2(3))^2)/(e2(1)^2+e2(2)^2);
    
    e1 = [x2,y2,1]*F;
    sgd1 = ((e1(1)*x1+e1(2)*y1+e1(3))^2)/(e1(1)^2+e1(2)^2);
    sum = sum + sgd1 + sgd2;
end

avg_sgd = sum/(2*39);

fprintf("Average Square Geometrix distance: %.2f\n",avg_sgd);



