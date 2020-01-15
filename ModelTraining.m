%{
This script is used to create and train a model using data from the
preperation stage and outputting a number of probability tables and
clustering points.
%}
clear;
trainingData = readtable('trainingData');
trainingData.class(:,:) = zeros();
disp(trainingData);
kMeansData = trainingData(:,1:3);

% Intra cluster testing
% Decide number of clusters. this will be decided algortihmically
eva = evalclusters(table2array(kMeansData),'kmeans','CalinskiHarabasz','KList',[1:10]);
numK = eva.OptimalK;

% Run Kmeans
[idx,C]  = kmeans(table2array(kMeansData),numK);

% Save cluster positions
writematrix(C);

%Set class of each point

for c = 1:height(trainingData)
    trainingData(c,:).class = idx(c,1);
end

% -----------------Probability calculation -------------------

% Set ranges in new array to be used for probabilities
maxIncidents = max(trainingData.NumberOfIncidents);
maxAge = max(trainingData.Age);
maxCarPrice = max(trainingData.CarPrice);
incidents = []; %index
age = []; %burg
price = [];
incidents(1,1:numK+2) = 0; % these will have to allow for k other than 3.
age(1,1:numK+2) = 0;
price(1,1:numK+2) = 0;
for e = 1:numK
    age(e,1) = maxAge/numK * e;
    incidents(e,1) = maxIncidents/numK * e;
    price(e,1) = maxCarPrice/numK * e;
end

% Counting number of classes in each range
for f = 1:height(trainingData)
    for g = 1:numK
        if (trainingData(f,:).NumberOfIncidents <= incidents(g,1))
            incidents(g,trainingData(f,:).class +1 ) = incidents(g,trainingData(f,:).class + 1) + 1;
            incidents(g,numK+2) = incidents(g,numK+2)+1; 
        end
        if (trainingData(f,:).Age <= age(g,1))
            age(g,trainingData(f,:).class +1 ) = age(g,trainingData(f,:).class + 1) + 1;
            age(g,numK+2) = age(g,numK+2)+1;
        end
        if (trainingData(f,:).CarPrice <= price(g,1))
            price(g,trainingData(f,:).class +1 ) = price(g,trainingData(f,:).class + 1) + 1;
            price(g,numK+2) = age(g,numK+2)+1;
        end
    end
end

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

% Convert array to table and add headings
incidentProbabilities = array2table(incidents,...
    'VariableNames',names);
ageProbabilities = array2table(age,...
    'VariableNames',names);
priceProbabilities = array2table(price,...
    'VariableNames',names);

% Save tables to file which make up our model
writetable(incidentProbabilities);
writetable(ageProbabilities);
writetable(priceProbabilities);

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