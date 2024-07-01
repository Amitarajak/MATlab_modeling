%  loading and visualization of'in1_o' dataset
Data1=in1_o;

% Plotting Histogram
figure;
histogram(Data1);
title('Histogram of Data');
xlabel('Data Values');
ylabel('Frequency');
grid on;

% Identifying and plotting outliers with the help of 3sigma edit role
% di=xi-mean/sigmax -the normalized distance di of each sample from the
% estimate mean is computed

Z_score = zscore(Data1);
outlier_indices = find(Z_score > 3 | Z_score < -3);
fprintf('Z_score: %s\n', mat2str(Z_score));
fprintf('outlier_indices: %s\n', mat2str(outlier_indices));

% Creating a new dataset without outliers
New_Data1 = Data1;
New_Data1(outlier_indices) = NaN;  % Setting outliers to NaN 
After_rem=find(Z_score<3 & Z_score>-3);
fprintf('After_rem: %s\n', mat2str(After_rem));

% Plotting Z-scores with outliers highlighted
figure;
plot(1:numel(Z_score), Z_score, 'b-', 'LineWidth', 1, 'DisplayName', 'Z_score');
hold on;
plot(outlier_indices, Z_score(outlier_indices), 'ro', 'LineWidth', 1, 'DisplayName', 'Outliers');
xlabel('Data Index');
ylabel('Z-score');
title('Z-scores with Outliers Highlighted');
legend('Z_score', 'Outliers');
grid on;
hold off;

% Plotting the new dataset without outliers
figure;
plot(New_Data1);
title('New Dataset without Outliers');
xlabel('Data Index');
ylabel('Data Values');
grid on;


% Saving the New_Data1 file
save('New_Data1.mat', 'New_Data1');