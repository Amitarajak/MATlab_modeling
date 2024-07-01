% Assuming 'Data1' is your dataset
rng(42); % Set a seed for reproducibility
Data7 = randn(100, 5); % Replace with your actual dataset

% Define the proportions for the split
train_ratio = 0.7;
test_ratio = 0.15;

% Calculate the sizes of each set
num_samples = size(Data7, 1);
num_train = round(train_ratio * num_samples);
num_test = round(test_ratio * num_samples);

% Generate random indices for each set
indices = randperm(num_samples);

% Split the data
train_data = Data7(indices(1:num_train), :);
test_data = Data7(indices(num_train+1:num_train+num_test), :);
val_data = Data7(indices(num_train+num_test+1:end), :);

% Display sizes of each set
disp(['Number of samples in training set: ', num2str(num_train)]);
disp(['Number of samples in testing set: ', num2str(num_test)]);
disp(['Number of samples in validation set: ', num2str(num_samples - num_train - num_test)]);

% Display the first few rows of each set
disp('Training Set:');
disp(train_data(1:min(5, num_train), :));

disp('Testing Set:');
disp(test_data(1:min(5, num_test), :));

disp('Validation Set:');
disp(val_data(1:min(5, num_samples - num_train - num_test), :));
