%{
This script is used to test the accuracy of the model obtained in the
modeltraining script. If the model obtains over a certain percentage of
passes in the confusion matrix it is accepted as a sound model.
%}
clear;

% Import all data needed and convert them to arrays to make them easier to
% handle.
testdata = readtable('testData.txt');
clusterPositions = readtable('c.txt');
incidentProbabilities = readtable('incidentProbabilities');
incidentProbabilities = table2array(incidentProbabilities);
ageProbabilities = readtable('indexProbabilities');
ageProbabilities = table2array(ageProbabilities);
burglaryOnly{:,3} = 0;
a = 1;

% Create confusion matrix TP | FP
%                         FN | TN
confusionMatrix = [0,0;
                    0,0];
                
%count number of
while a < height(testdata)
    count = 0;
    for b = 1:height(testdata)
        if isequal(testdata(a,1),testdata(b,1))
            count = count + 1;
            testdata{a,3} = count;
        end
    end
    a = a + count+1;
    count = 0;
end

testdata = unique(testdata);
testdata(testdata.NumberOfIncidents == 0, :) = [];

% Check each item in the test data to see which class it belongs to by
% checking them against the K cluster positions using euclidean distance
% NEED TO MAKE 3D.
for c = 1:height(testdata)
    minDistance = 99999999999999999999999999;
    for d = 1:height(clusterPositions)
        if sqrt((clusterPositions{d,1} - testdata(c,:).NumberOfIncidents).^2 + (clusterPositions{d,2} - testdata(c,:).Age).^2) < minDistance
            testdata(c,:).ExpectedClass = d;
            minDistance = sqrt((clusterPositions{d,1} - testdata(c,:).NumberOfIncidents).^2 + (clusterPositions{d,2} - testdata(c,:).Age).^2);
        end
    end
end

% Plot the test data in yellow
for a = 1:height(testdata)
        plot(testdata(a,:).NumberOfIncidents, testdata(a,:).Age,'yo','MarkerSize',5);
        hold on;
end

% Accuracy test using confusion matrix
incorrect = 0;
correct = 0;
class = 1;
currentProbability = 0;
% !NEED TO STORE FOR EACH CLASS IF IT WAS A FALSE/TRUE POSITIVE OR NEGATIVE
for a = 1:height(testdata)
    highest = 1;
    pclass = [0,0,0,0];
	for b = 1:height(clusterPositions)
        if testdata(a,:).NumberOfIncidents <= incidentProbabilities(b,1)
            for c = 2:height(clusterPositions) + 1
                pclass(c-1) = incidentProbabilities(b,c);
            end
            break;
        end
	end
	for b = 1:height(clusterPositions)
        if testdata(a,:).Age <= ageProbabilities(b,1)
            for c = 2:height(clusterPositions) + 1
                pclass(c-1) = pclass(c-1) + ageProbabilities(b,c);
            end
        break;
        end
	end
    for d = 1:height(clusterPositions)
        if pclass(1,d) > pclass(1,highest)
            highest = d;
        end
    end
	if testdata(a,:).ExpectedClass == highest
        correct = correct + 1;
        confusionMatrix(1,1) = confusionMatrix(1,1) + 1; % Correct positives
        confusionMatrix(2,2) = confusionMatrix(2,2) + (height(clusterPositions) - 1); % correct negatives   
	else
        incorrect = incorrect + 1;
        confusionMatrix(1,2) = confusionMatrix(1,2) + 1; % False positives
        confusionMatrix(2,1) = confusionMatrix(2,1) + (height(clusterPositions) - 1); % False negatives
    end
end

matrixAccuracy =(confusionMatrix(1,1) + confusionMatrix(2,2)) / (confusionMatrix(1,1) + confusionMatrix(2,2) + confusionMatrix(1,2) + confusionMatrix(2,1));

disp("Model accuracy: " + matrixAccuracy);
disp(confusionMatrix);