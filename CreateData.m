%{
This script is used to generate training and testing data.
%}

% Create tables used to store generated data.
testData = table("Danny", 1,1,1,1);
testData.Properties.VariableNames = {'Name','Age','YearsNoClaims','CarPrice','ExpectedClass'};
claims = table("Danny", 0);
claims.Properties.VariableNames = {'Name','FraudDetected'};
customerInformation = table("Danny", 1, 1, 1);
customerInformation.Properties.VariableNames = {'Name','CarValue','Age','YearsNoClaims'};

% Fill tables with data, data employs some randomness but also inserts a
% level of pattern into the data to help check the system correctly detects
% and uses this information.
for a = 1:100
    for b = 1:randi(10)
        if a < 50
            customerInformation{height(customerInformation)+1,:} = ["Name" + a,  a ,a ,a];
            claims{height(claims)+1,:} = ["Name" + a ,0];
            testData{height(testData)+1,:} = ["Name" + a,a  , a,a,0];
        else
            customerInformation{height(customerInformation)+1,:} = ["Name" + a, a ,a ,a];
            claims{height(claims)+1,:} = ["Name" + a ,1];
            testData{height(testData)+1,:} = ["Name" + a, a  , a,a,1];
        end
    end
end

% Finally write the tables out to file for later use.
writetable(customerInformation);
writetable(claims);
writetable(testData);