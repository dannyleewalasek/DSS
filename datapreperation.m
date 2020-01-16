%{
This script is used to prepare data on fraudulant claims and on customers
account information for use in the model training stage.
%}

% Load data
claims = readtable('claims.txt');
customerInformation = readtable('customerInformation.txt');

% Join the data
trainingData = innerjoin(claims,customerInformation,'Keys','Name');

trainingData = unique(trainingData);

trainingData.Name = [];

trainingData = rmmissing(trainingData);

writetable(trainingData);


%{
% Data Consolidation

%count number incidents per name
incidentData{:,4} = 0;
a = 1;
while a < height(incidentData)
    count = 0;
    for b = 1:height(incidentData)
        if isequal(incidentData(a,1),incidentData(b,1))
            count = count + 1;
            incidentData{a,4} = count;
        end
    end
    a = a + count+1;
    count = 0;
end

incidentData = unique(incidentData);

incidentData(incidentData.Var4 == 0, :) = [];

carSales = unique(carSales);
trainingData = innerjoin(carSales,incidentData);
trainingData.Properties.VariableNames = {'Name','CarPrice','IncidentDate','Age','NumberOfIncidents'};
% Data Cleaning

% Remove Null values
%consolidatedData = rmmissing(consolidatedData);

% Data Reduction

% Remove duplicates

trainingData = unique(trainingData);

trainingData.Name = [];
trainingData.IncidentDate = [];

% Save output
writetable(trainingData);
%}