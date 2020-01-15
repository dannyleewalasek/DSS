%{
 Script used to analyse the generated clusters looking at average age, car
 price and number of incidents in a group.
%}

trainingData = readtable('trainingData');
clusterPositions = readtable('c.txt');

averages = [0,0,0,0,0]; % Class, Age, Car Price, Incidents, total
averages(1:height(clusterPositions),1:5) = 0;

for a = 1:height(trainingData)
    class = trainingData(a,:).class;
    averages(class,:) = [class, averages(class,2) + trainingData(a,:).Age, averages(class,3) + trainingData(a,:).CarPrice, averages(class,4) + trainingData(a,:).NumberOfIncidents, averages(class,5) + 1];
end

for a = 1:height(clusterPositions)
    for b = 2:4
        averages(a,b) = round(averages(a,b)/ averages(a,5));
    end
end

% Mapping Age against number of incidents
bar(averages(1:height(clusterPositions), 2:2:4));