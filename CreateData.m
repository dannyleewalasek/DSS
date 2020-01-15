%{
This script is used to generate training and testing data.
%}
testData = table("Danny", 20,1,1000,0);
testData.Properties.VariableNames = {'Name','Age','NumberOfIncidents','CarPrice','ExpectedClass'};
carSales = table("Danny", 1000);
carSales.Properties.VariableNames = {'Name','CarPrice'};
incidentData = table("Danny", "101010", "20");
incidentData.Properties.VariableNames = {'Name','IncidentDate','Age'};
a = 2;
while a < 900
    c = a * 2;
    for b = a:c
        testData{b,:} = ["Name" + a, a , a , a*2,0];
        carSales{b,:} = ["Name" + a ,a * 100];
        incidentData{b,:} = ["Name" + a, "IncidentDate"+a ,a];
    end
    a = c;
end
writetable(incidentData);
writetable(carSales);
writetable(testData);