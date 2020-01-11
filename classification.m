%{
This script is used to classify new inputs into the system into one of the
classes defined dureing the model stage.
%}

clear;
%postcode,house price, contents, numofburglarys
burglaryProbabilities = readtable('burglaryProbabilities');
inputRow = {'LS7 WEP',1000,5};
input = array2table(inputRow,...
    'VariableNames',{'PostCode' 'ValueIndex' 'BurglaryCount'});

% %chance of being in class 1:

% THIS IS BROKEN !!!!!!!!!!!!!!!!!!!!!! FROM NOW ON

class = 0;
currentProbability = 0;
    % Check the input has a number of burglarys
    disp(input(1,:).BurglaryCount);
    if ~cellfun(@isnan,(input(1,:).BurglaryCount))
        for b = 1:4
            if  b == 4
                class = 4;
            elseif b == 1
                currentProbability = burglaryProbabilities(b,:).Class1;
                class = 1;
            elseif input(1,:).ValueIndex <= burglaryProbabilities(b,:).Range
                for c = 2:5
                    if burglaryProbabilities(b,c) > currentProbability
                        currentProbability = burglaryProbabilities(b,c);
                        class = c;
                    end
                end
            end
        end
             if class == testdata(a,:).ActualClass
                bcorrect = bcorrect +1;
             else
                bincorrect = bincorrect +1;
             end
    end