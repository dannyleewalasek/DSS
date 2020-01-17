%{
This script is used to classify new inputs into the system into one of the
classes defined dureing the model stage.
%}

ageProbabilities = readtable('ageProbabilities');
ageProbabilities = table2array(ageProbabilities);
yearsNoClaimsProbabilites = readtable('yearsNoClaimsProbabilities');
yearsNoClaimsProbabilites = table2array(yearsNoClaimsProbabilites);
priceProbabilities = readtable('priceProbabilities');
priceProbabilities = table2array(priceProbabilities);

trainingData = readtable('trainingData');

input = [516 ,500,200];

label = predict(Mdl,input(1,2));
disp(label);

currentProbability = 0;
opposite = 1;

    highest = 1;
    pclass = [0,0];
    totalToDivideBy = 0;
    bottomHalf = 0;
	for b = 1:size(ageProbabilities,1)
        if input(1,1) <= ageProbabilities(b,1)
            for c = 2:3
                pclass(c-1) = ageProbabilities(b,c) * (ageProbabilities(5,c) / ageProbabilities(5,4));
                disp(c + ": " + ageProbabilities(b,c) / ageProbabilities(5,c) + " * " );
            end
            bottomHalf = bottomHalf + ageProbabilities(b,5);
            break;
        end
    end
    
	for b = 1:size(priceProbabilities,1)
        if input(1,2) <= ageProbabilities(b,1)
            for c = 2:3
                pclass(c-1) = pclass(c-1) + priceProbabilities(b,c) * (priceProbabilities(5,c) / priceProbabilities(5,4));
                disp(c + ": " + priceProbabilities(b,c) / priceProbabilities(5,c) + " * " );
            end
            bottomHalf = bottomHalf + priceProbabilities(b,5);
            break;
        end
    end

    for d = 1:2
        if pclass(1,d) > pclass(1,highest)
            highest = d;
            if highest == 1
                oppposite = 2;
            else
                opposite = 1;
            end
        end
    end
    topHalf = pclass(1,highest);
    total = topHalf/bottomHalf;
    disp("There is a "+ total * 100 + "% chance of being fraudulant or not fraudulant");