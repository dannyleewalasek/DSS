% THESE DATA CRFEASTION CLASSES WILL BE REMOVED BEFORE FINAL SUBMISSION
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


testdata = table("LS8_1PR", "1000", 10, 0);
testdata.Properties.VariableNames = {'PostCode','index','Burglarys','ActualClass'};
for a = 1:100
    testdata{a,1} = strcat("LS8",num2str(a),"PR");
    testdata{a,2} = 11000 - (a * 90);
    testdata{a,3} = a * 100;
    testdata{a,4} = 0;
end

writetable(testdata);