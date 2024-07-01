% visualization of Data2
Data2=in2_o;

% Plotting Histogram
figure;
histogram(Data2);
title('Histogram of Data');
xlabel('Data Values');
ylabel('Frequency');
grid on;

% Identifying and plotting outliers
Z_score = zscore(Data2);
outlier_indices = find(Z_score > 3 | Z_score < -3);
fprintf('Z_score: %s\n', mat2str(Z_score));
fprintf('outlier_indices: %s\n', mat2str(outlier_indices));

% Creating a new dataset without outliers
New_Data2 = Data2;
New_Data2(outlier_indices) = NaN;  % Set outliers to NaN (or any other desired value)
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
plot(New_Data2);
title('New Dataset without Outliers');
xlabel('Data Index');
ylabel('Data Values');
grid on;
% Saving the New_Data2 file
save('New_Data2.mat', 'New_Data2');
