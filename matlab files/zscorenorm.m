% Loading the new datasets
load('NEW_DATA1.mat', 'New_Data1');
load('NEW_DATA2.mat', 'New_Data2');
load('NEW_DATA3.mat', 'New_Data3');
load('NEW_DATA4.mat', 'New_Data4');
load('NEW_DATA5.mat', 'New_Data5');
load('NEW_DATA6.mat', 'New_Data6');

% Normalization: It is done using Z-score normalization
% v' = (v - MEANa) / SIGMAa
% v - unscaled variable, v' - scaled variable, MEANa - mean value of unscaled variable
% SIGMAa - standard deviation of unscaled variable

% Normalize each dataset using Z-score normalization
Nr1 = normalize(New_Data1, 'zscore');
Nr2 = normalize(New_Data2, 'zscore');
Nr3 = normalize(New_Data3, 'zscore');
Nr4 = normalize(New_Data4, 'zscore');
Nr5 = normalize(New_Data5, 'zscore');
Nr6 = normalize(New_Data6, 'zscore');

% Save the normalized datasets
save('Normalized_New_Data1.mat', 'Nr1');
save('Normalized_New_Data2.mat', 'Nr2');
save('Normalized_New_Data3.mat', 'Nr3');
save('Normalized_New_Data4.mat', 'Nr4');
save('Normalized_New_Data5.mat', 'Nr5');
save('Normalized_New_Data6.mat', 'Nr6');

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
