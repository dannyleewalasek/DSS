%Write a confusion matrix test
%Create test data
% POSTCODE | INDEX | ACTUAL CLASS

% RUN NAIVE BAYES WITH TEST DATA, COMPARE OUTCOME AGAINST ACTUAL CLASS

testdata = readtable('testdata.xlsx');
burglaryProbabilities = readtable('burglaryProbabilities');
indexProbabilities = readtable('indexProbabilities');

% Accuracy test against burglary numbers
bincorrect = 0;
bcorrect = 0;
iincorrect = 0;
icorrect = 0;
class = 1;
currentProbability = 0;
for a = 1:height(testdata)
    if ~isnan(testdata(a,:).Burglarys)
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
                bcorrect = bcorrect +1;
             else
                bincorrect = bincorrect +1;
            end
    else
            for b = 1:4
                if  b == 4
                  class = 4;
                elseif b == 1
                    currentProbability = indexProbabilities(b,:).Class1;
                elseif testdata(a,:).index <= indexProbabilities(b,:).Range
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
clear;