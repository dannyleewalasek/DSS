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
    disp("newcheck");
    for d = 1:size(C)
        disp("loop eneterd");
        disp(sqrt((C(d,1) - trainingData(c,:).BurglaryCount).^2 + (C(d,2) - trainingData(c,:).Mean_Index).^2));
        if sqrt((C(d,1) - trainingData(c,:).BurglaryCount).^2 + (C(d,2) - trainingData(c,:).Mean_Index).^2) < minDistance
            trainingData(c,:).class = d;
            disp("training " + c + " assigned to " + d);
            minDistance = sqrt((C(d,1) - trainingData(c,:).BurglaryCount).^2 + (C(d,2) - trainingData(c,:).Mean_Index).^2);
        end
    end
end

%FREQUENCY TABLE CREATION TO BE USED WITH NAIVE BAYES 
%Save training data with class identification
%Save frequency table
%These make the model.
