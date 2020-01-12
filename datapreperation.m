%{
This script is used to prepare data on burglarys and on postcode wealth
fopr use in the model training stage.
%}
clear;
% Load data
housePrices = readtable('houseprices.txt');
crimeRates = readtable('crimestats.txt');
% Data Consolidation
burglaryOnly = crimeRates(crimeRates.CrimeType == "Burglary",:);
cleanHousePrices = housePrices(housePrices.HousePrice > 10000,:);
consolidatedData = innerjoin(cleanHousePrices,burglaryOnly);
consolidatedData{:,5} = 0;
consolidatedData.Properties.VariableNames = {'PostCode','HousePrice','ContentsValue','CrimeType','Count'};
% Data Cleaning

% Remove Null values
consolidatedData = rmmissing(consolidatedData);

% Data Transformation
consolidatedData.index = consolidatedData.HousePrice/100 + consolidatedData.ContentsValue;

% Data Reduction
consolidatedData.HousePrice = [];
consolidatedData.ContentsValue = [];
disp(height(consolidatedData(consolidatedData.PostCode == "LS8961QE",:)));
disp(consolidatedData);
% Remove duplicates


%consolidatedData = unique(consolidatedData);
meanIndexPerPostcode = varfun(@mean,consolidatedData,'InputVariables','index',...
       'GroupingVariables','PostCode');
   disp(meanIndexPerPostcode);
meanIndexPerPostcode.Properties.VariableNames = {'PostCode','BurglaryCount','Mean_Index'};
meanIndexPerPostcode.PostCode = [];




% Save output
writetable(meanIndexPerPostcode);