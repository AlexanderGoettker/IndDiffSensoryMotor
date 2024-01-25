function [a] = plot_polar_2(x,y)

% plot the results using mmpolar
x = circ_ang2rad(x); 


x(end+1) = x(1);  %  Put a value for the 360 degree to make it a full circle 
y(end+1) = y(1); 

gridWidth = 1.5;
fontSize = 15;
fig = figure();



% first, the intermediate ones
interm_handle = mmpolar(x, y, ...
                        'Color', 'k', ...
                        'LineStyle', '--');
% now the optimal one
hold on
opt_handle = mmpolar(x, y, ...
                     'Color', 'k', ...
                     'LineStyle', '-.');
% now the result of the algo, also configure looks of the plot
res_handle = mmpolar(x, y, ...
                     'Color','k', ...
                     'LineStyle', '-', ...
                     'BackgroundColor', [0.9176470588 0.9176470588 0.9490196078], ...
                     'Style', 'compass',...
                     'BorderColor', 'white', ...
                     'FontSize', fontSize, ...
                     'RTickLabelVisible', 'off', ...
                     'RGridColor', 'white', ...
                     'RGridLineStyle', '-', ...
                     'RGridLineWidth', gridWidth, ...
                     'TTickLabelVisible', 'on', ...
                     'TGridColor', 'white', ...
                     'TTickLabelColor', 'k', ...
                     'TGridLineStyle', '-', ...
                     'TGridLineWidth', gridWidth);

% set the line widths
set(res_handle(1:end-2), 'LineWidth', 1.5); % the intermediate results
set(res_handle(end-1), 'LineWidth', 5); % the optimal value
set(res_handle(end), 'LineWidth', 3); % the final result

% legend
leg = legend([res_handle(1) res_handle(end-1) res_handle(end)], ...
             'Intermediate', 'Optimum', 'Final Result');
set(leg, 'Location', 'SouthOutside');
set(leg, 'Orientation', 'horizontal');
set(leg, 'EdgeColor', 'white');
set(leg, 'FontSize', fontSize);

% figure settings
% need this to print the actual background color
set(fig, 'Color', 'white');
set(fig, 'InvertHardCopy', 'off');
% set the size
xdim = 8;
ydim = 8;
%set(fig, 'PaperUnits', 'normalized');
set(fig, 'PaperSize', [xdim ydim]);
set(fig, 'PaperPositionMode', 'manual');
set(fig, 'PaperPosition', [0 0 xdim ydim]);

% print to file
fn = sprintf('%s/Summed_Pattern_0dBSNR', plotsDir);
print(gcf, fn, '-depsc')

a = 0; 