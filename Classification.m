%{
This script is used to classify new inputs into the system into one of the
classes defined dureing the model stage.
%}

ageProbabilities = readtable('ageProbabilities');
ageProbabilities = table2array(ageProbabilities);
yearsNoClaimsProbabilities = readtable('yearsNoClaimsProbabilities');
yearsNoClaimsProbabilities = table2array(yearsNoClaimsProbabilities);
priceProbabilities = readtable('priceProbabilities');
priceProbabilities = table2array(priceProbabilities);

trainingData = readtable('trainingData');
% age | price | years
input = [20,3200,20];

    highest = 1;
    pclass = [0,0];
    totalToDivideBy = 0;
    bottomHalf = 0;
	for b = 1:size(ageProbabilities,1)
        if input(1,1) <= ageProbabilities(b,1)
            for c = 2:3
                pclass(c-1) = ageProbabilities(b,c) * (ageProbabilities(5,c) / ageProbabilities(5,4));
                disp(ageProbabilities(b,c) * (ageProbabilities(5,c) / ageProbabilities(5,4)));
                disp("b: " + b);
                disp("c: " + c);
            end
            bottomHalf = bottomHalf + ageProbabilities(b,5);
            break;
        end
    end
    
	for b = 1:size(priceProbabilities,1)
        if input(1,2) <= priceProbabilities(b,1)
            for c = 2:3
                pclass(c-1) = pclass(c-1) + priceProbabilities(b,c) * (priceProbabilities(5,c) / priceProbabilities(5,4));
            end
            bottomHalf = bottomHalf + priceProbabilities(b,5);
            break;
        end
    end
    
	for b = 1:size(yearsNoClaimsProbabilities,1)
        if input(1,3) <= yearsNoClaimsProbabilities(b,1)
            for c = 2:3
                pclass(c-1) = pclass(c-1) + yearsNoClaimsProbabilities(b,c) * (yearsNoClaimsProbabilities(5,c) / yearsNoClaimsProbabilities(5,4));
            end
            bottomHalf = bottomHalf + yearsNoClaimsProbabilities(b,5);
            break;
        end
    end

    for d = 1:2
        if pclass(1,d) > pclass(1,highest)
            highest = d;
        end
    end
    
    topHalf = pclass(1,highest);
    total = topHalf/bottomHalf;
    if highest == 2
        outcome = "Fraudulant";
    else
        outcome = "Not Fraudulant";
    end
    disp("There is a "+ total * 100 + "% chance of being " + outcome);