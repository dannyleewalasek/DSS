%{
This script is used to create and train a model using data from the
preperation stage and outputting a number of probability tables and
clustering points.
%}
clear;
trainingData = readtable('trainingData');

% Set ranges in new array to be used for probabilities.
maxYearsNoClaims = max(trainingData.YearsNoClaims);
maxAge = max(trainingData.Age);
maxCarPrice = max(trainingData.CarValue);
age = [];
price = [];
age(1:5,1:5) = 0;
price(1:5,1:5) = 0;
claims(1:5,1:5) = 0;
for e = 1:4
    age(e,1) = maxAge/4 * e;
    price(e,1) = maxCarPrice/4 * e;
    claims(e,1) = maxYearsNoClaims/4 * e;
end

% Sum up total number of fraud and no fraud outcomes for each pair.
for f = 1:height(trainingData)
    for g = 1:4
        if (trainingData(f,:).Age <= age(g,1))
            if trainingData(f,:).FraudDetected == 1
                age(g,3) = age(g,3) + 1;
                age(5,3) = age(5,3)+1;
            else
                age(g,2) = age(g,2) + 1;
                age(5,2) = age(5,2)+1;
            end
            age(g,4) = age(g,4)+1; 
        end
        if (trainingData(f,:).CarValue <= price(g,1))
            if trainingData(f,:).FraudDetected == 1
                price(g,3) = price(g,3) + 1;
                price(5,3) = price(5,3)+1;
            else
                price(g,2) = price(g,2) + 1;
                price(5,2) = price(5,2)+1;
            end
            price(g,4) = price(g,4)+1; 
        end
        if (trainingData(f,:).YearsNoClaims <= claims(g,1))
            if trainingData(f,:).FraudDetected == 1
                claims(g,3) = claims(g,3) + 1;
                claims(5,3) = claims(5,3)+1;
            else
                claims(g,2) = claims(g,2) + 1;
                claims(5,2) = claims(5,2)+1;
            end
            claims(g,4) = claims(g,4)+1; 
        end
    end
end

% Calculate total and probabilites for each row and column.
age(5,4) = age(5,3) + age(5,2);
price(5,4) = price(5,3) + price(5,2);
claims(5,4) = claims(5,3) + claims(5,2);
for a = 1:4
    age(a,5) = age(a,4)/age(5,4);
    price(a,5) = price(a,4)/price(5,4);
    claims(a,5) = claims(a,4)/claims(5,4);
end

% calculate percentages for each pair.
for a = 1:size(age,1)-1
    for b = 2:3
        age(a,b) = age(a,b)/age(5,b);
        claims(a,b) = claims(a,b)/claims(5,b);
        price(a,b) = price(a,b)/price(5,b);
    end
end

names = ["range","Fraud","NoFraud","Total","Probability"];

% Convert array to table and add headings.
yearsNoClaimsProbabilities = array2table(claims,...
    'VariableNames',names);
ageProbabilities = array2table(age,...
    'VariableNames',names);
priceProbabilities = array2table(price,...
    'VariableNames',names);

% Save tables to file which make up our model.
writetable(yearsNoClaimsProbabilities);
writetable(ageProbabilities);
writetable(priceProbabilities);
