library(quantmod)
library(tseries)
library(timeSeries)
library(forecast)
library(xts)

# Pull data from Yahoo finance 
getSymbols('SPY', from='2019-3-28', to='2020-10-8')
head(SPY)

# Select the closing price
stock_p <- SPY[,4]
head(stock_p)

# Daily log Return
stock_r <- periodReturn(stock_p, period = "daily", type = "log")
head(stock_r)
dim(stock_r)

# Plot log returns 
plot(stock_r, type='l', main='log returns plot')


# Conduct ADF test on log returns 
print(adf.test(stock_r))

# the small P-value indicate the log returns are stationary

# Split the dataset in two parts - training and testing
breakpoint = floor(nrow(stock_r)*(.971))

train = stock_r[c(1:breakpoint),]


# use the auto.arima to choose the best ARIMA Parameters
fit1 = auto.arima(train,d=0,max.p=10,max.q=10,max.order=6,ic="aic",
                  seasonal=FALSE,stepwise=FALSE,trace=TRUE,
                  approximation=FALSE,allowdrift=FALSE,allowmean=FALSE)


# ARIMA(2,0,4) fits the best usign AIC criteria 




# Apply the ACF and PACF functions
par(mfrow = c(2,1))
acf.stock = acf(stock_r[c(1:breakpoint),], main='ACF Plot')
pacf.stock = pacf(stock_r[c(1:breakpoint),], main='PACF Plot')



# Initialzing an xts object for Actual log returns
Actual_series = xts(0,as.Date("2019-3-28","%Y-%m-%d"))

# Initialzing a dataframe for the forecasted return series
forecasted_series = data.frame(Forecasted = numeric())

for  (n in breakpoint:(nrow(stock_r)-1)) {
  
  stock_train = stock_r[1:n, ]
  stock_test = stock_r[(n+1):nrow(stock_r), ]
  
  # Summary of the ARIMA model using the determined (p,d,q) parameters
  fit = arima(stock_train, order = c(2, 0, 4),include.mean=FALSE)
  summary(fit)
  
  
  # Forecasting the log returns
  arima.forecast = forecast(fit, h = 1,level=95)
  summary(arima.forecast)
  
  
  # Creating a series of forecasted returns for the forecasted period
  forecasted_series = rbind(forecasted_series,arima.forecast$mean[1])
  colnames(forecasted_series) = c("Forecasted")
  
  # Creating a series of actual returns for the forecasted period
  Actual_return = stock_r[(n+1),]
  Actual_series = c(Actual_series,xts(Actual_return))
  rm(Actual_return)
  
}


# plotting the forecast
par(mfrow=c(1,1))
plot(arima.forecast, main = "ARIMA Forecast")


# Adjust the length of the Actual return series
Actual_series = Actual_series[-1]

# Create a time series object of the forecasted series
forecasted_series = xts(forecasted_series,index(Actual_series))

# Create a plot of the two return series - Actual versus Forecasted
plot(Actual_series,type='l',main='Actual Returns Vs Forecasted Returns', col = "black")
lines(forecasted_series, lwd=2,col='red')

# Create a table for the accuracy of the forecast
comparsion = cbind(Actual_series,forecasted_series)
comparsion$Accuracy = sign(comparsion$Actual_series)==sign(comparsion$Forecasted)
print(comparsion)

# Create a table for the accuracy 
table(comparsion$Accuracy)

# the accuracy percentage 
Accuracy_percentage = (sum(comparsion$Accuracy == 1)/length(comparsion$Accuracy))*100
print(Accuracy_percentage)

