#include<Trade\Trade.mqh>
CTrade   trade;

void OnTick()
  {
//---
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   if((OrdersTotal()==0)&&(PositionsTotal()==0))
     {
      trade.SellLimit
      (
      0.10, // Lot size
      Bid+(200*_Point),   //Price for buy limit
      _Symbol,
      0,
      Bid+(100*_Point),
      ORDER_TIME_GTC,
      0,
      NULL     
      );
  
     }
     Comment(_Point);
  
  }
//+------------------------------------------------------------------+
