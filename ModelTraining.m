%{
This script is used to create and train a model using data from the
preperation stage and outputting a number of probability tables and
clustering points.
%}
clear;
trainingData = readtable('trainingData');
trainingData.class(:,:) = zeros();

% Intra cluster testing
% Decide number of clusters. this will be decided algortihmically
eva = evalclusters(table2array(trainingData),'kmeans','CalinskiHarabasz','KList',[1:10]);
numK = eva.OptimalK;

% Run Kmeans
[idx,C]  = kmeans(table2array(trainingData),numK);

% Save cluster positions
writematrix(C);

for c = 1:height(trainingData)
    trainingData(c,:).class = idx(c,1);
end

%Set class of each point
%{
for c = 1:height(trainingData)
    minDistance = 99999999999999999999999999;
    for d = 1:size(C)
        if sqrt((C(d,1) - trainingData(c,:).NumberOfIncidents).^2 + (C(d,2) - trainingData(c,:).index).^2) < minDistance
            trainingData(c,:).class = d;
            minDistance = sqrt((C(d,1) - trainingData(c,:).NumberOfIncidents).^2 + (C(d,2) - trainingData(c,:).index).^2);
        end
    end
end
%}

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
    end
end

% Save the training data
writetable(trainingData);

% Calculating probabilities
for h = 1:numK
    for i = 2:numK+1
        age(h,i) = age(h,i)/ age(h,numK+2);
        incidents(h,i) = incidents(h,i)/ incidents(h,numK+2);
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

% Save tables to file which make up our model
writetable(incidentProbabilities);
writetable(ageProbabilities);

% Display results
disp("----------- Incident probabilities ----------- ");
disp(incidentProbabilities);
disp("----------- Age probabilities ----------- ");
disp(ageProbabilities);

% Plot each data point colour coded by class
% Fix to allow for variable K
%{
for z = 1:height(trainingData)
        plot(trainingData(z,:).NumberOfIncidents, trainingData(z,:).Age,'go','MarkerSize',5);
    hold on;
end
%}

scatter3(trainingData(:,:).Age,trainingData(:,:).NumberOfIncidents,trainingData(:,:).CarPrice);

% Plot of Kmeans points
%{
for a = 1:size(C)
plot(C(a,1),C(a,2),'b*','MarkerSize',5);
end
%}