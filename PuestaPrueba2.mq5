#include<Trade\Trade.mqh>
CTrade   trade;

input int rangess=10;
void OnTick()
  {
//---
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   //MqlRates PriceInfo[];
   
   //int PriceData = CopyRates(_Symbol,_Period,0,3,PriceInfo);
   
   string signal="";
   
   double myRSIArray[],stdArray[];
   
   int std_deviationDefinition = iATR(_Symbol,_Period,300);
   int RSIDefinition = iRSI(_Symbol,_Period,20,PRICE_CLOSE); 
   
   CopyBuffer(RSIDefinition,0,0,3,myRSIArray);
   CopyBuffer(std_deviationDefinition,0,0,3,stdArray);
   
   double myRSIValue = NormalizeDouble(myRSIArray[0],2);
   
 
     //Sleep(5000);
   if (myRSIValue > 70)
      signal="sell";
   if (myRSIValue < 30)
      signal="buy";         

  
        
   int random=1;//rand()%20;
   Comment(PositionsTotal());
   if(PositionsTotal()<1 && (random==1))
     {
      if(signal=="sell")
         trade.Sell(0.01,NULL,Bid,Bid+0.6*rangess*_Point,(Bid-rangess*_Point),NULL);
      
      if(signal=="buy")
         trade.Buy(0.01,NULL,Ask,Ask-0.6*rangess*_Point,Ask+rangess*_Point,NULL);
     }
     else
       {
        signal="";
       }


   //Comment("Signal es: ", rand()%5);
        
     
      
     }
   
 
//+------------------------------------------------------------------+
