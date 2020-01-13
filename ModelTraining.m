%{
This script is used to create and train a model using data from the
preperation stage and outputting a number of probability tables and
clustering points.
%}
clear;
trainingData = readtable('meanIndexPerPostcode');
trainingData.class(:,:) = zeros();

% Run Kmeans
[idx,C]  = kmeans(table2array(trainingData),3);

% Save cluster positions
writematrix(C);

%Determine class of each point using euclidean formula.
for c = 1:height(trainingData)
    minDistance = 99999999999999999999999999;
    for d = 1:size(C)
        if sqrt((C(d,1) - trainingData(c,:).Count).^2 + (C(d,2) - trainingData(c,:).index).^2) < minDistance
            trainingData(c,:).class = d;
            minDistance = sqrt((C(d,1) - trainingData(c,:).Count).^2 + (C(d,2) - trainingData(c,:).index).^2);
        end
    end
end

% -----------------Probability calculation -------------------

% Set ranges in new array to be used for probabilities
maxIndex = max(trainingData.index);
maxBurglarys = max(trainingData.Count);
index = [0,0,0,0,0;];
burg = [0,0,0,0,0;];
for e = 1:3
    burg(e,1) = maxBurglarys/3 * e;
    index(e,1) = maxIndex/3 * e;
end

% Counting number of classes in each range
for f = 1:height(trainingData)
    for g = 1:3
        if (trainingData(f,:).Count <= burg(g,1))
            burg(g,trainingData(f,:).class +1 ) = burg(g,trainingData(f,:).class + 1) + 1;
            burg(g,5) = burg(g,5)+1;
            break;
        end
        if (trainingData(f,:).index <= index(g,1))
            index(l,trainingData(f,:).class +1 ) = index(l,trainingData(f,:).class + 1) + 1;
            index(f,5) = index(f,5)+1;
            break;
        end
    end
end

% Save the training data
writetable(trainingData);

% Calculating probabilities
for h = 1:3
    for i = 2:4
        burg(h,i) = burg(h,i)/ burg(h,5);
        index(h,i) = index(h,i)/ index(h,5);
    end
end

% Replace NAN's with 0.3's, this is because they only appear in a row with
% all NaN's
for n = 1:3
    for o = 2:4
        if isnan(burg(n,o))
            burg(n,o) = 0.333;
        end
        if isnan(index(n,o))
            index(n,o) = 0.333;
        end
    end
end

% Convert array to table and add headings
burglaryProbabilities = array2table(burg,...
    'VariableNames',{'Range' 'Class1' 'Class2' 'Class3' 'total'});
indexProbabilities = array2table(index,...
    'VariableNames',{'Range' 'Class1' 'Class2' 'Class3' 'total'});

% Save tables to file which make up our model
writetable(burglaryProbabilities);
writetable(indexProbabilities);

% Display results
disp("----------- Burglary probabilities ----------- ");
disp(burglaryProbabilities);
disp("----------- Index probabilities ----------- ");
disp(indexProbabilities);

% Plot each data point colour coded by class
for z = 1:height(trainingData)
    if trainingData(z,:).class == 1
        plot(trainingData(z,:).Count, trainingData(z,:).index,'bo','MarkerSize',5);
    elseif trainingData(z,:).class == 2
        plot(trainingData(z,:).Count, trainingData(z,:).index,'go','MarkerSize',5);
    elseif trainingData(z,:).class == 3
        plot(trainingData(z,:).Count, trainingData(z,:).index,'ro','MarkerSize',5);
    end
    hold on;
end

% Plot of Kmeans points
plot(C(1,1),C(1,2),'b*','MarkerSize',5);
    hold on;
plot(C(2,1),C(2,2),'g*','MarkerSize',5);
    hold on;
plot(C(3,1),C(3,2),'r*','MarkerSize',5);
    hold on;