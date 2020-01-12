%{
This script is used to test the accuracy of the model obtained in the
modeltraining script. If the model obtains over a certain percentage of
passes in the confusion matrix it is accepted as a sound model.
%}
clear;

% Import all data needed and convert them to arrays to make them easier to
% handle.
createtestdata;
testdata = readtable('testdata.txt');
clusterPositions = readtable('c.txt');
burglaryProbabilities = readtable('burglaryProbabilities');
burglaryProbabilities = table2array(burglaryProbabilities);
indexProbabilities = readtable('indexProbabilities');
indexProbabilities = table2array(indexProbabilities);

% Check each item in the test data to see which class it belongs to by
% checking them against the K cluster positions
%Determine class of each point using euclidean formula.
for c = 1:height(testdata)
    minDistance = 99999999999999999999999999;
    for d = 1:size(clusterPositions)
        if sqrt((clusterPositions{d,1} - testdata(c,:).Burglarys).^2 + (clusterPositions{d,2} - testdata(c,:).index).^2) < minDistance
            testdata(c,:).ActualClass = d;
            minDistance = sqrt((clusterPositions{d,1} - testdata(c,:).Burglarys).^2 + (clusterPositions{d,2} - testdata(c,:).index).^2);
        end
    end
end

% Now attempt to test each against the model using only either burg number
% or index.

% Accuracy test against burglary numbers
bincorrect = 0;
bcorrect = 0;
iincorrect = 0;
icorrect = 0;
class = 1;
currentProbability = 0;
% !NEED TO STORE FOR EACH CLASS IF IT WAS A FALSE/TRUE POSITIVE OR NEGATIVE
for a = 1:height(testdata)
    if ~isnan(testdata(a,:).Burglarys)
        for b = 1:4
            if  b == 4
                class = 4;
            elseif b == 1
                currentProbability = burglaryProbabilities(b,2);
            elseif testdata(a,:).Burglarys <= burglaryProbabilities(b,1)
                for c = 2:5
                    if burglaryProbabilities(b,c) > currentProbability
                        currentProbability = burglaryProbabilities(b,c);
                        class = c;
                    end
                end
                break;
            end
        end
        % DO STORING OF FP ETC VALUES IN MATRIX HERE
             if class == testdata(a,:).ActualClass
                bcorrect = bcorrect +1;
             else
                bincorrect = bincorrect +1;
            end
    end
    if ~isnan(testdata(a,:).index)
            for b = 1:4
                if  b == 4
                  class = 4;
                elseif b == 1
                    currentProbability = indexProbabilities(b,2);
                elseif testdata(a,:).index <= indexProbabilities(b,1)
                    for c = 2:5
                        if indexProbabilities(b,c) > currentProbability
                            currentProbability = indexProbabilities(b,c);
                            class = c;
                        end
                    end
                end
            end
            if class == testdata(a,:).ActualClass
                icorrect = icorrect +1;
            else
                iincorrect = iincorrect +1;
            end
    end
end

bar(categorical({'BCorrect','BIncorrect','ICorrect','IIncorrect'}),[bcorrect, bincorrect,icorrect, iincorrect]);