%Write a confusion matrix test
%Create test data
% POSTCODE | INDEX | ACTUAL CLASS

% RUN NAIVE BAYES WITH TEST DATA, COMPARE OUTCOME AGAINST ACTUAL CLASS

testdata = readtable('testdata.xlsx');
burglaryProbabilities = readtable('burglaryProbabilities');

% Accuracy test against burglary numbers
incorrect = 0;
correct = 0;
class = 1;
currentProbability = 0;
for a = 1:height(testdata)
    for b = 1:4
        if  b == 4
            class = 4;
        elseif b == 1
            currentProbability = burglaryProbabilities(b,:).Class1;
        elseif testdata(a,:).index <= burglaryProbabilities(b,:).Range
            for c = 2:5
                if burglaryProbabilities(b,c) > currentProbability
                    currentProbability = burglaryProbabilities(b,c);
                    class = c;
                end
            end
        end
    end
    if class == testdata(a,:).ActualClass
        correct = correct +1;
    else
        incorrect = correct +1;
    end
end