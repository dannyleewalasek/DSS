%{
This script is used to prepare data on fraudulant claims and on customers
account information for use in the model training stage.
%}

% Load data from file.
claims = readtable('claims.txt');
customerInformation = readtable('customerInformation.txt');

% Join the data by "Name".
trainingData = innerjoin(claims,customerInformation,'Keys','Name');

% Ensure there are no duplicate rows.
trainingData = unique(trainingData);

% Remove the name column from the data as this will no longer be needed.
trainingData.Name = [];

% Remove any rows with null values.
trainingData = rmmissing(trainingData);

% Write the table out to file.
writetable(trainingData);