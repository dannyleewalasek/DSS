clear;
% Load data
housePrices = readtable('houseprices.xlsx');
crimeRates = readtable('crimestats.xlsx');
% Data Consolidation
burglaryOnly = crimeRates(crimeRates.CrimeType == "Burglary",:);
cleanHousePrices = housePrices(housePrices.HousePrice > 10000,:);
consolidatedData = innerjoin(cleanHousePrices,burglaryOnly);
% Data Cleaning

% Data Transformation


% Data Reduction
consolidatedData.index = consolidatedData.HousePrice/100 + consolidatedData.ContentsValue;
consolidatedData.HousePrice = [];
consolidatedData.ContentsValue = [];
meanIndexPerPostcode = varfun(@mean,consolidatedData,'InputVariables','index',...
       'GroupingVariables','PostCode');
meanIndexPerPostcode.Properties.VariableNames = {'PostCode','BurglaryCount','Mean_Index'};
meanIndexPerPostcode.PostCode = [];
disp(meanIndexPerPostcode);
scatter(meanIndexPerPostcode.BurglaryCount,meanIndexPerPostcode.Mean_Index)