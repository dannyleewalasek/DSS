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
        disp(sqrt((C(d,1) - trainingData(c,:).BurglaryCount).^2 + (C(d,2) - trainingData(c,:).Mean_Index).^2));
        if sqrt((C(d,1) - trainingData(c,:).BurglaryCount).^2 + (C(d,2) - trainingData(c,:).Mean_Index).^2) < minDistance
            trainingData(c,:).class = d;
            minDistance = sqrt((C(d,1) - trainingData(c,:).BurglaryCount).^2 + (C(d,2) - trainingData(c,:).Mean_Index).^2);
        end
    end
end

burg = [0,0,0,0,0;
        0,0,1,0,0;
        0,0,2,0,0;
        0,0,0,0,0];
for e = 1:4
    burg(c,1) = 1/4 * e;
end

%2 tables, one with burglary numbers say 0-5, 5-10, etc 4 of them, 
%with likelyhood of being in each class
%second table is with index ranges 4 of them and likelyhood
% of being in each class

%Num of burglarys probability e.g:
%Range | P(class1) | P(class2) | P(class3) | P(class4)
%-----------------------------------------------------
%0 - 5 | 0.2       |0.1        | 0.6       | 0.1

%FREQUENCY TABLE CREATION TO BE USED WITH NAIVE BAYES 
%Save training data with class identification
%Save frequency table
%These make the model.
