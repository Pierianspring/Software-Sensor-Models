% MATLAB Script:Smart Senosrs (Slimme Sensoren) Course: Software Sensors Example 1 
% Biomass Concentration Real-Time Monitoring 
% Comparing Mechanistic Model (Monod Kinetics) vs. Neural Network

%% 1. Data Preparation (Simulated Data for Demonstration)
% In a real scenario, you would load your experimental data here.
% Assume data points every hour for 24 hours.
clear 
clc 

close all     


% Simulate time points
time = 0:1:24; % hours

% Simulate 'True' Biomass Concentration (X_true) - example of a growth curve
% Let's use a logistic growth curve for X_true to make it somewhat realistic
X0 = 0.1; % Initial biomass
K = 10;   % Carrying capacity
r = 0.2;  % Growth rate
X_true = K ./ (1 + ((K - X0) / X0) * exp(-r * time));
X_true = X_true + randn(size(time)) * 0.1; % Add some noise

% Simulate CO2 Evolution Rate (CER) and Oxygen Uptake Rate (OUR)
% These are typically proportional to biomass concentration and metabolic activity.
% We'll assume a rough proportionality to biomass for simplicity here.
% In reality, these are often directly measured from off-gas analysis.

% Yield coefficients (example values)
Y_X_CO2 = 0.5; % g biomass / g CO2 (very rough example, actual units depend on CER units)
Y_X_O2 = 0.6;  % g biomass / g O2 (very rough example, actual units depend on OUR units)

% Simulate CER and OUR based on X_true (and add noise)
% Scale these to plausible fermentation values
CER_true = (0.2 * X_true) + 0.1*randn(size(X_true)); % Example: CO2 production is proportional to biomass
OUR_true = (0.3 * X_true) + 0.1*randn(size(X_true)); % Example: O2 consumption is proportional to biomass

% Ensure no negative values from noise
CER_true(CER_true < 0) = 0;
OUR_true(OUR_true < 0) = 0;

% For the NN, input features would be CER and OUR
input_data_NN = [CER_true; OUR_true];
target_data_NN = X_true;

% Split data for NN training and testing (e.g., 70% train, 15% validation, 15% test)
trainRatio = 0.7;
valRatio = 0.15;
testRatio = 0.15;

disp('Data simulation complete. Ready for model comparison.');

% 2. Mechanistic Model (Monod Kinetics) for Biomass Estimation

% This section will demonstrate how to simulate biomass evolution
% based on the Monod model if you knew the kinetic parameters and substrate.
% However, for *monitoring based on CO2/O2*, we need to adapt the idea.

% A common approach for mechanistic monitoring from CER/OUR is to use the
% elemental balance approach or a simplified yield-based estimation.
% Let's assume a simplified relationship for mechanistic estimation from OUR/CER.

% Simplified Mechanistic Estimation (Yield-based, from OUR/CER)
% If you have the yield of biomass on O2 or CO2, you can estimate X.
% This is a form of online estimation based on known stoichiometry/yields.

% Assume 'known' yield coefficients from previous characterization
% These are the inverse of the Y_X_CO2 and Y_X_O2 from above for consistency.
Y_O2_X_mech = 1/Y_X_O2; % g O2 / g biomass (e.g., specific O2 consumption rate)
Y_CO2_X_mech = 1/Y_X_CO2; % g CO2 / g biomass (e.g., specific CO2 production rate)

% Here, we'll derive a 'mechanistic' biomass from OUR (as an example)
% Assuming OUR = mu * X / Y_X_O2 or simply OUR = k * X
% If OUR is directly proportional to X with a known constant:
% X_mech_estimated = OUR_true / (Specific_Oxygen_Consumption_Rate_per_Biomass);
% Let's use average specific O2 consumption rate derived from our simulated data
specific_O2_consumption_rate = mean(OUR_true ./ X_true); % This would be experimentally determined
X_mech_estimated = OUR_true / specific_O2_consumption_rate;

% Note: A more sophisticated mechanistic model for monitoring would involve
% a state estimator (e.g., Kalman filter) where X is a state variable
% and OUR/CER are measurements related to X through known kinetics and yields.
% For this simple comparison, we're doing a direct estimation.

disp('Mechanistic (yield-based) estimation complete.');

% 3. Neural Network (NN) Model for Biomass Estimation

% Define the Neural Network Architecture
hiddenLayerSize = 10; % Number of neurons in the hidden layer (can be tuned)
net = fitnet(hiddenLayerSize);

% Configure the data division
net.divideParam.trainRatio = trainRatio;
net.divideParam.valRatio = valRatio;
net.divideParam.testRatio = testRatio;

% Train the Neural Network
% Inputs are CER_true and OUR_true
% Targets are X_true
[net, tr] = train(net, input_data_NN, target_data_NN);

% Test the Neural Network on the entire dataset
X_nn_predicted = net(input_data_NN);

disp('Neural Network training and prediction complete.');

% 4. Comparison and Visualization

figure;
plot(time, X_true, 'k*:', 'LineWidth', 4);
hold on;
plot(time, X_mech_estimated, 'b-', 'LineWidth', 4);
plot(time, X_nn_predicted, 'r-', 'LineWidth', 4);

xlabel('Time (hours)');
ylabel('Biomass Concentration (g/L)');
title('Biomass Concentration Monitoring: Monod (mechanistic) vs. neural network (data-driven)');
legend('True Biomass', 'Monod estimation model', 'Neural network prediction', 'Location', 'best');
grid on;set(gcf, 'Color', 'white');
ax = gca;
ax.FontSize = 34;
ax.FontName = 'Arial';
box off
hold off;
hold off;


%Evaluate performance metrics
mae_mech = mean(abs(X_true - X_mech_estimated));
rmse_mech = sqrt(mean((X_true - X_mech_estimated).^2));

mae_nn = mean(abs(X_true - X_nn_predicted));
rmse_nn = sqrt(mean((X_true - X_nn_predicted).^2));

fprintf('\n--- Model Performance Comparison ---\n');
fprintf('Mechanistic Model (Yield-based):\n');
fprintf('  Mean Absolute Error (MAE): %.4f\n', mae_mech);
fprintf('  Root Mean Squared Error (RMSE): %.4f\n', rmse_mech);

fprintf('\nNeural Network Model:\n');
fprintf('  Mean Absolute Error (MAE): %.4f\n', mae_nn);
fprintf('  Root Mean Squared Error (RMSE): %.4f\n', rmse_nn);

disp('Comparison and visualization complete.');

% Optional: Plot NN training performance
figure;
plotperform(tr);
title('Neural Network Training Performance');

