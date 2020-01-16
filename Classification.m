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
Mdl = fitcnb(trainingData.Age,trainingData.FraudDetected,...
    'ClassNames',[1,0]);

isLabels1 = resubPredict(Mdl);
ConfusionMat1 = confusionchart(trainingData.FraudDetected,isLabels1);

input = [1,1,200];

label = predict(Mdl,input(1,2));
disp(label);

currentProbability = 0;
opposite = 1;

    highest = 2;
    pclass = [0,0];
    totalToDivideBy = 0;
	for b = 1:size(ageProbabilities,1)
        if input(1,1) <= ageProbabilities(b,1)
            for c = 2:3
                pclass(c-1) = ageProbabilities(b,c) / ageProbabilities(5,c);
                disp(c + ": " + ageProbabilities(b,c) / ageProbabilities(5,c) + " * " );
            end
            break;
        end
    end
	for e = 1:size(priceProbabilities,1)
        if input(1,1) <= priceProbabilities(e,1)
            for c = 2:3
                pclass(c-1) = priceProbabilities(b,c) / priceProbabilities(5,c);
                disp(c + ": " + priceProbabilities(b,c) / priceProbabilities(5,c) + " * " );
               % pclass(c-1) = pclass(c-1) * priceProbabilities(e,c) / priceProbabilities(5,c);
            end
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
    topHalf = pclass(1,highest) * (ageProbabilities(b,highest+1)/ ageProbabilities(5,highest+1)) ;
    bottomHalf = (ageProbabilities(5,highest+1) / ageProbabilities(5,opposite+1));
    total = topHalf/bottomHalf;
    disp(total);
    disp("predicated class: "+ (highest - 1));
    disp(ageProbabilities(5,opposite+1));