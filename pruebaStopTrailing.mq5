//+------------------------------------------------------------------+
//|                                           pruebaStopTrailing.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>   
  #include <Trade\SymbolInfo.mqh>
  #include <Trade\PositionInfo.mqh> 
  
CTrade            m_Trade; 
CPositionInfo     m_Position; 
CSymbolInfo       m_symbol;
string            my_symbol;
double ask;
double TP;

int OnInit()
  {
//--- create timer
   EventSetTimer(60);
         if (m_Position.Select(_Symbol))
{
  int newStoploss = 250;
  int newTakeprofit = 500;
  
  MqlTick tick;   
  SymbolInfoTick(_Symbol,tick);
  double SL = tick.ask-newStoploss*_Point; 
  TP = tick.ask + newTakeprofit*_Point;  

  //modify the open position for this symbol
   m_Trade.PositionModify(_Symbol,SL,TP);
   printf(m_Position.StopLoss());
}
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

      if (m_Position.Select(_Symbol))
{
  MqlTick tick;   
  SymbolInfoTick(_Symbol,tick);
 int newStoploss = 100;
 if (m_Position.StopLoss()<(tick.ask-newStoploss*_Point)){
 m_Trade.PositionModify(_Symbol,tick.ask-newStoploss*_Point,TP);
printf((tick.ask-newStoploss*_Point)); }
}
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+
