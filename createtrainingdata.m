% THESE DATA CRFEASTION CLASSES WILL BE REMOVED BEFORE FINAL SUBMISSION
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


crimeStats = table("LS8_1PR", "Burglary");
crimeStats.Properties.VariableNames = {'PostCode','CrimeType'};
housePrices = table("LS8_1PR", "250000", "5000");
housePrices.Properties.VariableNames = {'PostCode','HousePrice','ContentsValue'};
% These values need some randomness and some outliers
a = 1;
while a < 1000
    c = a + randi(5);
    for b = a:c
        crimeStats{a+b,1} = strcat("LS",num2str(a),"1QE");
        housePrices{a+b,1} = "LS"+num2str(a)+"1QE";
        % make some of these not burglary
        crimeStats(a+b,:).CrimeType = "Burglary";
        housePrices(a+b,:).HousePrice = a * 10000 * (rand);
        housePrices(a+b,:).ContentsValue = 1000 + (a * 10 * (rand));
    end
    a = c-1;
end
writetable(housePrices);
writetable(crimeStats);