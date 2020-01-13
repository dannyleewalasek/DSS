%{
This script is used to generate training and testing data.
%}
testData = table("LS8_1PR", "1000", 10, 0);
testData.Properties.VariableNames = {'PostCode','index','Burglarys','ActualClass'};
crimeStats = table("LS8_1PR", "Burglary");
crimeStats.Properties.VariableNames = {'PostCode','CrimeType'};
housePrices = table("LS8_1PR", "250000", "5000");
housePrices.Properties.VariableNames = {'PostCode','HousePrice','ContentsValue'};
a = 2;
while a < 900
    c = a * 2; %a +  randi(round(50-(a/20))) + 1;
    disp(c);
    for b = a:c
        testData{b,1} = strcat("LS",num2str(a),"1QE");
        crimeStats{b,1} = strcat("LS",num2str(a),"1QE");
        housePrices{b,1} = "LS"+num2str(a)+"1QE";
        % make some of these not burglary
        crimeStats(b,:).CrimeType = "Burglary";
        housePrices(b,:).HousePrice = a * 1000;
        housePrices(b,:).ContentsValue = a + 1000 ;
        testData(b,:).index = (a * 1000)/100 + ( 1+1000);
    end
    a = c;
end
writetable(housePrices);
writetable(crimeStats);
writetable(testData);