%{
This script is used to classify new inputs into the system into one of the
classes defined dureing the model stage.
%}

clear;
inputRow = {'LS7 WEP',3816,256};
input = array2table(inputRow,...
    'VariableNames',{'PostCode' 'ValueIndex' 'Burglarys'});
burglaryProbabilities = readtable('burglaryProbabilities');
burglaryProbabilities = table2array(burglaryProbabilities);
indexProbabilities = readtable('indexProbabilities');
indexProbabilities = table2array(indexProbabilities);

highest = 1;
pclass = [0,0,0,0];
for b = 1:3
	if inputRow{1,3} <= burglaryProbabilities(b,1)
        for c = 2:4
            pclass(c-1) = burglaryProbabilities(b,c);
        end
        break;
	end
end
for b = 1:3
	if inputRow{1,2} <= indexProbabilities(b,1)
        for c = 2:4
            pclass(c-1) = pclass(c-1) + indexProbabilities(b,c);
        end
	break;
	end
end
for d = 1:3
	if pclass(1,d) > pclass(1,highest)
        highest = d;
	end
end
    
disp("this object was identified as class: " + highest);