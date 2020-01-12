testdata = table("LS8_1PR", 3000, 10, 0);
testdata.Properties.VariableNames = {'PostCode','index','Burglarys', 'ActualClass'};
writetable(testdata);