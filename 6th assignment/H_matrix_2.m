%For ARX MODEL
% Defining file paths for the saved identification datasets
identification_input_file_path = 'D:\automation\dataset\identification_input_data.mat';
identification_output_file_path = 'D:\automation\dataset\identification_output_data.mat';

% Loading the identification datasets
load(identification_input_file_path, 'input_identification_data');
load(identification_output_file_path, 'output_identification_data');

% Define the number of inputs and outputs
num_inputs = 5;
num_outputs = 2;

% Choosing the I/O variables 
input_vars = cell(num_inputs, 1);
output_vars = cell(num_outputs, 1);
for i = 1:num_inputs
    input_vars{i} = ['in' num2str(i) '_o'];
end
for i = 1:num_outputs
    output_vars{i} = ['out' num2str(i) '_o'];
end

% For simplicity,   working with the first identification output variable and first identification input variable
y_ident_n = output_identification_data.(output_vars{1});
u_ident_n = input_identification_data.(input_vars{1});

% Checking the dimensions
if isvector(y_ident_n)
    y_ident_n = y_ident_n(:); % Ensuring y_ident_n is a column vector
end

if isvector(u_ident_n)
    u_ident_n = u_ident_n(:); % Ensuring u_ident_n is a column vector
end
%Model class:ARX (Auto regressive exogenous)
% Defining the range for constructing the H matrix
range_start = 4;%model order selection
range_end = 499;

% Ensuring the ranges are valid
if range_end > length(y_ident_n) || range_end > size(u_ident_n, 1)
    error('The specified range_end exceeds the length of the data.');
end

% Constructing the H
% matrix( "y=H*P" y(4)=a1y(3)+a2(y(2)+a1(y1)+b1(u(3)+b2(u2)+b1(u1)) ,
% H=[y3 y2 y1 u3 u2 u1],p=[a1,a2,a3,b1,b2,b3],p=([H^t*H]^-1 H^t Y)
%p=regressor vector,H=parameters to be estimated,Y=estimated output
H = [
    y_ident_n(range_start:range_end), ...%current output
    y_ident_n(range_start-1:range_end-1), ...%output with -lag1
    y_ident_n(range_start-2:range_end-2), ...%output with -lag2
    y_ident_n(range_start-3:range_end-3), ...%output with -lag3
    u_ident_n(range_start:range_end, 1), ...%current input
    u_ident_n(range_start-1:range_end-1, 1), ...%input with -lag1
    u_ident_n(range_start-2:range_end-2, 1), ...% input with -lag2
    u_ident_n(range_start-3:range_end-3, 1) %input with -lag3
];

% Displaying the H matrix 
disp('Constructed H matrix:');
disp(H);
% Defining the file path to save the H matrix
H_matrix_file_path = 'D:\automation\dataset\H_matrix.mat';

% Save the H matrix
save(H_matrix_file_path, 'H');

disp(['H matrix saved to ', H_matrix_file_path]);