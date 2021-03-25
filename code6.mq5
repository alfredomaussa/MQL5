#include<Trade\Trade.mqh>
CTrade   trade;

void OnTick()
  {
//---
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   MqlRates PriceInfo[];
   
   ArraySetAsSeries(PriceInfo,true);
   
   int PriceData = CopyRates(_Symbol,_Period,0,3,PriceInfo);
   
   if (PriceInfo[1].close < PriceInfo[1].open)
   if(PositionsTotal()==0)
     {
      trade.Sell(0.01,NULL,Bid,Bid+300*_Point,Bid-150*_Point,NULL);
      Comment(Bid);
     }
  }
//+------------------------------------------------------------------+
