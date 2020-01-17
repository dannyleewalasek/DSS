%{
This script is used to generate training and testing data.
%}
testData = table("Danny", 1,1,1,1);
testData.Properties.VariableNames = {'Name','Age','YearsNoClaims','CarPrice','ExpectedClass'};
claims = table("Danny", 0);
claims.Properties.VariableNames = {'Name','FraudDetected'};
customerInformation = table("Danny", 1, 1, 1);
customerInformation.Properties.VariableNames = {'Name','CarValue','Age','YearsNoClaims'};
a = 2;
while a < 900
    c = a * 2;
    for b = a:c
        if (a > 400)
            customerInformation{b,:} = ["Name" + b, a ,a ,a];
            claims{b,:} = ["Name" + b ,0];
            testData{b,:} = ["Name" + b, a  , a,a,0];
        else
            customerInformation{b,:} = ["Name" + b, a ,a ,a];
        	claims{b,:} = ["Name" + b ,1];
        	testData{b,:} = ["Name" + b, a  , a , a,1];
        end
    end
    a = c;
end
writetable(customerInformation);
writetable(claims);
writetable(testData);