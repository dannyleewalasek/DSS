%{
This script is used to launch all script in turn and run a whole cycle of
the system
%}
clear;
% Prepare the data
datapreperation;
% Train the model using prepared data
modeltraining;
% Test the accuracy of the model
AccuracyTest;
% Use the model to classify a new input
%classification;