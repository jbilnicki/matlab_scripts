clear
clc
% program obliczaj�cy dystans pokonany przez szczura w otwartym polu
% i czas sp�dzony w wyznaczonych strefach 

%komenda uiopen - user interface open
e = exist('RatXY.mat', "file");
if e == 0
    uiopen
else
    load RatXY.mat
end
%load RatXY.mat


% warto�ci potrzebne do oblicze�

% 1cm to 8.61 piksela
%bok kwadratu wewn�trznego
px_na_m = 8.61;
%frame per second
fpm = 30;
bok = 60 * px_na_m;
% lewy g�rny naro�nik 
nar_x = 370;
nar_y = 300;
% lewy dolny naro�nik
nar2_x = nar_x;
nar2_y = nar_y + bok;
% prawy dolny naro�nik
nar3_x = nar_x + bok;
nar3_y = nar_y + bok;
% prawy g�rny naro�nik
nar4_x = nar_x + bok;
nar4_y = nar_y;

% wykres
plot(RatXY(:,1),RatXY(:,2), "b.")
hold on

% to nie jest wyskalowane 
xticklabels([0 10 20 30 40 50 60 70 80 90 100]);
yticklabels([0 10 20 30 40 50 60 70 80 90 100]);
%plot(RatXY(:,1),RatXY(:,2))

% zaznaczenie strefy wewn�trznej [x y w h] x i y - wsp�rz�dne pocz�tku
% w i h - wielko�� prostok�tu
rectangle('Position',[nar_x nar_y bok bok])
hold off

% x szczur�w
szczur_x = RatXY(:,1);
% y szczur�w
szczur_y = RatXY(:,2);
% czas
% 30 klatek na sekund�
% czas trwania to ilo�� klatek na 30
czas_caly = length(RatXY)/fpm;

% g��wny program
% w ilu klatkach x i y szczura mie�ci si� wewnatrz kwadratu
% tzn x i y zawiera si� w odpowiednich przedzia�ach
% pocz�tkowa liczba klatek ze szczurem w �rodku przedzia�u
l_k = 0;
% pocz�tkowy dystans przebyty przez szczura
dystans_caly = 0;
dystans_w_strefie = 0;
% p�tla id�ca przez wszystkie x i sprawdzaj�ca x i y
% -1 �eby w ostatniej klatce nie wywala� ze poza indeksem x+1 w dystansie
for x = 1: (length(szczur_x)-1)
    % czy x mie�ci si� w przedziale?
    if szczur_x(x) > nar_x && szczur_x(x) < nar4_x
        % czy y mie�ci si� w przedziale?
        if szczur_y(x) > nar_y && szczur_y(x) < nar3_y
            l_k = l_k +1;
            %d_2 = oblicz_dystans(szczur_x(x), szczur_y(x));
            d_2 = sqrt(power((szczur_x(x+1)-szczur_x(x)),2)+power((szczur_y(x+1)-szczur_y(x)),2));
            %poprawka na to czy szczur nie poruszy� np. g�ow� 
            %a nie przesun�� si�
            if d_2 < 2
                d_2 = 0;
            end
            dystans_w_strefie = dystans_w_strefie + d_2;
            hold on
            plot(szczur_x(x),szczur_y(x),'r.')
        end
    end
    % dystans przebyty przez sczura
    d = sqrt(power((szczur_x(x+1)-szczur_x(x)),2)+power((szczur_y(x+1)-szczur_y(x)),2));
    % poprawka na to czy szczur nie poruszy� np. g�ow� 
    % a nie przesun�� si�
    if d < 2
        d = 0;
    end
    dystans_caly = dystans_caly + d;
end
% ile czasu szczur sp�dzi� w wyznaczonej strefie?
czas_w_strefie = l_k/fpm;
% ile czasu szczur sp�dzi� poza stref� = ile czasu by� w pobli�u �cian
czas_poza_strefa = czas_caly - czas_w_strefie;
% przeliczenie dystansu z pikseli na cm
dystans_caly = dystans_caly/px_na_m;
dystans_w_strefie = dystans_w_strefie/px_na_m;
dystans_poza_strefa = dystans_caly - dystans_w_strefie;

% wy�wietlnienie danych 
fprintf("\nSzczur sp�dzi� w wewn�trznej strefie: %fs\n", czas_w_strefie)
fprintf("\nSzczur sp�dzi� w zewn�trznej strefie: %fs\n", czas_poza_strefa)
fprintf("\nSzczur przemie�ci� si� o: %fcm\n", dystans_caly)
fprintf("\nSzczur przemie�ci� si� w strefie wewn�trznej o: %fcm\n", dystans_w_strefie)
fprintf("\nSzczur przemie�ci� si� poza stref� wewn�trzn� o: %fcm\n", dystans_poza_strefa)

% funkcja obliczaj�ca dystans mi�dzy po�o�eniami szczura i bioraca poprawki
% na nieistotne ruchy
function[dystans] = oblicz_dystans(szczur_x, szczur_y)
% obliczenie odleg�o�ci
d = sqrt(power((szczur_x(x+1)-szczur_x(x)),2)+power((szczur_y(x+1)-szczur_y(x)),2));
% sprawdzenie czy ruch by� istotny
% czy np. szczur ruszy� g�ow� tylko
if d < 2
    dystans = 0;
else
    dystans = d;
end
end
