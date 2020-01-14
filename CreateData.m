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
    c = a * 2;
    for b = a:c
        testData{b,:} = [strcat("LS",num2str(a),"1QE"),(a * 1000)/100 + ( 1+1000),0,0];
        crimeStats{b,:} = [strcat("LS",num2str(a),"1QE"),"Burglary"];
        housePrices{b,:} = ["LS"+num2str(a)+"1QE",a * 1000,a + 1000];
    end
    a = c;
end
writetable(housePrices);
writetable(crimeStats);
writetable(testData);