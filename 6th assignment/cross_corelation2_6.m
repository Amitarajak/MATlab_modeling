% Load identification input data
loaded_identification_input = load('D:\automation\dataset\identification_input_data.mat');
input_identification_data = loaded_identification_input.input_identification_data;

% Load validation input data
loaded_validation_input = load('D:\automation\dataset\validation_input_data.mat');
input_validation_data = loaded_validation_input.input_validation_data;

% Load identification output data
loaded_identification_output = load('D:\automation\dataset\identification_output_data.mat');
output_identification_data = loaded_identification_output.output_identification_data;

% Load validation output data
loaded_validation_output = load('D:\automation\dataset\validation_output_data.mat');
output_validation_data = loaded_validation_output.output_validation_data;

% Assuming input_identification_data and output_identification_data are structs
% Assuming input_validation_data and output_validation_data are structs

% Compute cross-correlation for identification data
% Compute cross-correlation for identification data
figure;
input_fields = fieldnames(input_identification_data);
output_fields = fieldnames(output_identification_data);
for i = 1:numel(input_fields)
    for j = 1:numel(output_fields)
        identification_cross_corr = xcorr(double(input_identification_data.(input_fields{i})), double(output_identification_data.(output_fields{j})));
        
        % Plot cross-correlation for identification data
        subplot(numel(input_fields), numel(output_fields), (i-1)*numel(output_fields) + j);
        stem(identification_cross_corr);
        title(['Identification: Input ' input_fields{i} ' vs Output ' output_fields{j}]);
        xlabel('Lag');
        ylabel('Cross-Correlation');
    end
end

% Compute cross-correlation for validation data
figure;
input_fields = fieldnames(input_validation_data);
output_fields = fieldnames(output_validation_data);
for i = 1:numel(input_fields)
    for j = 1:numel(output_fields)
        validation_cross_corr = xcorr(double(input_validation_data.(input_fields{i})), double(output_validation_data.(output_fields{j})));
        
        % Plot cross-correlation for validation data
        subplot(numel(input_fields), numel(output_fields), (i-1)*numel(output_fields) + j);
        stem(validation_cross_corr);
        title(['Validation: Input ' input_fields{i} ' vs Output ' output_fields{j}]);
        xlabel('Lag');
        ylabel('Cross-Correlation');
    end
end