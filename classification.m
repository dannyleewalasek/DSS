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
    if ~isnan(input(1,:).BurglaryCount)
        for b = 1:4
            if  b == 4
                class = 4;
            elseif b == 1
                currentProbability = burglaryProbabilities(b,2);
            elseif input(1,:).BurglaryCount <= burglaryProbabilities(b,1)
                for c = 2:5
                    if burglaryProbabilities(b,c) > currentProbability
                        currentProbability = burglaryProbabilities(b,c);
                        class = c;
                    end
                end
                break;
            end
        end
             if class == input(1,:).ActualClass
                bcorrect = bcorrect +1;
             else
                bincorrect = bincorrect +1;
            end
    end
    if ~isnan(input(1,:).index)
            for b = 1:4
                if  b == 4
                  class = 4;
                elseif b == 1
                    currentProbability = indexProbabilities(b,2);
                elseif input(1,:).index <= indexProbabilities(b,1)
                    for c = 2:5
                        if indexProbabilities(b,c) > currentProbability
                            currentProbability = indexProbabilities(b,c);
                            class = c;
                        end
                    end
                end
            end
            if class == input(1,:).ActualClass
                icorrect = icorrect +1;
            else
                iincorrect = iincorrect +1;
            end
    end