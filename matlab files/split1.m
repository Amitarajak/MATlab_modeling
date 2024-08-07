% Load the normalized dataset
load('Normalized_New_Data1.mat', 'Nr1');

% Use the normalized dataset 
Data1 = Nr1;

% Setting a seed for reproducibility
rng(42); % A random number generator (RNG) that is seeded with the value 42.

% Defining the proportions for the split
train_ratio = 0.7;
test_ratio = 0.15;

% Calculating the sizes of each set
num_samples = size(Data1, 1);
num_train = round(train_ratio * num_samples);
num_test = round(test_ratio * num_samples);

% Generating random indices for each set
indices = randperm(num_samples);

% Splitting the data
train_data = Data1(indices(1:num_train), :); % Selects the first num_train indices from the indices array
test_data = Data1(indices(num_train+1:num_train+num_test), :); % Selects the next num_test indices, starting right after the training data indices.
val_data = Data1(indices(num_train+num_test+1:end), :); % Selects the remaining indices, starting right after the testing data indices until the end of the indices array.

% Display sizes of each set
disp(['Number of samples in training set: ', num2str(num_train)]);
disp(['Number of samples in testing set: ', num2str(num_test)]);
disp(['Number of samples in validation set: ', num2str(num_samples - num_train - num_test)]);

% Displaying the first few rows of each set
disp('Training Set:');
disp(train_data(1:min(5, num_train), :));

disp('Testing Set:');
disp(test_data(1:min(5, num_test), :));

disp('Validation Set:');
disp(val_data(1:min(5, num_samples - num_train - num_test), :));

% Save the split datasets
save('train_data.mat', 'train_data');
save('test_data.mat', 'test_data');
save('val_data.mat', 'val_data');
