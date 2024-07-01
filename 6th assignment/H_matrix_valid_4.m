% Define file paths for the validation datasets
validation_input_file_path = 'D:\automation\dataset\validation_input_data.mat';
validation_output_file_path = 'D:\automation\dataset\validation_output_data.mat';

% Load the validation datasets
load(validation_input_file_path, 'input_validation_data');
load(validation_output_file_path, 'output_validation_data');

% Define the number of inputs and outputs
num_inputs = 5;
num_outputs = 2;

% Choose the I/O variables (assuming the variable names follow a specific pattern)
input_vars = cell(num_inputs, 1);
output_vars = cell(num_outputs, 1);
for i = 1:num_inputs
    input_vars{i} = ['in' num2str(i) '_o'];
end
for i = 1:num_outputs
    output_vars{i} = ['out' num2str(i) '_o'];
end

% For simplicity,  working with the first output variable and first input variable
y_valid_n = output_validation_data.(output_vars{1});
u_valid_n = input_validation_data.(input_vars{1});

% Check the dimensions
if isvector(y_valid_n)
    y_valid_n = y_valid_n(:); % Ensure y_valid_n is a column vector
end

if isvector(u_valid_n)
    u_valid_n = u_valid_n(:); % Ensure u_valid_n is a column vector
end

% Define the range for constructing the H matrix
range_start = 4;
range_end = 499;

% Ensure the ranges are valid
if range_end > length(y_valid_n) || range_end > size(u_valid_n, 1)
    error('The specified range_end exceeds the length of the data.');
end

% Construct the H matrix for validation
H_valid = [
    y_valid_n(range_start:range_end), ...
    y_valid_n(range_start-1:range_end-1), ...
    y_valid_n(range_start-2:range_end-2), ...
    y_valid_n(range_start-3:range_end-3), ...
    u_valid_n(range_start:range_end, 1), ...
    u_valid_n(range_start-1:range_end-1, 1), ...
    u_valid_n(range_start-2:range_end-2, 1), ...
    u_valid_n(range_start-3:range_end-3, 1)
];

% Display the size of the H matrix for validation
disp(['Size of H matrix for validation: ', num2str(size(H_valid))]);
disp(H_valid);
H_valid_file_path = 'D:\automation\dataset\H_valid.mat';

% Save the H matrix
save(H_valid_file_path, 'H_valid');

disp(['H valid saved to ', H_valid_file_path]);
% Calculate the parameter estimates using validation data
parstim = inv(H_valid' * H_valid) * H_valid' * y_valid_n(5:500);

% Compute the estimated output using validation data
ystimataval = H_valid * parstim;

% Plot actual and estimated outputs
figure;
subplot(3, 1, 1);
plot(y_valid_n(5:500), '-b');
hold on;
plot(ystimataval, '--r');
title('Actual vs. Estimated Output');
xlabel('Sample');
ylabel('Output');
legend('Actual Output', 'Estimated Output');
grid on;

% Compute residuals
residuals_valid = y_valid_n(5:500) - ystimataval;

% Plot residuals
subplot(3, 1, 2);
plot(residuals_valid, '-k');
title('Residuals');
xlabel('Sample');
ylabel('Residual');
grid on;

% Plot histogram with fitted Gaussian distribution of residuals
subplot(3, 1, 3);
histfit(residuals_valid, 50, 'normal');
title('Histogram of Residuals with Fitted Gaussian Distribution');
xlabel('Residual');
ylabel('Frequency');
grid on;
