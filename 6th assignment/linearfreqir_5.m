%For Finite impulsive response
% Define file paths for the identification and validation datasets
identification_input_file_path = 'D:\automation\dataset\identification_input_data.mat';
identification_output_file_path = 'D:\automation\dataset\identification_output_data.mat';
validation_input_file_path = 'D:\automation\dataset\validation_input_data.mat';
validation_output_file_path = 'D:\automation\dataset\validation_output_data.mat';

% Load the identification datasets
load(identification_input_file_path, 'input_identification_data');
load(identification_output_file_path, 'output_identification_data');

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

% Extract input and output data for identification and validation
y_ident_n = output_identification_data.(output_vars{1});
u_ident_n = input_identification_data.(input_vars{1});
y_valid_n = output_validation_data.(output_vars{1});
u_val_n = input_validation_data.(input_vars{1});

% Check the dimensions
if isvector(y_ident_n)
    y_ident_n = y_ident_n(:); % Ensure y_ident_n is a column vector
end

if isvector(u_ident_n)
    u_ident_n = u_ident_n(:); % Ensure u_ident_n is a column vector
end

if isvector(y_valid_n)
    y_valid_n = y_valid_n(:); % Ensure y_valid_n is a column vector
end

if isvector(u_val_n)
    u_val_n = u_val_n(:); % Ensure u_val_n is a column vector
end

% Define the order of the FIR model
order = 4;
range_end =499;

% Construct the H matrix for identification
H_ident = [
    u_ident_n(order:range_end), ...
    u_ident_n(order-1:range_end-1), ...
    u_ident_n(order-2:range_end-2), ...
    u_ident_n(order-3:range_end-3), ...
    % Include the current input sample and the four previous input samples
];
disp(['Size of H matrix for identification: ', num2str(size(H_ident))]);
disp(H_ident);

% Calculate the parameter estimates using identification data
parstim = inv(H_ident' * H_ident) * H_ident' * y_ident_n(5:500);


% Compute the estimated output using identification data
ystimata_ident = H_ident * parstim;

% Plot comparison of estimated and actual output for identification data
figure;
plot([ystimata_ident, y_ident_n(5:500)]);
title('Comparison of Estimated and Actual Output (Identification Data)');
xlabel('Sample');
ylabel('Output');
legend('Estimated Output', 'Actual Output');
grid on;

% Construct the H matrix for validation
H_val = [
    u_val_n(order:range_end), ...
    u_val_n(order-1:range_end-1), ...
    u_val_n(order-2:range_end-2), ...
    u_val_n(order-3:range_end-3), ...
    % Include the current input sample and the four previous input samples
];
disp(['Size of H matrix for validation: ', num2str(size(H_val))]);
disp(H_val);

% Calculate the parameter estimates using validation data
parstimval = inv(H_val' * H_val) * H_val' * y_valid_n(5:500);

% Compute the estimated output using validation data
ystimata_val = H_val * parstimval;

% Plot comparison of estimated and actual output for validation data
figure;
plot([ystimata_val, y_valid_n(5:500)]);
title('Comparison of Estimated and Actual Output (Validation Data)');
xlabel('Sample');
ylabel('Output');
legend('Estimated Output', 'Actual Output');
grid on;

% Compute the residuals for identification data
residuals_ident = y_ident_n(4:499)' - ystimata_ident;

% Plot residuals for identification data
figure;
plot(residuals_ident, '-k');
title('Residuals (Identification Data)');
xlabel('Sample');
ylabel('Residual');
grid on;


% Compute the residuals for validation data
residuals_val = y_valid_n(4:499)' - ystimata_val;

% Plot residuals for validation data
figure;
plot(residuals_val, '-k');
title('Residuals (Validation Data)');
xlabel('Sample');
ylabel('Residual');
grid on;


