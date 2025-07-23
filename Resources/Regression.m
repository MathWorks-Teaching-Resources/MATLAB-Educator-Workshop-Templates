%% Regression: Basics
% Suggested Prework
% MATLAB Onramp – a free two-hour introductory tutorial to learn the essentials of MATLAB.
%% What is Regression?
% Regression refers to techniques for estimating the relationship between a 
% dependent variable and one or more independent variables. In other words, 
% it is a way to model a target (dependent) variable based on other (independent) 
% variables. 
% Regression is widely used for 
%   * explaining or quantifying the relationship between variables
%   * forecasting or making predictions from data
%% Simple Linear Regression
% Suppose you want to estimate your home's current value on the market. 
% Based on some experience, you believe that the square footage of a house 
% might be a strong indicator of its value. So, you find the recent listings 
% in the neighborhood to verify and model the relationship between the property's 
% price and its square footage (area).
load LinearData.mat x y                     % Load data from a MAT file
figure;
scatter(x,y)                                % Plot the data points
xlabel("Area (sqft)")                       % Label the X axis
ylabel("Listed price (USD)")                % Label the Y axis
title("Listed price vs area of a house")    % Add a title

% Reflect: Do you see a trend or pattern in the data?
% Here, you have one dependent (price) and one independent variable (area) 
% that appear to be linearly correlated. This is a simple linear regression 
% problem, which uses a straight line to model the relationship between one 
% dependent variable (y) and one independent variable (x):
% y = a0 + a1*x

a1 =240;            % Set value for coefficient a1
a0 =160000;         % Set value for coefficient a0
 
figure                    % Set up a figure for the plot
PlotFit(x,y,[a1 a0],0);   % Call the helper function to plot the polynomial fit and the data samples

%% Ordinary Least Squares
% Your goal with regression is to find the best model describing the dependent 
% variable as a function of the independent variable/s. One way to quantify 
% the goodness of your model's fit is by calculating the sum of squared errors 
% (SSE) between the actual and predicted values of the dependent variable.
%    $\text{SSE} = \sum_{i=1}^{n}(y_i-\hat{y}_i)^2$
% where y_i is the actual value of the dependent variable corresponding
% to the ith data sample out of n total samples and
% \hat{y}_i is the predicted value corresponding to the ith data sample out
% of n total samples

% Visualize the error bars and display the sum of squared errors
a1 = 140;                                   % Set value for coefficient a1
a0 = 4000;                                  % Set value for coefficient a0
 
figure
PlotFit(x,y,[a1 a0],1);                     % Visualize the errors

% Substituting the straight line model for the predicted values, the goal
% of simple linear regression can now be formulated as the following
% minimization problem:
%    $\text{min}_{a_0,a_1} \sum_{i=1}^{n} (y_i-(a_0+a_1x_i))^2$
% You can solve this analytically for a_1 and a_0 to get
%    $a_1 =
%    \frac{\sum_{i=1}^{n}(x_i-\bar{x})(y_i-\bar{y})}{\sum_{i=1}^{n}(x_i-\bar{x})^2$
% and
%    $a_0 = \bar{y}-a_1\bar{x}$
% where
%    $\bar{x}$ is the average of all the x_i
%    $\bar{y}$ is the average of all the y_i
%    i indicates the individual data samples from a total of n samples

% Exercise: Check whether your manual selection of a1 and a0 matches the
% values you get from this analytical solution. 

xbar = mean(x)
ybar = mean(y)

% Compute the values for a1 and a0 using the derived equations and the variables x, y, xbar, and ybar.
% ENTER CODE BELOW

%% Local Helper Functions
function yhat = PlotFit(x,y,A,ErrorFlag)

% Prepare data and compute the model predictions
powers = length(A)-1:-1:0;
X = x'.^powers;
yhat = A*X';

% Plot
plot(x,y,"o");
DispLine = sprintf("\nLine fit \n" + "y = " + join(A + ["x^{"+string(powers(1:end-1))+"}",""] ," + "),"Interpreter","tex");
xlim([min(x)-0.5,max(x)+0.5]);
ylim([min(y)-0.5,max(y)+0.5]);
hold on
fplot(@(x)A*(x'.^powers)',"LineWidth",1.5);
legend("Data samples",DispLine,"Location","eastoutside")
hold off
xlabel("x")
ylabel("y")
title("Linear model")

if ErrorFlag
    hold on
    DispSSE = sprintf("\nErrors \nSSE = %12g",sum(yhat-y).^2);
    errorbar(x,y,min(yhat-y,0),max(yhat-y,0),".","vertical","DisplayName",DispSSE,SeriesIndex = 3);
    hold off
end

end