%{
This script is used to generate training and testing data.
The script creates data with a forced pattern just to allow the system to
show it is able to accurately spot and use this pattern. Any real world
data would also be able to be inserted if it was available.
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
            customerInformation{height(customerInformation)+1,:} = ["Name" + a,a * (1 + randi(a)),17 + a ,round(a/10)];
            claims{height(claims)+1,:} = ["Name" + a ,0];
            testData{height(testData)+1,:} = ["Name" + a,17 + a  , round(a/10),a * randi(1000),0];
        else
            customerInformation{height(customerInformation)+1,:} = ["Name" + a,  a * (1 + randi(a)) ,17 + a ,round(a/10)];
            claims{height(claims)+1,:} = ["Name" + a ,1];
            testData{height(testData)+1,:} = ["Name" + a,17 + a  , round(a/10),a * randi(1000),1];
        end
    end
end

% Finally write the tables out to file for later use.
writetable(customerInformation);
writetable(claims);
writetable(testData);