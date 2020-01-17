%{
This script is used to generate training and testing data.
%}
testData = table("Danny", 20,1,1000,0);
testData.Properties.VariableNames = {'Name','Age','YearsNoClaims','CarPrice','ExpectedClass'};
claims = table("Danny", 0);
claims.Properties.VariableNames = {'Name','FraudDetected'};
customerInformation = table("Danny", "101", "20", 1);
customerInformation.Properties.VariableNames = {'Name','CarValue','Age','YearsNoClaims'};
a = 2;
while a < 900
    c = a * 2;
    for b = a:c

        customerInformation{b,:} = ["Name" + b, a ,a + randi(4),randi([0,5])];
        if (a > 400)
            claims{b,:} = ["Name" + b ,0];
            testData{b,:} = ["Name" + b, a , a , a*2,0];
        else
        	claims{b,:} = ["Name" + b ,1];
        	testData{b,:} = ["Name" + b, a , a , a*2,1];
        end
    end
    a = c;
end
writetable(customerInformation);
writetable(claims);
writetable(testData);