#include<Trade\Trade.mqh>
CTrade   trade;

input int rangess=100;
input double jaja1 = 0;
input double jaja2 = 0;
void OnTick()
  {
//---
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   //MqlRates PriceInfo[];
   
   //int PriceData = CopyRates(_Symbol,_Period,0,3,PriceInfo);
   
   string signal="";
   int MACDDefinition = iMA(_Symbol,_Period,100,0,MODE_SMA,PRICE_CLOSE);
   
   MqlRates PriceArray[];
   
   ArraySetAsSeries(PriceArray,true);
   
   int Data = CopyRates(_Symbol,_Period,0,3,PriceArray);
   
   double mySARArray[],MACDArray[];
   CopyBuffer(MACDDefinition,0,0,10,MACDArray);
   int SARDefinition = iSAR(_Symbol,_Period,0.02,0.2); 
   
   ArraySetAsSeries(mySARArray,true);
   
   CopyBuffer(SARDefinition,0,0,3,mySARArray);
   
   double LastSARValue = NormalizeDouble(mySARArray[1],5);
   double medianValue = (PriceArray[2].high+PriceArray[2].low)/2;
     //Sleep(5000);
     if((mySARArray[2]-medianValue)*(mySARArray[1]-medianValue)<0)
       {
      if (mySARArray[2] - mySARArray[1]< 0 && MACDArray[9]-MACDArray[1]<0)
         signal="sell";
      if (mySARArray[2] - mySARArray[1]> 0 && MACDArray[9]-MACDArray[1]>0)
         signal="buy";  
       }
       

   if(PositionsTotal()<1)
     {
      if(signal=="sell")
      {
         //trade.SellLimit(0.01,mySARArray[1],_Symbol,mySARArray[1]+rangess*_Point,mySARArray[1]-rangess*_Point,ORDER_TIME_SPECIFIED,TimeCurrent()+15*60*15);
         trade.SellStop(0.01,mySARArray[2],_Symbol,mySARArray[2]+0.6*rangess*_Point,mySARArray[2]-rangess*_Point,ORDER_TIME_SPECIFIED,TimeCurrent()+10*60*15);
         signal="";
      }
      if(signal=="buy")
      {
         //trade.BuyLimit(0.01,mySARArray[1],_Symbol,mySARArray[1]-rangess*_Point,mySARArray[1]+rangess*_Point,ORDER_TIME_SPECIFIED,TimeCurrent()+15*60*15);
         trade.BuyStop(0.01,mySARArray[2],_Symbol,mySARArray[2]-0.6*rangess*_Point,mySARArray[2]+rangess*_Point,ORDER_TIME_SPECIFIED,TimeCurrent()+15*60*15);
         signal="";
         //PriceArray[1].low-rangess*_Point//PriceArray[1].low+rangess*_Point
         }
     }
     else
       {
         if(signal!="")
           {
           Comment(PositionGetInteger(POSITION_TIME_UPDATE)/60);
           int ticket = PositionGetTicket(0);
           //trade.PositionClose(ticket);
           }
       }



        
     
      
     }
   
 
//+------------------------------------------------------------------+
