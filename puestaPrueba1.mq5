#include<Trade\Trade.mqh>
CTrade   trade;

input int S=78;
input int F=15;
input int ma=50;
input int rangess=2;

void OnTick()
  {
//---
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   //MqlRates PriceInfo[];
   
   //int PriceData = CopyRates(_Symbol,_Period,0,3,PriceInfo);
   
   string signal="";
   
   double MACDArray[],stdArray[];
   
   int std_deviationDefinition = iATR(_Symbol,_Period,300);
   int MACDDefinition = iMACD(_Symbol,_Period,F,S,ma,PRICE_CLOSE); 
   
   CopyBuffer(MACDDefinition,1,0,3,MACDArray);
   CopyBuffer(std_deviationDefinition,0,0,3,stdArray);
   
   if(MACDArray[2]*MACDArray[1]<0)
     {
     //Sleep(5000);
      if (MACDArray[1] > 0)
         signal="sell";
      if (MACDArray[1] < 0)
         signal="buy";         
     }
     else
       {
        //signal="";
       }
  
        
   if(PositionsTotal()<1)
     {
      if(signal=="sell")
         trade.Sell(0.01,NULL,Bid,Bid+0.6*rangess*stdArray[1],(Bid-0.8*rangess*stdArray[1]),NULL);
         //Bid+MathMin(0.6*rangess*stdArray[1],580*_Point)
      
      if(signal=="buy")
         trade.Buy(0.01,NULL,Ask,Ask-0.6*rangess*stdArray[1],Ask+0.8*rangess*stdArray[1],NULL);
         //Ask-MathMin(0.6*rangess*stdArray[1],580*_Point)
     }

//Comment(MathMin(0.6*rangess*stdArray[0],400*_Point));
   //Comment("Signal es: ", _Point);
        
     
      
     }
   
 
//+------------------------------------------------------------------+
