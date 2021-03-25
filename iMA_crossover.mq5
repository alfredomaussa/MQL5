//---
// Cuando dos iMA se cruzan
// Solo tiene Take profit fijo

#include<Trade\Trade.mqh>
CTrade   trade;

input int SmallMovingAverage=20;
input int BigMovingAverage=50;

void OnTick()
  {
//---
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   //MqlRates PriceInfo[];
   
   //int PriceData = CopyRates(_Symbol,_Period,0,3,PriceInfo);
   
   string signal="";
   
   double SmallMovingAverageArray[],BigMovingAverageArray[];
   
   int SmallmovingAverageDefinition = iMA(_Symbol,_Period,SmallMovingAverage,0,MODE_SMA,PRICE_CLOSE); 
   int BigmovingAverageDefinition = iMA(_Symbol,_Period,BigMovingAverage,0,MODE_SMA,PRICE_CLOSE); 
   
   CopyBuffer(SmallmovingAverageDefinition,0,0,3,SmallMovingAverageArray);
   CopyBuffer(BigmovingAverageDefinition,0,0,3,BigMovingAverageArray);
   
   if (BigMovingAverageArray[1] > SmallMovingAverageArray[1])
      if(BigMovingAverageArray[2] < SmallMovingAverageArray[2])
        signal="buy";
   if (BigMovingAverageArray[1] < SmallMovingAverageArray[1])
      if(BigMovingAverageArray[2] > SmallMovingAverageArray[2])
        signal="Sell";     
        
   if(signal=="sell" && PositionsTotal()<1)
      trade.Sell(0.01,NULL,Bid,0,(Bid-150*_Point),NULL);
      
   if(signal=="buy" && PositionsTotal()<1)
      trade.Buy(0.01,NULL,Ask,0,Ask+150*_Point,NULL);
      
   Comment("Signal es: ", signal);
        
     
      
     }
   
 
//+------------------------------------------------------------------+
