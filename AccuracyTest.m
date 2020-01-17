%{
This script is used to test the accuracy of the model obtained in the
modeltraining script. If the model obtains over a certain percentage of
passes in the confusion matrix it is accepted as a sound model.
%}
clear;

% Import all data needed and convert them to arrays to make them easier to
% handle.
testdata = readtable('testData.txt');
ageProbabilities = readtable('ageProbabilities');
ageProbabilities = table2array(ageProbabilities);
yearsNoClaimsProbabilities = readtable('yearsNoClaimsProbabilities');
yearsNoClaimsProbabilities = table2array(yearsNoClaimsProbabilities);
priceProbabilities = readtable('priceProbabilities');
priceProbabilities = table2array(priceProbabilities);
% Create confusion matrix TP | FP
%                         FN | TN
confusionMatrix = [0,0;
                    0,0];

testdata = unique(testdata);

% Accuracy test using confusion matrix
incorrect = 0;
correct = 0;
currentProbability = 0;

for a = 1:height(testdata)
    highest = 1;
	pclass = [0,0];
	bottomHalf = 0;
    
    % Calculate the probability for each classicaition for the Age range of the input.
    for b = 1:size(ageProbabilities,1)
        if testdata(a,:).Age <= ageProbabilities(b,1)
            for c = 2:3
                pclass(c-1) = ageProbabilities(b,c) * (ageProbabilities(5,c) / ageProbabilities(5,4));
            end
            bottomHalf = bottomHalf + ageProbabilities(b,5);
            break;
        end
    end
    
    % Calculate the probability for each classicaition for the price range of the input.
    for b = 1:size(priceProbabilities,1)
        if testdata(a,:).CarPrice <= priceProbabilities(b,1)
            for c = 2:3
                pclass(c-1) = pclass(c-1) + priceProbabilities(b,c) * (priceProbabilities(5,c) / priceProbabilities(5,4));
            end
            bottomHalf = bottomHalf + priceProbabilities(b,5);
            break;
        end
    end

    % Calculate the probability for each classicaition for the years no claims range of the input.
    for b = 1:size(yearsNoClaimsProbabilities,1)
        if testdata(a,:).YearsNoClaims <= yearsNoClaimsProbabilities(b,1)
            for c = 2:3
                pclass(c-1) = pclass(c-1) + yearsNoClaimsProbabilities(b,c) * (yearsNoClaimsProbabilities(5,c) / yearsNoClaimsProbabilities(5,4));
            end
            bottomHalf = bottomHalf + yearsNoClaimsProbabilities(b,5);
            break;
        end
    end

    % Final part of Naive Bayes formula to give a percentage to each
    % possible outcome.
    for d = 1:2
        pclass(1,d) =  pclass(1,d) / bottomHalf;
    end

    for d = 1:2
        if pclass(1,d) > pclass(1,highest)
            highest = d;
        end
    end
    % Update appropriate fields in the confusion matrix.
    if testdata(a,:).ExpectedClass == highest - 1
        correct = correct + 1;
        confusionMatrix(1,1) = confusionMatrix(1,1) + 1; % Correct positives
        confusionMatrix(2,2) = confusionMatrix(2,2) + 1; % correct negatives   
    else
        incorrect = incorrect + 1;
        confusionMatrix(1,2) = confusionMatrix(1,2) + 1; % False positives
        confusionMatrix(2,1) = confusionMatrix(2,1) + 1; % False negatives
    end
end

%Save confusion matrix for later use in visual script.
writematrix(confusionMatrix);

% Calculate model accuracy
matrixAccuracy =(confusionMatrix(1,1) + confusionMatrix(2,2)) / (confusionMatrix(1,1) + confusionMatrix(2,2) + confusionMatrix(1,2) + confusionMatrix(2,1));


% Display confusion matrix
f = figure;
uit = uitable(f,'Data',confusionMatrix,'Position',[20 20 200 100]);
uit.ColumnName = {'+','-'};
uit.ColumnEditable = true;
uit.RowName = {'+','-'};

% Display model accuracy
disp("The accuracy of the model has been calculated at: " + matrixAccuracy * 100 + "%");