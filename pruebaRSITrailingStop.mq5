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
input int max_pip_SL = 160;
input double under_n_ATR = 13.5;
input int ATR_ma_period = 14;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>                                         //include the library for execution of trades
#include <Trade\PositionInfo.mqh>                                  //include the library for obtaining information on positions

int               iMA_handle;                              //variable for storing the indicator handle
int               myRSIDefinition ;
int std_deviationDefinition;
double            iMA_buf[];                               //dynamic array for storing indicator values
double            Close_buf[];                             //dynamic array for storing the closing price of each bar
double            myRSIArray[];
double            stdArray[];


string            my_symbol;                               //variable for storing the symbol
ENUM_TIMEFRAMES   my_timeframe;                             //variable for storing the time frame

CTrade            trade;                                 //structure for execution of trades
CPositionInfo     m_Position;                              //structure for obtaining information of positions
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit() {
   my_symbol = Symbol();                                    //save the current chart symbol for further operation of the EA on this very symbol
   my_timeframe = PERIOD_CURRENT;                            //save the current time frame of the chart for further operation of the EA on this very time frame
   iMA_handle = iMA(my_symbol, my_timeframe, 40, 0, MODE_SMA, PRICE_CLOSE); //apply the indicator and get its handle
   myRSIDefinition = iRSI(my_symbol, my_timeframe, 14, PRICE_CLOSE);
   std_deviationDefinition = iATR(_Symbol, _Period, ATR_ma_period);
   if(iMA_handle == INVALID_HANDLE) {                        //check the availability of the indicator handle
      Print("Failed to get the indicator handle");              //if the handle is not obtained, print the relevant error message into the log file
      return(-1);                                           //complete handling the error
   }
   ChartIndicatorAdd(ChartID(), 0, iMA_handle);                //add the indicator to the price chart
   ArraySetAsSeries(iMA_buf, true);                           //set iMA_buf array indexing as time series
   ArraySetAsSeries(Close_buf, true);                         //set Close_buf array indexing as time series
   ArraySetAsSeries(myRSIArray, true);
   ArraySetAsSeries(stdArray, true);
   return(0);                                               //return 0, initialization complete
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   IndicatorRelease(iMA_handle);                             //deletes the indicator handle and deallocates the memory space it occupies
   ArrayFree(iMA_buf);                                      //free the dynamic array iMA_buf of data
   ArrayFree(Close_buf);                                    //free the dynamic array Close_buf of data
   ArrayFree(stdArray);
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
   double myRSIValue = NormalizeDouble(myRSIArray[0], 2);
   if(PositionsTotal() == 0) {
      if(myRSIArray[1] < 30) { //if the indicator values were greater than the closing price and became smaller
         trade.Buy(0.01, my_symbol, NULL, 1.1);                      //if we got here, it means there is no position; then we open it
      }
   }
   CheckTrailingStop();
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TrailingStop() {
   ulong PositionTicket = PositionGetTicket(0);
   double CurrentStopLoss = PositionGetDouble(POSITION_SL);
   trade.PositionModify(PositionTicket, CurrentStopLoss + 10 * _Point, 0);
   Comment(CurrentStopLoss);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckTrailingStop() {
   CopyBuffer(std_deviationDefinition, 0, 0, 3, stdArray);
   for(int i = 0; i < PositionsTotal(); i++) {
      ulong PositionTicket = PositionGetTicket(i);
      double varPOSITION_PRICE_CURRENT = PositionGetDouble(POSITION_PRICE_CURRENT);
      if(PositionGetInteger(POSITION_TYPE) == 0) {
         // si es compra
         double SL = NormalizeDouble(varPOSITION_PRICE_CURRENT-MathMin(under_n_ATR * stdArray[1], max_pip_SL * _Point), _Digits);
         double CurrentStopLoss = PositionGetDouble(POSITION_SL);
         if(CurrentStopLoss < SL) {
            trade.PositionModify(PositionTicket, SL, 0);
         }
      } else {
         // si es venta
         double SL = NormalizeDouble(varPOSITION_PRICE_CURRENT +  max_pip_SL * _Point, _Digits);
         double CurrentStopLoss = PositionGetDouble(POSITION_SL);
         if(CurrentStopLoss > SL) {
            trade.PositionModify(PositionTicket, CurrentStopLoss - 10 * _Point, 0);
         }
      }
   }
}

//+------------------------------------------------------------------+
