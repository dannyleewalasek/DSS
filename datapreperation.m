clear;
% Load data
housePrices = readtable('houseprices.xlsx');
crimeRates = readtable('crimestats.xlsx');
% Data Consolidation
burglaryOnly = crimeRates(crimeRates.CrimeType == "Burglary",:);
cleanHousePrices = housePrices(housePrices.HousePrice > 10000,:);
consolidatedData = innerjoin(cleanHousePrices,burglaryOnly);
% Data Cleaning

% Remove Null values
consolidatedData = rmmissing(consolidatedData);

% Data Transformation
consolidatedData.index = consolidatedData.HousePrice/100 + consolidatedData.ContentsValue;

% Data Reduction
consolidatedData.HousePrice = [];
consolidatedData.ContentsValue = [];
meanIndexPerPostcode = varfun(@mean,consolidatedData,'InputVariables','index',...
       'GroupingVariables','PostCode');
meanIndexPerPostcode.Properties.VariableNames = {'PostCode','BurglaryCount','Mean_Index'};
meanIndexPerPostcode.PostCode = [];

% Remove duplicates
consolidatedData = unique(consolidatedData);

disp(meanIndexPerPostcode);

% Save output
writetable(meanIndexPerPostcode);