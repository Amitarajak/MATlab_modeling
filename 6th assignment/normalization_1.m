% Define file path
input_file_path = 'D:\automation\dataset\SRU_line2_outliers.mat';

% Check if the file exists
if isfile(input_file_path)
    % Loading the dataset
    loaded_data = load(input_file_path);

    % Defining the number of inputs and outputs
    num_inputs = 5;
    num_outputs = 2;

    % 1.Choosing the I/O variables 
    input_vars = cell(num_inputs, 1);%input_vars is a cell array with num_inputs rows and 1 column.
    output_vars = cell(num_outputs, 1);%output_vars is a cell array with num_outputs rows and 1 column
    for i = 1:num_inputs
        input_vars{i} = ['in' num2str(i) '_o'];%Storing this string in the i-th position of input_vars.
    end
    for i = 1:num_outputs
        output_vars{i} = ['out' num2str(i) '_o'];%Storing this string in the i-th position of output_vars
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

    %2. Defining threshold for outlier detection
    threshold = 3; 

    % 3.Removing/interpolate outliers and handle NaN values for inputs
    for i = 1:num_inputs
        input_data = loaded_data.(input_vars{i});

        % Handling NaN values by interpolation
        nan_indices = isnan(input_data);%Each element is true if the corresponding element in input_data is NaN, and false otherwise.
        input_data(nan_indices) = interp1(find(~nan_indices), input_data(~nan_indices), find(nan_indices), 'linear', 'extrap');%The interpolated values replace the NaN values in input_data.

        % Detecting outliers using z-score
        z_scores = abs((input_data - mean(input_data)) / std(input_data));
        is_outlier = z_scores > threshold;

        % Plot input data with outliers marked
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

        % Plotting input data after removing outliers
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

        % Handle NaN values by interpolation
        nan_indices = isnan(output_data);
        output_data(nan_indices) = interp1(find(~nan_indices), output_data(~nan_indices), find(nan_indices), 'linear', 'extrap');

        % Detect outliers using z-score
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

        % Remove outliers
        output_data(is_outlier) = NaN;

        % Handle NaN values by interpolation
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

    %4.Normalization: Compute mean and variance on the whole data set 
    
  
    for i = 1:num_inputs
        data = loaded_data.(input_vars{i});
        mean_val = mean(data);
        var_val = var(data);

        % Normalize the data (standard normalization)
        normalized_data = (data - mean_val) / std(data);
        loaded_data.(['normalized_' input_vars{i}]) = normalized_data;

        % Displaying statistics
        fprintf('Input %d - Mean: %.2f, Variance: %.2f\n', i, mean_val, var_val);
    end

    for i = 1:num_outputs
        data = loaded_data.(output_vars{i});
        mean_val = mean(data);
        var_val = var(data);

        % Normalize the data (standard normalization)
        normalized_data = (data - mean_val) / std(data);
        loaded_data.(['normalized_' output_vars{i}]) = normalized_data;

        % Displaying statistics
        fprintf('Output %d - Mean: %.2f, Variance: %.2f\n', i, mean_val, var_val);
    end

    %5. Splitting the data into identification and validation sets
    input_identification_data = struct();
    input_validation_data = struct();
    output_identification_data = struct();
    output_validation_data = struct();

    % Splitting inputs
    for i = 1:num_inputs
        normalized_data = loaded_data.(['normalized_' input_vars{i}]);
        input_identification_data.(input_vars{i}) = normalized_data(1:500);
        input_validation_data.(input_vars{i}) = normalized_data(501:1000);
    end

    % Splitting outputs
    for i = 1:num_outputs
        normalized_data = loaded_data.(['normalized_' output_vars{i}]);
        output_identification_data.(output_vars{i}) = normalized_data(1:500);
        output_validation_data.(output_vars{i}) = normalized_data(501:end);
    end
     % Plotting identification and validation sets for inputs
    figure;
    for i = 1:num_inputs
        subplot(num_inputs, 2, 2*i-1);
        plot(input_identification_data.(input_vars{i}));
        title(['Input ' num2str(i) ' Identification']);
        xlabel('Sample');
        ylabel(input_vars{i});

        subplot(num_inputs, 2, 2*i);
        plot(input_validation_data.(input_vars{i}));
        title(['Input ' num2str(i) ' Validation']);
        xlabel('Sample');
        ylabel(input_vars{i});
    end

    % Plotting identification and validation sets for outputs
    figure;
    for i = 1:num_outputs
        subplot(num_outputs, 2, 2*i-1);
        plot(output_identification_data.(output_vars{i}));
        title(['Output ' num2str(i) ' Identification']);
        xlabel('Sample');
        ylabel(output_vars{i});

        subplot(num_outputs, 2, 2*i);
        plot(output_validation_data.(output_vars{i}));
        title(['Output ' num2str(i) ' Validation']);
        xlabel('Sample');
        ylabel(output_vars{i});
    end


    % Saving identification and validation datasets for inputs and outputs
    identification_input_file_path = 'D:\automation\dataset\identification_input_data.mat';
    validation_input_file_path = 'D:\automation\dataset\validation_input_data.mat';
    identification_output_file_path = 'D:\automation\dataset\identification_output_data.mat';
    validation_output_file_path = 'D:\automation\dataset\validation_output_data.mat';

    save(identification_input_file_path, 'input_identification_data');
    save(validation_input_file_path, 'input_validation_data');
    save(identification_output_file_path, 'output_identification_data');
    save(validation_output_file_path, 'output_validation_data');
end
