% Defining file paths for the saved H matrix and identification data
H_matrix_file_path = 'D:\automation\dataset\H_matrix.mat';
identification_output_file_path = 'D:\automation\dataset\identification_output_data.mat';

% Loading the H matrix
load(H_matrix_file_path, 'H');

% Loading the identification output data
load(identification_output_file_path, 'output_identification_data');

% Defining the number of outputs
num_outputs = 2;

% Choosing the output variable (assuming the variable names follow a specific pattern)
output_vars = cell(num_outputs, 1);
for i = 1:num_outputs
    output_vars{i} = ['out' num2str(i) '_o'];
end

% For simplicity,  working with the first output variable
y_ident_n = output_identification_data.(output_vars{1});

% Ensuring y_ident_n is a column vector
if isvector(y_ident_n)
    y_ident_n = y_ident_n(:);
end

% Defining the range for y_ident_n to match H matrix
y_ident_n_range = y_ident_n(5:500);

% Parameter estimation with least mean square
parstim = inv(H' * H) * H' * y_ident_n_range;%H: 496×8,H': 8×496,(H×H'):8×8,inv(H' * H):8×8,H' * y_ident_n_range: 8×1,parstim: 8×1


% Estimated output computation on the identification data
y_stimata = H * parstim;

% Compute residuals the residual is the difference between the observed value and the value predicted by the model.
residuals = y_ident_n_range - y_stimata;

% Compute the correlation coefficient between actual and estimated outputs
corr_coefficient = corrcoef(y_ident_n_range, y_stimata);%Residuals help to assess the fit of the model. If the residuals are small and randomly distributed, it indicates a good model fit.
corr_value = corr_coefficient(1, 2);

% Fit a Gaussian distribution to the residuals
residual_dist = fitdist(residuals, 'Normal');%Normally distributed residuals are a common assumption in many statistical models, including linear regression.

% Plot comparison, residuals, and histogram of residuals
figure;

% Plot comparison of estimated and actual output
subplot(3, 1, 1);
plot(1:length(y_stimata), y_stimata, '-b', 1:length(y_stimata), y_ident_n_range, '--r');
title('Comparison of Estimated and Actual Output');
xlabel('Sample');
ylabel('Output');
legend('Estimated Output', 'Actual Output');
grid on;

% Plot residuals
subplot(3, 1, 2);
plot(1:length(residuals), residuals, '-k');
title('Residuals');
xlabel('Sample');
ylabel('Residual');
grid on;

% Plot histogram with fitted Gaussian distribution of residuals
subplot(3, 1, 3);
histogram(residuals, 'Normalization', 'pdf');
hold on;
x_values = linspace(min(residuals), max(residuals), 100);
y_values = pdf(residual_dist, x_values);
plot(x_values, y_values, '-r', 'LineWidth', 2);
title('Histogram of Residuals with Fitted Gaussian Distribution');
xlabel('Residual');
ylabel('Probability Density');
hold off;

% Display the correlation coefficient
disp(['Correlation Coefficient: ', num2str(corr_value)]);


