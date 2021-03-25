#include<Trade\Trade.mqh>
CTrade   trade;

void OnTick()
  {
//---
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   MqlRates PriceInfo[];
   
   int PriceData = CopyRates(_Symbol,_Period,0,3,PriceInfo);
   
   string signal="";
   
   double myMovingAverageArray[];
   
   int movingAverageDefinition = iMA(_Symbol,_Period,20,0,MODE_SMA,PRICE_CLOSE); 
   
   CopyBuffer(movingAverageDefinition,0,0,3,myMovingAverageArray);
   
   if (PriceInfo[1].close > myMovingAverageArray[1])
   if (PriceInfo[2].close < myMovingAverageArray[2])
   {signal="buy";}
   if (PriceInfo[1].close < myMovingAverageArray[1])
   if (PriceInfo[2].close > myMovingAverageArray[2])
   {signal="sell";}
   
   if(signal=="sell" && PositionsTotal()<1)
      trade.Sell(0.1,NULL,Bid,0,(Bid-150*_Point),NULL);
      
   if(signal=="buy" && PositionsTotal()<1)
      trade.Buy(0.1,NULL,Ask,0,Ask+150*_Point,NULL);
      
   Comment("Signal es: ", signal);
        
     
      
     }
   
 
//+------------------------------------------------------------------+
