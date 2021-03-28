//+------------------------------------------------------------------+
//|                                           crossMA a4.mq5 |
//|                        Copyright 2020, Alfr32 |
//|                                               |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, A4lfr32"
#property version   "1.7"

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>

int               iMA_fast;
int               iMA_slow;
double            iMAfast_buf[];
double            iMAslow_buf[];
double            iMACD_buf[];
double            Close_buf[];
double            min_volume;
int std_deviationDefinition;
int MACDDefinition;
double            iATR_buf[];
double Initbalance;

input double lossOperation          = 5;

double stopLoss;
double takeProfit;


string            my_symbol;
ENUM_TIMEFRAMES   my_timeframe;

CTrade            trade;
CPositionInfo     m_Position;
//+------------------------------------------------------------------+
//|    d                                                              |
//+------------------------------------------------------------------+
int OnInit() {
   my_symbol = Symbol();
   my_timeframe = PERIOD_CURRENT;
   iMA_fast = iMA(my_symbol, my_timeframe, 9, 0, MODE_SMA, PRICE_CLOSE);
   iMA_slow = iMA(my_symbol, my_timeframe, 40, 0, MODE_SMA, PRICE_CLOSE);
   std_deviationDefinition = iATR(_Symbol, _Period, 30);
   if(iMA_fast == INVALID_HANDLE) {
      Print("Failed to get the indicator handle");
      return(-1);
   }
   ChartIndicatorAdd(ChartID(), 0, iMA_fast);
   ArraySetAsSeries(iMAfast_buf, true);
   ArraySetAsSeries(Close_buf, true);
   min_volume = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
   Initbalance = AccountInfoDouble(ACCOUNT_BALANCE);
   return(0);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   IndicatorRelease(iMA_fast);
   ArrayFree(iMAfast_buf);
   ArrayFree(Close_buf);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
   // Comprobar si hay error en el indice
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   if(balance / Initbalance < 0.95 || balance<10) {
      return;
   }
   double Ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK); 
   double Bid = SymbolInfoDouble(_Symbol,SYMBOL_BID); 
   double dblCurrentSpreadPrice =  Ask- Bid;
   if(dblCurrentSpreadPrice>0.0001)
     {
      return;
     }
   
   Comment(dblCurrentSpreadPrice);
   
   int err1 = 0;
   int err2 = 0;
   int err3 = 0;
   int err4 = 0;
   err1 = CopyBuffer(iMA_fast, 0, 1, 2, iMAfast_buf);
   err2 = CopyBuffer(iMA_slow, 0, 1, 2, iMAslow_buf);
   err3 = CopyClose(my_symbol, my_timeframe, 1, 2, Close_buf);
   err4 = CopyBuffer(std_deviationDefinition, 0, 1, 2, iATR_buf);
   if(err1 < 0 || err2 < 0 || err3 < 0 || err4 < 0) {
      Print("Failed to copy data from the indicator buffer or price chart buffer");
      return;
   }
   // Comienza aca
   if(iMAslow_buf[1] > iMAfast_buf[1] && iMAslow_buf[0] < iMAfast_buf[0]) {
      // si la el precio de cierre corta y es mayor a la media movil (corte ascendente).
      // if(m_Position.Select(my_symbol)) {
      //    if(m_Position.PositionType() == POSITION_TYPE_SELL) {
      //    //--- Proximo trailing stop
      //    return;
      //       stopLoss = stopLoss - lossOperation * iATR_buf[1];
      //       takeProfit = takeProfit - lossOperation * iATR_buf[1];
      //       trade.PositionModify(my_symbol, stopLoss, takeProfit);
      //    }
      //    if(m_Position.PositionType() == POSITION_TYPE_BUY) return;
      // }
      // Si no hay posición abierta, abrirla en compra
      if(PositionsTotal() < 1) trade.Buy(min_volume, my_symbol, 0, Close_buf[0] - lossOperation * iATR_buf[1]-dblCurrentSpreadPrice, Close_buf[0] + 3 * lossOperation * iATR_buf[1]);
   }
   if(iMAslow_buf[1] < iMAfast_buf[1] && iMAslow_buf[0] > iMAfast_buf[0]) {
      // si la el precio de cierre corta y es menor a la media movil (corte descendente).
      // if(m_Position.Select(my_symbol)) {
      // //--- Proximo trailing stop
      //    return;
      //    if(m_Position.PositionType() == POSITION_TYPE_BUY) trade.PositionModify(my_symbol, iMA_buf[1] - 3 * lossOperation * iATR_buf[1], iMA_buf[1] + lossOperation * iATR_buf[1]);
      //    if(m_Position.PositionType() == POSITION_TYPE_SELL) return;
      // }
      // Si no hay posición abierta, abrirla en venta
      if(PositionsTotal() < 1) {
         stopLoss = Close_buf[0] + lossOperation * iATR_buf[1]+dblCurrentSpreadPrice;
         takeProfit = Close_buf[0] - 3 * lossOperation * iATR_buf[1];
         trade.Sell(min_volume, my_symbol, 0, stopLoss, takeProfit);
      }
   }

}
//+------------------------------------------------------------------+
