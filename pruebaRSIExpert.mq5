//+------------------------------------------------------------------+
//|                                              pruebaRSIExpert.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//--- input parameters
input int      Input1;
input int      Input2;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>                                         //include the library for execution of trades
#include <Trade\PositionInfo.mqh>                                  //include the library for obtaining information on positions

int               iMA_handle;                              //variable for storing the indicator handle
int               myRSIDefinition ;
double            iMA_buf[];                               //dynamic array for storing indicator values
double            Close_buf[];                             //dynamic array for storing the closing price of each bar
double            myRSIArray[];



string            my_symbol;                               //variable for storing the symbol
ENUM_TIMEFRAMES   my_timeframe;                             //variable for storing the time frame

CTrade            m_Trade;                                 //structure for execution of trades
CPositionInfo     m_Position;                              //structure for obtaining information of positions
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit() {
   my_symbol = Symbol();                                    //save the current chart symbol for further operation of the EA on this very symbol
   my_timeframe = PERIOD_CURRENT;                            //save the current time frame of the chart for further operation of the EA on this very time frame
   iMA_handle = iMA(my_symbol, my_timeframe, 40, 0, MODE_SMA, PRICE_CLOSE); //apply the indicator and get its handle
   myRSIDefinition = iRSI(my_symbol, my_timeframe, 14, PRICE_CLOSE);
   if(iMA_handle == INVALID_HANDLE) {                        //check the availability of the indicator handle
      Print("Failed to get the indicator handle");              //if the handle is not obtained, print the relevant error message into the log file
      return(-1);                                           //complete handling the error
   }
   ChartIndicatorAdd(ChartID(), 0, iMA_handle);                //add the indicator to the price chart
   ArraySetAsSeries(iMA_buf, true);                           //set iMA_buf array indexing as time series
   ArraySetAsSeries(Close_buf, true);                         //set Close_buf array indexing as time series
   ArraySetAsSeries(myRSIArray, true);
   return(0);                                               //return 0, initialization complete
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   IndicatorRelease(iMA_handle);                             //deletes the indicator handle and deallocates the memory space it occupies
   ArrayFree(iMA_buf);                                      //free the dynamic array iMA_buf of data
   ArrayFree(Close_buf);                                    //free the dynamic array Close_buf of data
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
   int err1 = 0;                                           //variable for storing the results of working with the indicator buffer
   int err2 = 0;                                           //variable for storing the results of working with the price chart
   int err3 = 0;
   err1 = CopyBuffer(iMA_handle, 0, 1, 2, iMA_buf);         //copy data from the indicator array into the dynamic array iMA_buf for further work with them
   err2 = CopyClose(my_symbol, my_timeframe, 1, 2, Close_buf); //copy the price chart data into the dynamic array Close_buf for further work with them
   err3 = CopyBuffer(myRSIDefinition, 0, 0, 3, myRSIArray);
   if(err1 < 0 || err2 < 0) {                              //in case of errors
      Print("Failed to copy data from the indicator buffer or price chart buffer");  //then print the relevant error message into the log file
      return;                                                               //and exit the function
   }
   if(myRSIArray[1] < 30) { //if the indicator values were greater than the closing price and became smaller
      if(m_Position.Select(my_symbol)) {                   //if the position for this symbol already exists
         if(m_Position.PositionType() == POSITION_TYPE_SELL)
            m_Trade.PositionClose(my_symbol);  //and this is a Sell position, then close it
         if(m_Position.PositionType() == POSITION_TYPE_BUY)
            return;                              //or else, if this is a Buy position, then exit
      }
      m_Trade.Buy(0.01, my_symbol);                         //if we got here, it means there is no position; then we open it
   }
   if(myRSIArray[1] > 70) { //if the indicator values were less than the closing price and became greater
      if(m_Position.Select(my_symbol)) {                   //if the position for this symbol already exists
         if(m_Position.PositionType() == POSITION_TYPE_BUY)
            m_Trade.PositionClose(my_symbol);   //and this is a Buy position, then close it
         if(m_Position.PositionType() == POSITION_TYPE_SELL)
            return;                             //or else, if this is a Sell position, then exit
      }
      if(PositionsTotal() == 0) {
       //  m_Trade.Sell(0.01, my_symbol);                        //if we got here, it means there is no position; then we open it
      }
   }
   double myRSIValue = NormalizeDouble(myRSIArray[0], 2);
}
//+--------------------------------
