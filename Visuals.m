clear;
trainingData = readtable('trainingData');
confusionMatrix = readmatrix('confusionMatrix');

nexttile;
% Display the data in a 3-Dimensional scatter diagram.
colours = ['r','g'];
for z = 1:10:height(trainingData)
        scatter3(trainingData(z,:).Age,trainingData(z,:).YearsNoClaims,trainingData(z,:).CarValue,10,colours(1,trainingData(z,:).FraudDetected + 1));
    hold on;
end

title('All Data plot');
xlabel('Age');
ylabel('Years No Claims');
zlabel('Car Value');

% Matrices to store average values for each classification.
Fraud = [0,0,0]; % Age, Year no claims, Value of car.
NoFraud = [0,0,0]; % Age, Year no claims, Value of car.

% Calculate mean values for age, years no claims and value of car.
FraudRows = table2array(trainingData(any(trainingData.FraudDetected == 1,2),:));
NoFraudRows = table2array(trainingData(any(trainingData.FraudDetected == 0,2),:));
for a = 1:3
    for b = 1:3
        Fraud(a,b) = mean(FraudRows(:,b+1));
        NoFraud(a,b) = mean(NoFraudRows(:,b+1));
    end
end
nexttile;

% Display values
x = [0 1];
vals = [Fraud(1,1) Fraud(1,2) Fraud(1,3); NoFraud(1,1) NoFraud(1,2) NoFraud(1,3)];
b = bar(x,vals);
legend('Average age','Average no claims','Average car value');
title('Fraud/No Fraud group comparisons');
nexttile;
% Stacked bars for negative and positive Confusion matrix values
x = [1];
y = [confusionMatrix(2,2) -confusionMatrix(1,1) ];
bar(x,y,'stacked')
title ModelAccuracy;
legend('Correct Guesses','Incorrect Guesses');
legend show;
% Display confusion matrix
nexttile;
image(confusionMatrix, 'CDataMapping', 'scaled');
colorbar;
title ConfusionMatrix;