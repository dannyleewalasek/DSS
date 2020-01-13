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
burglaryProbabilities = readtable('burglaryProbabilities');
burglaryProbabilities = table2array(burglaryProbabilities);
indexProbabilities = readtable('indexProbabilities');
indexProbabilities = table2array(indexProbabilities);
burglaryOnly{:,3} = 0;
a = 1;

% Create confusion matrix TP | FP
%                         FN | TN
confusionMatrix = [0,0;
                    0,0];

%count number of burglarys per postcode
while a < height(testdata)
    count = 0;
    for b = 1:height(testdata)
        if isequal(testdata(a,1),testdata(b,1))
            count = count + 1;
            disp("testing: " + a + "with: " + b + " " +count);
            testdata{a,3} = count;
        end
    end
    a = a + count+1;
    count = 0;
end

testdata = unique(testdata);
testdata(testdata.Burglarys == 0, :) = [];

% Check each item in the test data to see which class it belongs to by
% checking them against the K cluster positions using euclidean distance
for c = 1:height(testdata)
    minDistance = 99999999999999999999999999;
    for d = 1:size(clusterPositions)
        if sqrt((clusterPositions{d,1} - testdata(c,:).Burglarys).^2 + (clusterPositions{d,2} - testdata(c,:).index).^2) < minDistance
            testdata(c,:).ActualClass = d;
            minDistance = sqrt((clusterPositions{d,1} - testdata(c,:).Burglarys).^2 + (clusterPositions{d,2} - testdata(c,:).index).^2);
        end
    end
end

% Plot the test data in yellow
for a = 1:height(testdata)
        plot(testdata(a,:).Burglarys, testdata(a,:).index,'yo','MarkerSize',5);
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
    if ~isnan(testdata(a,:).Burglarys)
        for b = 1:3
            if testdata(a,:).Burglarys <= burglaryProbabilities(b,1)
                for c = 2:4
                        pclass(c-1) = burglaryProbabilities(b,c);
                end
                break;
            end
        end
    end
    class = 0;
    if ~isnan(testdata(a,:).index)
       for b = 1:3
            if testdata(a,:).index <= indexProbabilities(b,1)
                for c = 2:4
                        pclass(c-1) = pclass(c-1) + indexProbabilities(b,c);
                end
                break;
            end
        end
    end
    for d = 1:3
        if pclass(1,d) > pclass(1,highest)
            highest = d;
        end
    end
    if testdata(a,:).ActualClass == highest
        correct = correct + 1;
    else
        incorrect = incorrect + 1;
    end
end
x = ["Correct" "Incorrect"];
y = [correct incorrect];
bar(1,2);