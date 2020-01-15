%{
This script is used to prepare data on burglarys and on postcode wealth
fopr use in the model training stage.
%}
clear;
% Load data
carSales = readtable('carSales.txt');
incidentData = readtable('incidentData.txt');

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