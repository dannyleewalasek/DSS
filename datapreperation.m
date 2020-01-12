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
%count number of burglarys for each post code
burglaryOnly{:,3} = 0;
a = 1;
while a < height(burglaryOnly)
    count = 0;
    for b = 1:height(burglaryOnly)
        if isequal(burglaryOnly(a,1),burglaryOnly(b,1))
            count = count + 1;
            disp("testing: " + a + "with: " + b + " " +count);
            burglaryOnly{a,3} = count;
        end
    end
    a = a + count+1;
    count = 0;
end

burglaryOnly = unique(burglaryOnly);

cleanHousePrices = housePrices(housePrices.HousePrice > 10000,:);
cleanHousePrices = unique(cleanHousePrices);
consolidatedData = innerjoin(cleanHousePrices,burglaryOnly);
disp(consolidatedData);
consolidatedData.Properties.VariableNames = {'PostCode','HousePrice','ContentsValue','CrimeType','Count'};
% Data Cleaning

% Remove Null values
%consolidatedData = rmmissing(consolidatedData);

% Data Transformation
consolidatedData.index = (consolidatedData.HousePrice/100) + consolidatedData.ContentsValue;

% Data Reduction
consolidatedData.HousePrice = [];
consolidatedData.ContentsValue = [];
%disp(height(consolidatedData(consolidatedData.PostCode == "LS8961QE",:)));
% Remove duplicates

consolidatedData = unique(consolidatedData);
disp(consolidatedData);

%disp(consolidatedData);
%consolidatedData = unique(consolidatedData);
meanIndexPerPostcode = varfun(@mean,consolidatedData,'InputVariables','index',...
       'GroupingVariables','PostCode');
meanIndexPerPostcode.Properties.VariableNames = {'PostCode','BurglaryCount','Mean_Index'};
meanIndexPerPostcode.PostCode = [];
meanIndexPerPostcode.BurglaryCount = meanIndexPerPostcode.BurglaryCount/2;
disp(meanIndexPerPostcode);

% Save output
writetable(meanIndexPerPostcode);