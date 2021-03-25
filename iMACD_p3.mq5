#include<Trade\Trade.mqh>
CTrade   trade;

input int S=50;
input int F=20;
input int ma=2;
input int rangess=2;

void OnTick()
  {
//---
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   //MqlRates PriceInfo[];
   
   //int PriceData = CopyRates(_Symbol,_Period,0,3,PriceInfo);
   
   string signal="";
   string previus_signal="";
   
   double MACDArray[],MACDArray2[],stdArray[];
   
   //int std_deviationDefinition = iATR(_Symbol,_Period,300);
   int MACDDefinition = iMACD(_Symbol,_Period,F,S,ma,PRICE_CLOSE); 
   
   CopyBuffer(MACDDefinition,1,0,3,MACDArray);
   CopyBuffer(MACDDefinition,0,0,3,MACDArray2);
   //CopyBuffer(std_deviationDefinition,0,0,3,stdArray);
   //double newM[]=MACDArray2-MACDArray;
   //Comment(newM);
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
        signal="";
       }
  
   Comment("sd",CountBuyPositions());
   if(PositionsTotal()<5)
     {
      if(signal=="sell" & CountSellPositions()<2)
         {trade.Sell(0.01,NULL,Bid,0,(Bid-150*_Point),NULL);
         previus_signal="sell";
         }
      
      if(signal=="buy" & CountBuyPositions()<2)
         {trade.Buy(0.01,NULL,Ask,0,Ask+150*_Point,NULL);
         previus_signal="buy";}
     }

//Comment(MathMin(0.6*rangess*stdArray[0],400*_Point));
   //Comment("Signal es: ", _Point);
        
     
      
     }
   
 
//+------------------------------------------------------------------+

int CountBuyPositions(){
   int NumberOfPositions=0;
   
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      string CurrencyPair = PositionGetTicket(i);
      int positionDirection = PositionGetInteger(POSITION_TYPE);
      
      if(positionDirection==POSITION_TYPE_BUY)
        {
         NumberOfPositions=NumberOfPositions+1;
        }
     }
     
     return NumberOfPositions;
}

int CountSellPositions(){
   int NumberOfPositions=0;
   
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      string CurrencyPair = PositionGetTicket(i);
      int positionDirection = PositionGetInteger(POSITION_TYPE);
      
      if(positionDirection==POSITION_TYPE_SELL)
        {
         NumberOfPositions=NumberOfPositions+1;
        }
     }
     
     return NumberOfPositions;
}