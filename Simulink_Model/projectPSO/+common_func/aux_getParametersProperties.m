function [param4Opt] = aux_getParametersProperties()
% Array mit Bezeichnung und Symbol der möglichen zu optimierenden
% Parametern
paramStrings = {
    'Haftreibung',					'Fstick';
    'Gleitreibung',					'Fcoulomb';
    'Stribeckgeschwindigkeit',		'stribeckVel';
    'Koeff.1 für Viskose Reibung',  'viscFriCoeff1';
    'Koeff.2 für Viskose Reibung',  'viscFriCoeff2';
    'Koeff.3 für Viskose Reibung',  'viscFriCoeff3';
    'Totvolumen Kammer2',			'Vtot2';
    'Versorgungsdruck',				'pv';
    'Umgebungsdruck',				'pu';
    'Druck 2 bei t=0',				'p02';
    'Federkonstante',				'c';
    'Federvorspannung',				'xf';
    'Dämpferkonstante',				'd';
	'max. pneum. Leitwert',			'cMax';
	'min. pneum. Leitwert',			'cMin';
    };

% zu untersuchender Intervall für die Parameter angeben:  

    % Fstick		-> Haftreibung [N]
	pos = find(strcmp(paramStrings(:,2),'Fstick'));
%       minX(pos) = .1;
%       maxX(pos) = 500;
      minX(pos) = 100;
      maxX(pos) = 200;
	  
    % Fcoulomb      -> Gleitreibung [N]
	pos = find(strcmp(paramStrings(:,2),'Fcoulomb'));
%       minX(pos) = .1;
%       maxX(pos) = 250;
      minX(pos) = 10;
      maxX(pos) = 100;
	  
    % stribeckVel			-> Stribeckgeschwindigkeit [m/s]
	pos = find(strcmp(paramStrings(:,2),'stribeckVel'));
      minX(pos) = .0005;		%10e-9; %(Limits durch Modell vorgegeben)
      maxX(pos) = 1000;			%1e+030; %(Limits durch Modell vorgegeben)
	  
    % viscFriCoeff1			-> Koeff.1 für Viskose Reibung [Ns/m]
	pos = find(strcmp(paramStrings(:,2),'viscFriCoeff1'));
      minX(pos) = .5;
      maxX(pos) = 15;
	  
    % viscFriCoeff2			-> Koeff.2 für Viskose Reibung [Ns/m]
	pos = find(strcmp(paramStrings(:,2),'viscFriCoeff2'));
      minX(pos) = .5;
      maxX(pos) = 10;
	  
    % viscFriCoeff3			-> Koeff.3 für Viskose Reibung [Ns/m]
	pos = find(strcmp(paramStrings(:,2),'viscFriCoeff3'));
      minX(pos) = .5;
      maxX(pos) = 10;
	  
    % Vtot2			-> Totvolumen Kammer2 [m^3]
	pos = find(strcmp(paramStrings(:,2),'Vtot2'));
		hTotKonstr = .0095;												% Höhe Totvolumen laut Konstruktion, wenn Ausgangsdaten generiert
%       minX(pos) = 0;
%       maxX(pos) = evalin('base',['mdlPara.A2 * mdlPara.xMax',';']);	%(Fläche * max. Hub)
      minX(pos) = evalin('base','mdlPara.A2;') * hTotKonstr * .9;		% Totvolumen laut Konstruktion um -10% variiert
      maxX(pos) = evalin('base','mdlPara.A2;') * hTotKonstr * 1.1;		% Totvolumen laut Konstruktion um +10% variiert
	  
    % pv			-> Versorgungsdruck [Pa]
	pos = find(strcmp(paramStrings(:,2),'pv'));
      minX(pos) = 250000;
      maxX(pos) = 750000;
	  
    % pu			-> Umgebugsdruck [Pa]
	pos = find(strcmp(paramStrings(:,2),'pu'));
      minX(pos) = 80000;
      maxX(pos) = 120000;
	  
    % p02			-> Druck 2 in Kammer 2 bei t=0 [Pa]
	pos = find(strcmp(paramStrings(:,2),'p02'));
      minX(pos) = 80000;
      maxX(pos) = 750000;
	  
    % c				-> Federkonstante [N/m] = [kg/s^2]
	pos = find(strcmp(paramStrings(:,2),'c'));
		cKonstr = evalin('base','mdlPara.c;');							% Federkonst. laut Konstruktion [N/m], wenn Ausgangsdaten generiert
      minX(pos) = cKonstr * .75;
      maxX(pos) = cKonstr * 2;
	  
    % xf			-> Federvorspannung [m]
	pos = find(strcmp(paramStrings(:,2),'xf'));
		xfKonstr = evalin('base','mdlPara.xf;');						% Federvorspannung laut Konstr. [m], wenn Ausgangsdaten generiert
      minX(pos) = xfKonstr * .9;
      maxX(pos) = xfKonstr * 1.1;
	  
    % d				-> Dämpferkonstante [N/(m s)] = [kg/s]
	pos = find(strcmp(paramStrings(:,2),'d'));
      minX(pos) = 1;
      maxX(pos) = 500;
	  
    % cMax				-> max. pneum. Leitwert
	pos = find(strcmp(paramStrings(:,2),'cMax'));
      minX(pos) = 1e-10;
      maxX(pos) = 7e-10;
	  
    % cMin				-> max. pneum. Leitwert für Entlüftung
	pos = find(strcmp(paramStrings(:,2),'cMin'));
      minX(pos) = 1e-11;
      maxX(pos) = 1e-10;
	  
	  
% create empty exclude logic
excludeArray = false(length(paramStrings),1);
% define exclude logic
flagDone = false;
while ~flagDone
	try
		excludeArray = getExcludeArray(excludeArray,paramStrings);
		flagDone = true;
	catch
		disp(' ')
		disp('You gave some wrong input, please try again ...')
		disp(' ')
	end
end

% exclude the neglected parameters and create parameters' cell
param4Opt		= cell(sum(excludeArray)+1,4);
param4Opt(1,:)	= {'NAME', 'SYMBOL', 'MIN', 'MAX'};
k = 2;
for i = 1:length(paramStrings)
    if excludeArray(i) == true
        param4Opt(k,1) = paramStrings(i,1);
        param4Opt(k,2)   = paramStrings(i,2);
		k = k+1;
    end
end
clear i k
param4Opt(2:end,3) = num2cell(minX(excludeArray));
param4Opt(2:end,4) = num2cell(maxX(excludeArray));

end


%% auxiliary functions
function excludeArray = getExcludeArray(excludeArray,paramStrings)

disp(' ')
disp('Please select the parameters, which you want to optimize [1/0]:')

for i = 1:length(paramStrings)
    excludeArray(i) = input([' - ', paramStrings{i,1}, ...
        '(',paramStrings{i,2},')?   ']);
end

% One can only optimise both or none of the friction froces:
sumFricFor = sum(strcmp(paramStrings(excludeArray,2),'Fstick') ...
	+ strcmp(paramStrings(excludeArray,2),'Fcoulomb'));

if  sumFricFor ~= 2 && sumFricFor ~= 0
    disp(' ')
    disp('It is not possible to otimise ''Fstick'' or ''Fcoulomb'' only!')
    disp('You have to optimise both or none of them.')
    disp('Choose your parameters again...')
    
    excludeArray = getExcludeArray(excludeArray,paramStrings);
end

end