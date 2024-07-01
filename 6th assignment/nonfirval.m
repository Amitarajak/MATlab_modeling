% Load the dataset
load("D:\automation\dataset\H_matrix.mat");

% Extract the input and output matrices from the identification dataset
X_identification = H(:, 1:end-1); % Input matrix
y_identification = H(:, end);     % Output vector

% Define the neural network architecture
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize); % Create a feedforward neural network with one hidden layer

% Prepare the data
X = X_identification'; % Inputs
t = y_identification'; % Targets

% Train the neural network
net = train(net, X, t);

% Load the Validation Dataset
load("D:\automation\dataset\H_valid.mat");

% Extract the input and output matrices from the validation dataset
X_validation = H_valid(:, 1:end-1); % Input matrix
y_validation = H_valid(:, end);     % Output vector

% Calculate the predicted output using the trained neural network
y_predicted_validation = net(X_validation');
