% THESE DATA CRFEASTION CLASSES WILL BE REMOVED BEFORE FINAL SUBMISSION
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
testData = table("LS8_1PR", "1000", 10, 0);
testData.Properties.VariableNames = {'PostCode','index','Burglarys','ActualClass'};
crimeStats = table("LS8_1PR", "Burglary");
crimeStats.Properties.VariableNames = {'PostCode','CrimeType'};
housePrices = table("LS8_1PR", "250000", "5000");
housePrices.Properties.VariableNames = {'PostCode','HousePrice','ContentsValue'};
% These values need some randomness and some outliers
a = 2;
while a < 900
    c = a + randi(round(50-(a/20))) + 1;
    for b = a:c
        testData{b,1} = strcat("LS",num2str(a),"1QE");
        crimeStats{b,1} = strcat("LS",num2str(a),"1QE");
        housePrices{b,1} = "LS"+num2str(a)+"1QE";
        % make some of these not burglary
        crimeStats(b,:).CrimeType = "Burglary";
        housePrices(b,:).HousePrice = b * 1000;
        housePrices(b,:).ContentsValue = b + 1000 ;
        testData{b,2} = ((b * 1000)/100) + ( b + 1000);
        disp("writing to: " + b);
        testData{b,3} = c - a;
        testData{b,4} = 0;
    end
    a = c;
end
writetable(housePrices);
writetable(crimeStats);
testData = unique(testData);
writetable(testData);