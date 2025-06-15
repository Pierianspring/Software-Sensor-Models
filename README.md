# Software-Sensor-Models

Real-Time Biomass Monitoring: Mechanistic vs. Neural Network Approach
This MATLAB script demonstrates and compares two distinct approaches for real-time biomass concentration monitoring in bioprocesses: a mechanistic model (Monod Kinetics-inspired) and a data-driven Neural Network (NN). It uses simulated bioprocess data, including biomass concentration (X), Carbon Dioxide Evolution Rate (CER), and Oxygen Uptake Rate (OUR), to showcase how each model estimates biomass and their respective performance.

Overview
Accurate and timely monitoring of biomass concentration is crucial for optimizing bioprocesses. This script provides a practical example of how "software sensors" can be developed using both first-principles (mechanistic) and machine learning (neural network) techniques to infer biomass from easily measurable variables like CER and OUR.

Features
Simulated Data Generation: Generates realistic biomass growth curves with added noise, along with corresponding CER and OUR values, mimicking experimental data for demonstration purposes.
Mechanistic Model (Yield-Based Estimation): Implements a simplified mechanistic estimation of biomass based on known yield coefficients from OUR measurements. This represents a traditional, first-principles approach.
Neural Network (NN) Implementation: Trains a feed-forward neural network using CER and OUR as inputs to predict biomass concentration.
Model Comparison: Visualizes the "true" simulated biomass alongside the estimations from both the mechanistic model and the neural network.
Performance Evaluation: Calculates and displays key performance metrics (Mean Absolute Error - MAE, Root Mean Squared Error - RMSE) for both models, enabling a quantitative comparison of their accuracy.
NN Training Performance Plot: Includes a plotperform visualization to assess the neural network's training progress.
How to Use
Clone the Repository: Download or clone this repository to your local machine.
Open in MATLAB: Open the SmartSensors_BiomassMonitoring.m script in MATLAB.
Run the Script: Simply run the script. It will generate the simulated data, train the models, perform the estimations, and display the comparison plots and performance metrics.
Applications
This example is highly relevant for students and researchers in bioprocess engineering, chemical engineering, and data science interested in:

Software sensor development
Bioprocess monitoring and control
Application of machine learning in biotechnology
Comparison of mechanistic vs. data-driven modeling approaches
