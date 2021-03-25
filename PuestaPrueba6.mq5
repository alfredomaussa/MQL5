#include<Trade\Trade.mqh>
CTrade   trade;

input int S=300;
input int F=135;
input int ma=7;
input double thres = 0.0006;
input double under_n_ATR = 7;
input double Atttr = 38;
double stdArray[];
input int max_pip_SL=630;

void OnTick()
  {
//---
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   //MqlRates PriceInfo[];
   
   //int PriceData = CopyRates(_Symbol,_Period,0,3,PriceInfo);
   
   string signal="";
   
   double MACDArray[],MACDArray2[];
   
   int BandsDefinition = iMA(_Symbol,_Period,S,0,MODE_EMA,PRICE_CLOSE);
   int MACDDefinition = iMACD(_Symbol,PERIOD_M15,F,S,ma,PRICE_CLOSE); 
   int std_deviationDefinition = iATR(_Symbol,_Period,Atttr);
   int std_deviationDefinition222 = iBands(_Symbol,_Period,20,0,3,PRICE_CLOSE);
   
   CopyBuffer(MACDDefinition,1,0,3,MACDArray);
   CopyBuffer(MACDDefinition,0,0,3,MACDArray2);
   CopyBuffer(std_deviationDefinition,0,0,3,stdArray);
   //double newM[]=MACDArray2-MACDArray;
   //Comment(newM);
   if(MACDArray2[2]*MACDArray2[1]<0 && MathAbs(MACDArray2[2]-MACDArray[2])<thres)
     {
     //Sleep(5000);
      if (MACDArray2[1] > 0)
         signal="sell";
      if (MACDArray2[1] < 0)
         signal="buy";
      //CloseActualPositions();
     }
     else
       {
        signal="";
       }
  
        
   if(PositionsTotal()<1)
     {
      if(signal=="sell")
         trade.Sell(0.01,NULL,Bid,Bid+max_pip_SL*_Point,0,NULL);
         //Bid+MathMin(0.6*rangess*stdArray[1],580*_Point)
      
      if(signal=="buy")
         trade.Buy(0.01,NULL,Ask,Ask-max_pip_SL*_Point,0,NULL);
         //Ask-MathMin(0.6*rangess*stdArray[1],580*_Point)
     }

        CheckTrailingStop((Ask+Bid)/2);
       
      
     }
     
     void CheckTrailingStop(double Ask)
     {
     
     for(int i=0;i<PositionsTotal();i++)
       {
     
     ulong PositionTicket = PositionGetTicket(i);
     
     Comment(PositionGetInteger(POSITION_TYPE));
     if(PositionGetInteger(POSITION_TYPE)==0)
       {// si es compra
        double SL = NormalizeDouble(Ask-MathMin(under_n_ATR*stdArray[1],max_pip_SL*_Point),_Digits);
    
        double CurrentStopLoss=PositionGetDouble(POSITION_SL);
     
        if(CurrentStopLoss<SL)
          {
           trade.PositionModify(PositionTicket,CurrentStopLoss+10*_Point,0);
          }
       }
     else
      {// en venta
       double SL = NormalizeDouble(Ask+MathMin(under_n_ATR*stdArray[1],max_pip_SL*_Point),_Digits);
  
       double CurrentStopLoss=PositionGetDouble(POSITION_SL);
  
       if(CurrentStopLoss>SL)
       {
        trade.PositionModify(PositionTicket,CurrentStopLoss-10*_Point,0);
       }
      }
 
     }
     }
   
 void CloseActualPositions()
 {
 int ticket = PositionGetTicket(0);
 trade.PositionClose(ticket);
 }
//+------------------------------------------------------------------+
