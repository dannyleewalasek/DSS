% THESE DATA CRFEASTION CLASSES WILL BE REMOVED BEFORE FINAL SUBMISSION
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


crimeStats = table("LS8_1PR", "Burglary");
crimeStats.Properties.VariableNames = {'PostCode','CrimeType'};
housePrices = table("LS8_1PR", "250000", "5000");
housePrices.Properties.VariableNames = {'PostCode','HousePrice','ContentsValue'};
% These values need some randomness and some outliers
a = 2;
while a < 900
    c = a + randi(round(100-(a/10))) + 1;
    for b = a:c
        crimeStats{a+b,1} = strcat("LS",num2str(a),"1QE");
        housePrices{a+b,1} = "LS"+num2str(a)+"1QE";
        % make some of these not burglary
        crimeStats(a+b,:).CrimeType = "Burglary";
        housePrices(a+b,:).HousePrice = a * 1000;
        housePrices(a+b,:).ContentsValue = a + 1000 ;
        disp(a);
    end
    a = c - 1;
end
writetable(housePrices);
writetable(crimeStats);