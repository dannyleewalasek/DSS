%{
This script is used to create and train a model using data from the
preperation stage and outputting a number of probability tables and
clustering points.
%}
clear;
trainingData = readtable('meanIndexPerPostcode');
trainingData.class(:,:) = zeros();

% Run Kmeans
[idx,C]  = kmeans(table2array(trainingData),4);

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

% -----------------Burglary class probabilities -------------------
% Set ranges in new array to be used for probabilities
maxBurglarys = max(trainingData.Count);
burg = [0,0,0,0,0,0;];
for e = 1:4
    burg(e,1) = maxBurglarys/4 * e;
end

% Counting number of classes in each range
for f = 1:height(trainingData)
    for g = 1:4
        if (trainingData(f,:).Count <= burg(g,1))
            burg(g,trainingData(f,:).class +1 ) = burg(g,trainingData(f,:).class + 1) + 1;
            burg(g,6) = burg(g,6)+1;
            break;
        end
    end
end

writetable(trainingData);

% Calculating probabilities
for h = 1:4
    for i = 2:5
        burg(h,i) = burg(h,i)/ burg(h,6);
    end
end

% -----------------Wealth index class probabilities -------------------
% Set ranges in new array to be used for probabilities
maxIndex = max(trainingData.index);
index = [0,0,0,0,0,0;];
for j = 1:4
    index(j,1) = maxIndex/4 * j;
end

% Counting number of classes in each range
for k = 1:height(trainingData)
    for l = 1:4
        if (trainingData(k,:).index <= index(l,1))
            index(l,trainingData(k,:).class +1 ) = index(l,trainingData(k,:).class + 1) + 1;
            index(l,6) = index(l,6)+1;
            break;
        end
    end
end

% Calculating probabilities
for l = 1:4
    for m = 2:5
        index(l,m) = index(l,m)/ index(l,6);
    end
end

% Replace NAN's with 0.25, this is because they only appear in a row with
% all NaN's
for n = 1:4
    for o = 2:6
        if isnan(burg(n,o))
            burg(n,o) = 0.25;
        end
        if isnan(index(n,o))
            index(n,o) = 0.25;
        end
    end
end

% Convert array to table and add headings
burglaryProbabilities = array2table(burg,...
    'VariableNames',{'Range' 'Class 1' 'Class 2' 'Class 3' 'Class 4' 'total'});
indexProbabilities = array2table(index,...
    'VariableNames',{'Range' 'Class 1' 'Class 2' 'Class 3' 'Class 4' 'total'});

% Save tables to file which make up our model
writetable(burglaryProbabilities);
writetable(indexProbabilities);

% Display results
disp("----------- Burglary probabilities ----------- ");
disp(burglaryProbabilities);
disp("----------- Index probabilities ----------- ");
disp(indexProbabilities);

for z = 1:height(trainingData)
    if trainingData(z,:).class == 1
        plot(trainingData(z,:).Count, trainingData(z,:).index,'bo','MarkerSize',5);
    elseif trainingData(z,:).class == 2
        plot(trainingData(z,:).Count, trainingData(z,:).index,'go','MarkerSize',5);
    elseif trainingData(z,:).class == 3
        plot(trainingData(z,:).Count, trainingData(z,:).index,'ro','MarkerSize',5);
    elseif trainingData(z,:).class == 3
        plot(trainingData(z,:).Count, trainingData(z,:).index,'co','MarkerSize',5);
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
plot(C(4,1),C(4,2),'c*','MarkerSize',5);
    hold on;
%FREQUENCY TABLE CREATION TO BE USED WITH NAIVE BAYES 
%Save training data with class identification
%Save frequency table
%These make the model.
