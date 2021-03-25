#include<Trade\Trade.mqh>
CTrade   trade;

input int SmallMovingAverage=20;
input int BigMovingAverage=50;
input double rangess=20;
input int periodee=300;

void OnTick()
  {
//---
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   //MqlRates PriceInfo[];
   
   //int PriceData = CopyRates(_Symbol,_Period,0,3,PriceInfo);
   
   string signal="";
   
   double SmallMovingAverageArray[],BigMovingAverageArray[],stdArray[];
   
   int SmallmovingAverageDefinition = iMA(_Symbol,_Period,SmallMovingAverage,0,MODE_SMA,PRICE_CLOSE); 
   int BigmovingAverageDefinition = iMA(_Symbol,_Period,BigMovingAverage,0,MODE_SMA,PRICE_CLOSE); 
   //int std_deviationDefinition = iStdDev(_Symbol,_Period,300,0,MODE_SMA,PRICE_CLOSE);
   int std_deviationDefinition = iATR(_Symbol,_Period,periodee);
   
   CopyBuffer(SmallmovingAverageDefinition,0,0,3,SmallMovingAverageArray);
   CopyBuffer(BigmovingAverageDefinition,0,0,3,BigMovingAverageArray);
   CopyBuffer(std_deviationDefinition,0,0,3,stdArray);
   
   if (BigMovingAverageArray[1] > SmallMovingAverageArray[1])
      if(BigMovingAverageArray[2] < SmallMovingAverageArray[2])
        signal="buy";
   if (BigMovingAverageArray[1] < SmallMovingAverageArray[1])
      if(BigMovingAverageArray[2] > SmallMovingAverageArray[2])
        signal="sell";     
        
   int random=rand()%10;
   if(PositionsTotal()<1 && (random==1))
     {
      if(signal=="sell")
         trade.Sell(0.1,NULL,Bid,Bid+0.6*rangess*stdArray[0],(Bid-rangess*stdArray[0]),NULL);
      
      if(signal=="buy")
         trade.Buy(0.1,NULL,Ask,Ask-0.6*rangess*stdArray[0],Ask+rangess*stdArray[0],NULL);
     }
     else
       {
        //signal="";
       }

   //Comment("Signal es: ", rand()%5);
        
     
      
     }
   
 
//+------------------------------------------------------------------+
