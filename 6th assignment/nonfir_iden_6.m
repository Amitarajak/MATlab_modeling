% Divide the dataset into training and validation sets (70% for training, 30% for validation)
net.divideFcn = 'dividerand'; %  This property specifies the function used to divide the data randomly.
net.divideMode = 'sample';    % This property determines how the data is divided.
net.divideParam.trainRatio = 0.7;%70%of the data will be used for training the neural network. 
net.divideParam.valRatio = 0.3;%30% of the data will be used for validating the neural network.

% Load the dataset
load("D:\automation\dataset\H_matrix.mat");

% Extract the input and output matrices from the identification dataset
X_identification = H(:, 1:end-1); % Input matrix This variable holds the input matrix used for identification or training. Each row represents a sample, and each column represents a different input feature.

y_identification = H(:, end);     % Output vector This variable holds the output vector used for identification or training. 

% Define the neural network architecture
hiddenLayerSize = 10;%the neural network will have one hidden layer containing 10 neurons.
net = fitnet(hiddenLayerSize); % Create a feedforward neural network with one hidden layer using fitnet

% Prepare the data
X = X_identification'; % Inputs
t = y_identification'; % Targets

% Training the neural network
[net, tr] = train(net, X, t);%it performs the training of the neural network net using the input data X and the target data t.

% Displaying the neural network
view(net);

% Calculating the outputs of the neural network on the training and validation data
y_predicted_train = net(X(:, tr.trainInd)); % Predictions on training data
y_predicted_val = net(X(:, tr.valInd));     % Predictions on validation data

% Plot the error (residual) for training and validation data
figure;
subplot(2, 1, 1);
plot(tr.trainInd, y_predicted_train - t(tr.trainInd), 'bo');
title('Training Data: Error Plot');
xlabel('Sample');
ylabel('Error (Actual - Predicted)');
grid on;
subplot(2, 1, 2);
plot(tr.valInd, y_predicted_val - t(tr.valInd), 'rx');
title('Validation Data: Error Plot');
xlabel('Sample');
ylabel('Error (Actual - Predicted)');
grid on;

% Plot the histogram of errors for training and validation data
figure;
subplot(2, 1, 1);
histogram(y_predicted_train - t(tr.trainInd), 'Normalization', 'probability');
title('Training Data: Error Histogram');
xlabel('Error (Actual - Predicted)');
ylabel('Probability');
grid on;
subplot(2, 1, 2);
histogram(y_predicted_val - t(tr.valInd), 'Normalization', 'probability');
title('Validation Data: Error Histogram');
xlabel('Error (Actual - Predicted)');
ylabel('Probability');
grid on;

% Compute the correlation coefficient between actual and estimated output
correlation_coefficient_train = corrcoef(t(tr.trainInd), y_predicted_train);
correlation_coefficient_val = corrcoef(t(tr.valInd), y_predicted_val);
disp("Correlation coefficient for training dataset:");
disp(correlation_coefficient_train(1, 2));
disp("Correlation coefficient for validation dataset:");
disp(correlation_coefficient_val(1, 2));

% Plot the actual vs estimated output on both datasets
figure;
subplot(1, 2, 1);
plot(t(tr.trainInd), y_predicted_train, 'bo');
hold on;
plot(t(tr.trainInd), t(tr.trainInd), 'r--');
hold off;
xlabel('Actual Output');
ylabel('Predicted Output');
title('Training Data: Actual vs. Predicted Outputs');
legend('Predicted', 'Actual');
grid on;
subplot(1, 2, 2);
plot(t(tr.valInd), y_predicted_val, 'rx');
hold on;
plot(t(tr.valInd), t(tr.valInd), 'b--');
hold off;
xlabel('Actual Output');
ylabel('Predicted Output');
title('Validation Data: Actual vs. Predicted Outputs');
legend('Predicted', 'Actual');
grid on;

