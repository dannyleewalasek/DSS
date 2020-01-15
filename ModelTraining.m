%{
This script is used to create and train a model using data from the
preperation stage and outputting a number of probability tables and
clustering points.
%}
clear;
trainingData = readtable('trainingData');
trainingData.class(:,:) = zeros();

% Intra cluster testing
% Decide number of clusters. this will be decided algortihmically
eva = evalclusters(table2array(trainingData),'kmeans','CalinskiHarabasz','KList',[1:10]);
numK = eva.OptimalK;

% Run Kmeans
[idx,C]  = kmeans(table2array(trainingData),numK);

% Save cluster positions
writematrix(C);



%Set class of each point
for c = 1:height(trainingData)
    minDistance = 99999999999999999999999999;
    for d = 1:size(C)
        if sqrt((C(d,1) - trainingData(c,:).NumberOfIncidents).^2 + (C(d,2) - trainingData(c,:).index).^2) < minDistance
            trainingData(c,:).class = d;
            minDistance = sqrt((C(d,1) - trainingData(c,:).NumberOfIncidents).^2 + (C(d,2) - trainingData(c,:).index).^2);
        end
    end
end

% -----------------Probability calculation -------------------

% Set ranges in new array to be used for probabilities
maxIndex = max(trainingData.index);
maxBurglarys = max(trainingData.Count);
index = [];
burg = [];
index(1,1:numK+2) = 0; % these will have to allow for k other than 3.
burg(1,1:numK+2) = 0;
for e = 1:numK
    burg(e,1) = maxBurglarys/numK * e;
    index(e,1) = maxIndex/numK * e;
end

% Counting number of classes in each range
for f = 1:height(trainingData)
    for g = 1:numK
        if (trainingData(f,:).Count <= burg(g,1))
            burg(g,trainingData(f,:).class +1 ) = burg(g,trainingData(f,:).class + 1) + 1;
            burg(g,numK+2) = burg(g,numK+2)+1; 
        end
        if (trainingData(f,:).index <= index(g,1))
            index(g,trainingData(f,:).class +1 ) = index(g,trainingData(f,:).class + 1) + 1;
            index(g,numK+2) = index(g,numK+2)+1;
        end
    end
end

% Save the training data
writetable(trainingData);

% Calculating probabilities
for h = 1:numK
    for i = 2:numK+1
        burg(h,i) = burg(h,i)/ burg(h,numK+2);
        index(h,i) = index(h,i)/ index(h,numK+2);
    end
end

% Replace NAN's with equal value
for n = 1:numK
    for o = 2:numK+1
        if isnan(burg(n,o))
            burg(n,o) = 1/numK;
        end
        if isnan(index(n,o))
            index(n,o) = 1/numK;
        end
    end
end

% Determine names for headings
names{1,1} = 'Range';
for a = 2:numK + 1
    names{1,a} = strcat('class ', num2str(a-1));
end
names{1,numK + 2} = 'total';

% Convert array to table and add headings
indexProbabilities = array2table(index,...
    'VariableNames',names);
burglaryProbabilities = array2table(burg,...
    'VariableNames',names);

% Save tables to file which make up our model
writetable(burglaryProbabilities);
writetable(indexProbabilities);

% Display results
disp("----------- Burglary probabilities ----------- ");
disp(burglaryProbabilities);
disp("----------- Index probabilities ----------- ");
disp(indexProbabilities);

% Plot each data point colour coded by class
% Fix to allow for variable K
for z = 1:height(trainingData)
        plot(trainingData(z,:).Count, trainingData(z,:).index,'go','MarkerSize',5);
    hold on;
end

% Plot of Kmeans points
for a = 1:size(C)
plot(C(a,1),C(a,2),'b*','MarkerSize',5);
end