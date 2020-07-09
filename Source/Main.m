%{
This script is used to launch all scripts in turn and run a whole cycle of
the system.
%}
clear;

% Data creation
CreateData;

% Prepare the data
datapreperation;

% Train the model using prepared data
ModelTraining;

% Test the accuracy of the model
AccuracyTest;

% Display visualisations of a number of data to the user.
Visuals;

% Use the model to classify a new input
Classification;