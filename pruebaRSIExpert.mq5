//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, A4."
#property link      "None"
#property version   "1.00"
//--- input parameters
input int      Input1;
input int      Input2;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>

int               iMA_handle;
int               myRSIDefinition ;
double            iMA_buf[];
double            Close_buf[];
double            myRSIArray[];



string            my_symbol;
ENUM_TIMEFRAMES   my_timeframe;

CTrade            m_Trade;
CPositionInfo     m_Position;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit() {
   my_symbol = Symbol();
   my_timeframe = PERIOD_CURRENT;
   iMA_handle = iMA(my_symbol, my_timeframe, 40, 0, MODE_SMA, PRICE_CLOSE);
   myRSIDefinition = iRSI(my_symbol, my_timeframe, 14, PRICE_CLOSE);
   if(iMA_handle == INVALID_HANDLE) {
      Print("Failed to get the indicator handle");
      return(-1);
   }
   ChartIndicatorAdd(ChartID(), 0, iMA_handle);
   ArraySetAsSeries(iMA_buf, true);
   ArraySetAsSeries(Close_buf, true);
   ArraySetAsSeries(myRSIArray, true);
   return(0);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   IndicatorRelease(iMA_handle);
   ArrayFree(iMA_buf);
   ArrayFree(Close_buf);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
   int err1 = 0;
   int err2 = 0;
   int err3 = 0;
   err1 = CopyBuffer(iMA_handle, 0, 1, 2, iMA_buf);
   err2 = CopyClose(my_symbol, my_timeframe, 1, 2, Close_buf);
   err3 = CopyBuffer(myRSIDefinition, 0, 0, 3, myRSIArray);
   if(err1 < 0 || err2 < 0) {
      Print("Failed to copy data from the indicator buffer or price chart buffer");
      return;
   }
   if(myRSIArray[1] < 30) {
      if(m_Position.Select(my_symbol)) {
         if(m_Position.PositionType() == POSITION_TYPE_SELL)
            m_Trade.PositionClose(my_symbol);
         if(m_Position.PositionType() == POSITION_TYPE_BUY)
            return;
      }
      m_Trade.Buy(0.01, my_symbol);
   }
   if(myRSIArray[1] > 70) {
      if(m_Position.Select(my_symbol)) {
         if(m_Position.PositionType() == POSITION_TYPE_BUY)
            m_Trade.PositionClose(my_symbol);
         if(m_Position.PositionType() == POSITION_TYPE_SELL)
            return;
      }
      if(PositionsTotal() == 0) {
         //  m_Trade.Sell(0.01, my_symbol);
      }
   }
   double myRSIValue = NormalizeDouble(myRSIArray[0], 2);
}
//+--------------------------------
