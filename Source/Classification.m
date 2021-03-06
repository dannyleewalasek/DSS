%{
This script is used to classify new inputs into the system into one of the
classes defined dureing the model stage.
%}

% Load in all probability tables and convert to arrays for easier
% manipulation.
ageProbabilities = readtable('ageProbabilities');
ageProbabilities = table2array(ageProbabilities);
yearsNoClaimsProbabilities = readtable('yearsNoClaimsProbabilities');
yearsNoClaimsProbabilities = table2array(yearsNoClaimsProbabilities);
priceProbabilities = readtable('priceProbabilities');
priceProbabilities = table2array(priceProbabilities);

% This is the input to the system to be analysed for probability of fraud.
input = [20,22,20]; %age, price, years.

pclass = [0,0]; %Used for naive Bayes calculations.
totalToDivideBy = 0; %Used for naive Bayes calculations.
bottomHalf = 0; %Used for naive Bayes calculations.

% Calculate age probabilities.
for b = 1:size(ageProbabilities,1)
    if input(1,1) <= ageProbabilities(b,1)
        for c = 2:3
            pclass(c-1) = ageProbabilities(b,c) * (ageProbabilities(5,c) / ageProbabilities(5,4));
        end
        bottomHalf = bottomHalf + ageProbabilities(b,5);
        break;
    end
end

% Calculate car value probabilities.
for b = 1:size(priceProbabilities,1)
    if input(1,2) <= priceProbabilities(b,1)
        for c = 2:3
            pclass(c-1) = pclass(c-1) + priceProbabilities(b,c) * (priceProbabilities(5,c) / priceProbabilities(5,4));
        end
        bottomHalf = bottomHalf + priceProbabilities(b,5);
        break;
    end
end

% Calculate years no claims probabilities.
for b = 1:size(yearsNoClaimsProbabilities,1)
    if input(1,3) <= yearsNoClaimsProbabilities(b,1)
        for c = 2:3
            pclass(c-1) = pclass(c-1) + yearsNoClaimsProbabilities(b,c) * (yearsNoClaimsProbabilities(5,c) / yearsNoClaimsProbabilities(5,4));
        end
        bottomHalf = bottomHalf + yearsNoClaimsProbabilities(b,5);
        break;
    end
end

% Deteremine which class is most likely.
highest = 1;
for d = 1:2
    if pclass(1,d) > pclass(1,highest)
        highest = d;
    end
end

% Calculate final percentage chance of being a specific class.
topHalf = pclass(1,highest);
total = topHalf/bottomHalf;

% Display the results to the user.
if highest == 2
    outcome = "Fraudulant";
else
    outcome = "Not Fraudulant";
end
disp("There is a "+ total * 100 + "% chance of being " + outcome);