trainingData = readtable('meanIndexPerPostcode');
scatter(meanIndexPerPostcode.BurglaryCount,meanIndexPerPostcode.Mean_Index);

[idx,C]  = kmeans(table2array(trainingData),4);

plot(C(:,1),C(:,2),'k*','MarkerSize',5);
