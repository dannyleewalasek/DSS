%{
This script is used to create and train a model using data from the
preperation stage and outputting a number of probability tables and
clustering points.
%}
clear;
trainingData = readtable('trainingData');

% -----------------Probability calculation -------------------

% Set ranges in new array to be used for probabilities
maxYearsNoClaims = max(trainingData.YearsNoClaims);
maxAge = max(trainingData.Age);
maxCarPrice = max(trainingData.CarValue);
age = []; %burg
price = [];
age(1:5,1:5) = 0;
price(1:5,1:5) = 0;
claims = [0,0,0,0,0;1,0,0,0,0;2,0,0,0,0;3,0,0,0,0;4,0,0,0,0;5,0,0,0,0;0,0,0,0,0;];
for e = 1:4
    age(e,1) = maxAge/4 * e;
    price(e,1) = maxCarPrice/4 * e;
end


% Calcualte probabilites
for f = 1:height(trainingData)
    for g = 1:4
        if (trainingData(f,:).Age <= age(g,1))
            if trainingData(f,:).FraudDetected == 0
                age(g,3) = age(g,3) + 1;
                age(5,3) = age(5,3)+1;
            else
                age(g,2) = age(g,2) + 1;
                age(5,2) = age(5,2)+1;
            end
            age(g,4) = age(g,4)+1; 
        end
    end
end

for f = 1:height(trainingData)
    for g = 1:4
        if (trainingData(f,:).CarValue <= price(g,1))
            if trainingData(f,:).FraudDetected == 0
                price(g,3) = price(g,3) + 1;
                price(5,3) = price(5,3)+1;
            else
                price(g,2) = price(g,2) + 1;
                price(5,2) = price(5,2)+1;
            end
            price(g,4) = price(g,4)+1; 
        end
    end
end


age(5,4) = age(5,3) + age(5,2);

disp(age);

for a = 1:4
    age(a,5) = age(a,4)/age(5,4);
end

% calculate percentage of inner cells
for a = 1:size(age,1)-1
    for b = 2:3
        age(a,b) = age(a,b)/age(5,b);
    end
end


%{
% Calculate overall probability
for a = 1:size(claims,1)-1
    totalCol = 0;
        claims(7,2) = claims(7,2) + claims(a,2);
        claims(7,3) = claims(7,3) + claims(a,3);
	for b = 2:3
        claims(a,b) = claims(a,b)/claims(a,4);
	end
    total = 0;
    for b = 1:size(claims,1)
        total = total + claims(b,4);
    end
    claims(a,5) = claims(a,4)/total;
end
for a = 1:size(age,1)
    for b = 2:3
       age(a,b) = age(a,b)/age(a,4);
    end
    total = 0;
    for b = 1:size(age,1)
        total = total + age(b,4);
    end
    age(a,5) = age(a,4)/total;
end
for a = 1:size(price,1)
    for b = 2:3
       price(a,b) = price(a,b)/price(a,4);
    end
    total = 0;
    for b = 1:size(price,1)
        total = total + price(b,4);
    end
    price(a,5) = price(a,4)/total;
end
%}
names = ["Range", "Fraud", "NoFraud", "Total", "OverallLikelyhood"];

% Convert array to table and add headings
yearsNoClaimsProbabilities = array2table(claims,...
    'VariableNames',names);
ageProbabilities = array2table(age,...
    'VariableNames',names);
priceProbabilities = array2table(price,...
    'VariableNames',names);

% Save tables to file which make up our model
writetable(yearsNoClaimsProbabilities);
writetable(ageProbabilities);
writetable(priceProbabilities);

colours = ['r','g', 'b', 'c', 'm', 'y', 'k', 'm', 'y', 'k'];
for z = 1:height(trainingData)
        scatter3(trainingData(z,:).Age,trainingData(z,:).YearsNoClaims,trainingData(z,:).CarValue,10,colours(1,trainingData(z,:).FraudDetected + 1));
    hold on;
end

title('All Data');
xlabel('Age');
ylabel('Years No Claims');
zlabel('Car Value');

%{

% Save the training data
writetable(trainingData);

% Calculating probabilities
for h = 1:numK
    for i = 2:numK+1
        age(h,i) = age(h,i)/ age(h,numK+2);
        incidents(h,i) = incidents(h,i)/ incidents(h,numK+2);
        price(h,i) = price(h,i)/ price(h,numK+2);
    end
end

% Replace NAN's with equal value
for n = 1:numK
    for o = 2:numK+1
        if isnan(age(n,o))
            age(n,o) = 1/numK;
        end
        if isnan(incidents(n,o))
            incidents(n,o) = 1/numK;
        end
        if isnan(price(n,o))
            price(n,o) = 1/numK;
        end
    end
end

% Determine names for headings
names{1,1} = 'Range';
for a = 2:numK + 1
    names{1,a} = strcat('class ', num2str(a-1));
end
names{1,numK + 2} = 'total';



% Display results
disp("----------- Incident probabilities ----------- ");
disp(incidentProbabilities);
disp("----------- Age probabilities ----------- ");
disp(ageProbabilities);
disp("----------- Car Price probabilities ----------- ");
disp(priceProbabilities);

% Plot each data point colour coded by class
% Fix to allow for variable K

colours = ['r','g', 'b', 'c', 'm', 'y', 'k', 'm', 'y', 'k'];
for z = 1:height(trainingData)
        scatter3(trainingData(z,:).Age,trainingData(z,:).NumberOfIncidents,trainingData(z,:).CarPrice,10,colours(1,trainingData(z,:).class));
    hold on;
end

title('All Data');
xlabel('X');
ylabel('Y');
zlabel('Z');
%}