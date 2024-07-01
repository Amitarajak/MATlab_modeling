% Define file path
input_file_path = 'D:\automation\dataset\SRU_line2_outliers.mat';

% Check if the file exists
if isfile(input_file_path)
    % Load the dataset
    loaded_data = load(input_file_path);

    % Defining the number of inputs and outputs
    num_inputs = 5;
    num_outputs = 2;

    %1. Choosing the I/O variables 
    input_vars = cell(num_inputs, 1);
    output_vars = cell(num_outputs, 1);
    for i = 1:num_inputs
        input_vars{i} = ['in' num2str(i) '_o'];%it constructs a string representing the name of an input variable, such as 'in1_o', 'in2_o', etc., and assigns it to the corresponding position in the input_vars cell array.
    end
    for i = 1:num_outputs
        output_vars{i} = ['out' num2str(i) '_o'];%it constructs a string representing the name of an output variable, such as 'out1_o', 'out2_o', etc., and assigns it to the corresponding position in the output_vars cell array.
    end

    % Plot the raw input data
    figure;
    for i = 1:num_inputs
        subplot(num_inputs, 1, i);
        plot(loaded_data.(input_vars{i}));
        title(['Raw Input ' num2str(i)]);
        xlabel('Sample');
        ylabel(input_vars{i});
    end

    % Plot the raw output data
    figure;
    for i = 1:num_outputs
        subplot(num_outputs, 1, i);
        plot(loaded_data.(output_vars{i}));
        title(['Raw Output ' num2str(i)]);
        xlabel('Sample');
        ylabel(output_vars{i});
    end

    % 2.Defining threshold for outlier detection
    threshold = 3; 

    % 3.Removing/interpolate outliers and handle NaN values for inputs
    for i = 1:num_inputs
        input_data = loaded_data.(input_vars{i});

        % Handling NaN values by interpolation
        nan_indices = isnan(input_data);
        input_data(nan_indices) = interp1(find(~nan_indices), input_data(~nan_indices), find(nan_indices), 'linear', 'extrap');

        % Detecting outliers using z-score
        z_scores = abs((input_data - mean(input_data)) / std(input_data));
        is_outlier = z_scores > threshold;

        % Plotting input data with outliers marked
        figure;
        subplot(2, 1, 1);
        plot(input_data);
        hold on;
        plot(find(is_outlier), input_data(is_outlier), 'ro', 'MarkerSize', 5);
        title(['Input ' num2str(i) ' with Outliers Marked']);
        xlabel('Sample');
        ylabel(input_vars{i});

        % Removing outliers
        input_data(is_outlier) = NaN;

        % Handling NaN values by interpolation
        input_data = fillmissing(input_data, 'linear');

        % Plot input data after removing outliers
        subplot(2, 1, 2);
        plot(input_data);
        title(['Input ' num2str(i) ' after Removing Outliers']);
        xlabel('Sample');
        ylabel(input_vars{i});

        % Update the data with interpolated values
        loaded_data.(input_vars{i}) = input_data;
    end

    % Removing/interpolate outliers and handle NaN values for outputs
    for i = 1:num_outputs
        output_data = loaded_data.(output_vars{i});

        % Handling NaN values by interpolation
        nan_indices = isnan(output_data);
        output_data(nan_indices) = interp1(find(~nan_indices), output_data(~nan_indices), find(nan_indices), 'linear', 'extrap');

        % Detecting outliers using z-score
        z_scores = abs((output_data - mean(output_data)) / std(output_data));
        is_outlier = z_scores > threshold;

        % Plot output data with outliers marked
        figure;
        subplot(2, 1, 1);
        plot(output_data);
        hold on;
        plot(find(is_outlier), output_data(is_outlier), 'ro', 'MarkerSize', 5);
        title(['Output ' num2str(i) ' with Outliers Marked']);
        xlabel('Sample');
        ylabel(output_vars{i});

        % Removing outliers
        output_data(is_outlier) = NaN;

        % Handling NaN values by interpolation
        output_data = fillmissing(output_data, 'linear');

        % Plot output data after removing outliers
        subplot(2, 1, 2);
        plot(output_data);
        title(['Output ' num2str(i) ' after Removing Outliers']);
        xlabel('Sample');
        ylabel(output_vars{i});

        % Update the data with interpolated values
        loaded_data.(output_vars{i}) = output_data;
    end

    % 4.Normalization:Compute mean and variance on the whole data set and
    % normalize using standard variation
    for i = 1:num_inputs
        data = loaded_data.(input_vars{i});
        mean_val = mean(data);
        var_val = var(data);

        % Normalize the data 
        normalized_data = (data - mean_val) / std(data);
        loaded_data.(['normalized_' input_vars{i}]) = normalized_data;

        % Displaying statistics
        fprintf('Input %d - Mean: %.2f, Variance: %.2f\n', i, mean_val, var_val);
    end

    for i = 1:num_outputs
        data = loaded_data.(output_vars{i});
        mean_val = mean(data);
        var_val = var(data);

        % Normalize the data
        normalized_data = (data - mean_val) / std(data);
        loaded_data.(['normalized_' output_vars{i}]) = normalized_data;

        % Display statistics
        fprintf('Output %d - Mean: %.2f, Variance: %.2f\n', i, mean_val, var_val);
    end

    % 5.Splitting the data into identification and validation sets
    input_identification_data = struct();
    input_validation_data = struct();
    output_identification_data = struct();
    output_validation_data = struct();

    % Splitting inputs for identification(1:500) validation (501:1000) rest
    % are dropped
    for i = 1:num_inputs
        normalized_data = loaded_data.(['normalized_' input_vars{i}]);
        input_identification_data.(input_vars{i}) = normalized_data(1:500);
        input_validation_data.(input_vars{i}) = normalized_data(501:1000);
    end

    % Splitting outputs 
    for i = 1:num_outputs
        normalized_data = loaded_data.(['normalized_' output_vars{i}]);
        output_identification_data.(output_vars{i}) = normalized_data(1:500);
        output_validation_data.(output_vars{i}) = normalized_data(501:1000);
    end

    % Save identification and validation datasets for inputs and outputs
    identification_input_file_path = 'D:\automation\dataset\identification_input_data.mat';
    validation_input_file_path = 'D:\automation\dataset\validation_input_data.mat';
    identification_output_file_path = 'D:\automation\dataset\identification_output_data.mat';
    validation_output_file_path = 'D:\automation\dataset\validation_output_data.mat';

    save(identification_input_file_path, 'input_identification_data');
    save(validation_input_file_path, 'input_validation_data');
    save(identification_output_file_path, 'output_identification_data');
    save(validation_output_file_path, 'output_validation_data');
    
    % Plot the identification and validation sets for inputs
    figure;
    for i = 1:num_inputs
        subplot(num_inputs, 1, i);
        plot(input_identification_data.(input_vars{i}));
        title(['Identification Input ' num2str(i)]);
        xlabel('Sample');
        ylabel(input_vars{i});
    end

    figure;
    for i = 1:num_inputs
        subplot(num_inputs, 1, i);
        plot(input_validation_data.(input_vars{i}));
        title(['Validation Input ' num2str(i)]);
        xlabel('Sample');
        ylabel(input_vars{i});
    end

    % Plot the identification and validation sets for outputs
    figure;
    for i = 1:num_outputs
        subplot(num_outputs, 1, i);
        plot(output_identification_data.(output_vars{i}));
        title(['Identification Output ' num2str(i)]);
        xlabel('Sample');
        ylabel(output_vars{i});
    end

    figure;
    for i = 1:num_outputs
        subplot(num_outputs, 1, i);
        plot(output_validation_data.(output_vars{i}));
        title(['Validation Output ' num2str(i)]);
        xlabel('Sample');
        ylabel(output_vars{i});
    end
end
