function [ha, hp, r, max_s] = amc_plot_bias_surface(c, r_xyz, f)
% function [ha, hp] = cfa_plot_bias_surface(c, ips)
%
% This funciton plots an elipsoid surface defiend by points in r_xyz.
% The color of the surface reflects the local signal bias, defined by c = 1  - S/S0 .

% - c: Bias signal values for each vertex.
% - r_xyz: Vertex coordinates (Nx3 matrix).
% - f: Faces defining the mesh connectivity.

if nargin < 3
    f = [];
end

x = r_xyz(:,1);
y = r_xyz(:,2);
z = r_xyz(:,3);

%Generate the surface as convex hull
T = delaunayTriangulation(y,x,z);
H = convexHull(T);

%Plot the surface

if isempty(f)
    hp = trisurf(H,y,x,z, c,'FaceColor','interp','FaceLighting','phong');
else 
    % hp = trisurf(f, x, y, z, c, 'FaceColor', 'interp', 'EdgeColor', 'none');
    hp = trisurf(f, y, x, z, c, 'FaceColor','interp','FaceLighting','phong', 'facealpha', 1);
end


ha = gca;

shading interp
axis tight vis3d equal

set(hp,'edgecolor','none');  % You can turn off the edgecolor as well

[max_s, ind] = max(c(:));

r = [x(ind), y(ind), z(ind)];

lb = max([max_s 1]*0.9);
%caxis([lb 1])
% colorbar

% hold on
% plot3(y(ind), x(ind), z(ind), 'ko', 'markersize', 7, 'LineWidth', 3, 'MarkerFaceColor', 'w');

t = title({['SB = ' num2str((max_s), '%0.2f%%')] });%; ...
    %['f/p/s = ' num2str(x(ind),2) '/' num2str(y(ind),2) '/'  num2str(z(ind),2)] });



% Move title closer to the plot
t.Units = 'normalized';
t.Position(2) = t.Position(2) - 0.1;  % decrease this value to bring it closer

xlabel('phase');
ylabel('frequency');
zlabel('slice');
