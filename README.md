# Time-Series-Forecasting

This project will use two different time series models Autoregressive Integrated Moving Average (ARIMA) model and Generalized Autoregressive Conditional Heteroskedasticity (GARCH) model in forecasting the returns of the SPY ETF which tracks the of the S&P 500. Time series will be fitted from the end of March 2019 to the end of September 2020 using the aforementioned models which will be used to forecast the short term returns of SPY during the beginning of October 2020. The purpose of forecasting is to find out if there are predictive buying and selling signals.  

### ARIMA Model: (Coding done in R)
The ETF prices have been transformed to the daily log returns to remove stationarity from the time series as shown in the figure below. Then, the Augmented Dickey-Fuller (ADF) test  is applied to check if stationarity is removed or not. The result of the ADF test indicate that data is stationary and ready to be fitted using the ARIMA model. 
!()[]
To choose the parameters of the ARIMA, the auto.arima function in the package forecast in R is used. The function indicates that ARIMA(2,0,4) fit this data the best according to AIC criteria. In order to check the selection of the parameters, ACF and PACF plots applied on the data and the plots indicate that the selection of ARIMA (2,0,4) is reasonable. 
  !()[]
The accuracy of the ARIMA(2,0,4) on that the specific time period is 66% which is based on the direction, so for example when the predicted return of a given day is positive and the actual return is positive as well, then that is considered as a correct prediction. On the other hand, when the predicted return of a given day is negative and the actual return is positive, then that is considered as an incorrect prediction. The figure below shows the predicted returns (on red) versus the actual returns. 
!()[]   

### GARCH Model: (Coding done in Python)

To make the data stationary, the percentage change is taken as shown below:
!()[] 
The PACF plot indicates the order is GARCH (2,2) and when the model is fitted the coefficients are significant.

!()[]

The true returns and the predicated volatility during the period is shown in the figure below:

!()[]

Then, the forecasted volatility on unseen data for the next 7 days is plotted below where we can see increased volatility of the next 7 trading days:  

!()[]

To back test the forecasted volatility, the returns of the SPY checked during that period as seen on the graph below where the volatility of SPY increased. 

!()[]
