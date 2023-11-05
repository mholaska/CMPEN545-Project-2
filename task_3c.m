load mocapPoints3D.mat
load Parameters_V1_1.mat

Rmat1 = Parameters.Rmat;
Kmat1 = Parameters.Kmat;
C1 = Parameters.position;

load Parameters_V2_1.mat

Rmat2 = Parameters.Rmat;
Kmat2 = Parameters.Kmat;
C2 = Parameters.position;


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