% Load the new datasets
load('NEW_DATA1.mat', 'New_Data1');
load('NEW_DATA2.mat', 'New_Data2');
load('NEW_DATA3.mat', 'New_Data3');
load('NEW_DATA4.mat', 'New_Data4');
load('NEW_DATA5.mat', 'New_Data5');
load('NEW_DATA6.mat', 'New_Data6');

% Normalization: It is done using MinMax normalization
% v' = (v - MINa) / (MAXa - MINa) * (new_MAXa - new_MINa) + new_MINa
% v - unscaled variable, v' - scaled variable, MINa - minimum value of unscaled variable
% MAXa - maximum value of unscaled variable, new_MINa - minimum value of scaled variable
% new_MAXa - maximum value of scaled variable

% Normalize each dataset
Nr1 = normalize(New_Data1, 'range');
Nr2 = normalize(New_Data2, 'range');
Nr3 = normalize(New_Data3, 'range');
Nr4 = normalize(New_Data4, 'range');
Nr5 = normalize(New_Data5, 'range');
Nr6 = normalize(New_Data6, 'range');

% Plot each normalized dataset
figure;
plot(Nr1);
title('Normalized New Data 1');
xlabel('Data Index');
ylabel('Normalized Value');
grid on;

figure;
plot(Nr2);
title('Normalized New Data 2');
xlabel('Data Index');
ylabel('Normalized Value');
grid on;

figure;
plot(Nr3);
title('Normalized New Data 3');
xlabel('Data Index');
ylabel('Normalized Value');
grid on;

figure;
plot(Nr4);
title('Normalized New Data 4');
xlabel('Data Index');
ylabel('Normalized Value');
grid on;

figure;
plot(Nr5);
title('Normalized New Data 5');
xlabel('Data Index');
ylabel('Normalized Value');
grid on;

figure;
plot(Nr6);
title('Normalized New Data 6');
xlabel('Data Index');
ylabel('Normalized Value');
grid on;
