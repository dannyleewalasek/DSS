trainingData = readtable('meanIndexPerPostcode');
trainingData.class(:,:) = zeros();

plot(trainingData.BurglaryCount, trainingData.Mean_Index,'ko','MarkerSize',5);
hold on;

% Run Kmeans
[idx,C]  = kmeans(table2array(trainingData),4);

%Plot of Kmeans points
plot(C(:,1),C(:,2),'b*','MarkerSize',5);

%Determine class of each point.
for c = 1:height(trainingData)
    minDistance = 99999999999999999999999999;
    for d = 1:size(C)
        if sqrt((C(d,1) - trainingData(c,:).BurglaryCount).^2 + (C(d,2) - trainingData(c,:).Mean_Index).^2) < minDistance
            trainingData(c,:).class = d;
            minDistance = sqrt((C(d,1) - trainingData(c,:).BurglaryCount).^2 + (C(d,2) - trainingData(c,:).Mean_Index).^2);
        end
    end
end

% -----------------Burglary class probabilities -------------------
% Set ranges in new array to be used for probabilities
maxBurglarys = max(trainingData.BurglaryCount);
burg = [0,0,0,0,0,0;];
for e = 1:4
    burg(e,1) = maxBurglarys/4 * e;
end

% Counting number of classes in each range
for f = 1:height(trainingData)
    for g = 1:4
        if (trainingData(f,:).BurglaryCount <= burg(g,1))
            burg(g,trainingData(f,:).class +1 ) = burg(g,trainingData(f,:).class + 1) + 1;
            burg(g,6) = burg(g,6)+1;
            break;
        end
    end
end

% Calculating probabilities
for h = 1:4
    for i = 2:5
        burg(h,i) = burg(h,i)/ burg(h,6);
    end
end

% -----------------Wealth index class probabilities -------------------
% Set ranges in new array to be used for probabilities
maxIndex = max(trainingData.Mean_Index);
index = [0,0,0,0,0,0;];
for j = 1:4
    index(j,1) = maxIndex/4 * j;
end

% Counting number of classes in each range
for k = 1:height(trainingData)
    for l = 1:4
        if (trainingData(k,:).Mean_Index <= index(l,1))
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

clear;

%FREQUENCY TABLE CREATION TO BE USED WITH NAIVE BAYES 
%Save training data with class identification
%Save frequency table
%These make the model.
