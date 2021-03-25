#include<Trade\Trade.mqh>
CTrade   trade;

input int rangess=3;
void OnTick()
  {
//---
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   //MqlRates PriceInfo[];
   
   //int PriceData = CopyRates(_Symbol,_Period,0,3,PriceInfo);
   
   string signal="";
   
   MqlRates PriceArray[];
   
   ArraySetAsSeries(PriceArray,true);
   
   int Data = CopyRates(_Symbol,_Period,0,3,PriceArray);
   
   double mySARArray[];
   
   int SARDefinition = iSAR(_Symbol,_Period,0.02,0.2); 
   
   ArraySetAsSeries(mySARArray,true);
   
   CopyBuffer(SARDefinition,0,0,3,mySARArray);
   
   double LastSARValue = NormalizeDouble(mySARArray[1],5);
   
 
     //Sleep(5000);
   if (LastSARValue > PriceArray[1].high)
      signal="buy";
   if (LastSARValue < PriceArray[1].low)
      signal="sell";         

  
        
   int random=1;//rand()%20;
   Comment(PositionsTotal());
   if(PositionsTotal()<1 && (random==1))
     {
      if(signal=="sell")
         trade.Sell(0.01,NULL,Bid,Bid+rangess*_Point,(Bid-rangess*_Point),NULL);
      
      if(signal=="buy")
         trade.Buy(0.01,NULL,Ask,Ask-rangess*_Point,Ask+rangess*_Point,NULL);
     }
     else
       {
        signal="";
       }


   //Comment("Signal es: ", rand()%5);
        
     
      
     }
   
 
//+------------------------------------------------------------------+
