clear
clc
% program for counting distance traveled by a rat in open field
% and time the rat spent in different zones

% uiopen command - user interface open
e = exist('RatXY.mat', "file");
if e == 0
    uiopen
else
    load RatXY.mat
end
%load RatXY.mat


% necessary values

% 1cm is 8.61 pixel
% inner square side 
px_na_m = 8.61;

%frame per second
fpm = 30;
bok = 60 * px_na_m;

% upper left corner 
nar_x = 370;
nar_y = 300;
% down left corner
nar2_x = nar_x;
nar2_y = nar_y + bok;
% down right corner
nar3_x = nar_x + bok;
nar3_y = nar_y + bok;
% upper right corner
nar4_x = nar_x + bok;
nar4_y = nar_y;

% display plot 
plot(RatXY(:,1),RatXY(:,2), "b.")
hold on

% it is not scaled
xticklabels([0 10 20 30 40 50 60 70 80 90 100]);
yticklabels([0 10 20 30 40 50 60 70 80 90 100]);
%plot(RatXY(:,1),RatXY(:,2))

% ploting the inner zone [x y w h] x i y - initial coordinates 
% w i h - rectangle size
rectangle('Position',[nar_x nar_y bok bok])
hold off

% rat x
szczur_x = RatXY(:,1);
% rat y
szczur_y = RatXY(:,2);

% time
% 30 frames per second
% duration is simply number of frames divided by 30
czas_caly = length(RatXY)/fpm;

% main program
% in how many frames rat's x and y is inside square

% variable with number of frames
l_k = 0;

% variables with distance traveled by the rat
% whole distance
dystans_caly = 0;
% distance inside the inner zone
dystans_w_strefie = 0;

% loop for each x and y values
% -1 value to avoid index outside the range error
for x = 1: (length(szczur_x)-1)
    % is x value inside the interval
    if szczur_x(x) > nar_x && szczur_x(x) < nar4_x
        % is y value inside the interval
        if szczur_y(x) > nar_y && szczur_y(x) < nar3_y
            l_k = l_k +1;
            %d_2 = oblicz_dystans(szczur_x(x), szczur_y(x));
            d_2 = sqrt(power((szczur_x(x+1)-szczur_x(x)),2)+power((szczur_y(x+1)-szczur_y(x)),2));
            % correction for small movements e.g. head
            % that shouldn't be recorded as a rat movement
            if d_2 < 2
                d_2 = 0;
            end
            dystans_w_strefie = dystans_w_strefie + d_2;
            hold on
            plot(szczur_x(x),szczur_y(x),'r.')
        end
    end
	
    % distance traveled by the rat
    d = sqrt(power((szczur_x(x+1)-szczur_x(x)),2)+power((szczur_y(x+1)-szczur_y(x)),2));
    % correction for small movements e.g. head
    % that shouldn't be recorded as a rat movement
    if d < 2
        d = 0;
    end
    dystans_caly = dystans_caly + d;
end


% time inside the zone
czas_w_strefie = l_k/fpm;

% time outside the zone = time rat was away from center of the open field arena
czas_poza_strefa = czas_caly - czas_w_strefie;

% from pixels to cm
dystans_caly = dystans_caly/px_na_m;
dystans_w_strefie = dystans_w_strefie/px_na_m;
dystans_poza_strefa = dystans_caly - dystans_w_strefie;

% display data
fprintf("\nSzczur spêdzi³ w wewnêtrznej strefie: %fs\n", czas_w_strefie)
fprintf("\nSzczur spêdzi³ w zewnêtrznej strefie: %fs\n", czas_poza_strefa)
fprintf("\nSzczur przemieœci³ siê o: %fcm\n", dystans_caly)
fprintf("\nSzczur przemieœci³ siê w strefie wewnêtrznej o: %fcm\n", dystans_w_strefie)
fprintf("\nSzczur przemieœci³ siê poza stref¹ wewnêtrzn¹ o: %fcm\n", dystans_poza_strefa)

% function for calulating rat movement from one frame to the other
function[dystans] = oblicz_dystans(szczur_x, szczur_y)
% euclidean distance
d = sqrt(power((szczur_x(x+1)-szczur_x(x)),2)+power((szczur_y(x+1)-szczur_y(x)),2));
% was the movement significant?
if d < 2
    dystans = 0;
else
    dystans = d;
end
end
