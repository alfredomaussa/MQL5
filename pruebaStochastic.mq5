#include<Trade\Trade.mqh>
CTrade   trade;

input int S=26,F=16,ma=7;
input double thres = 0.0006;
input int max_pip_SL=630;
input int ma_period_ADX=10;
int sto_sup=80,sto_inf=20;
input int ADX_sup=60;
double lineal_coeff;
input double a0,a1,a2,a3,b0,b1;
input int under_n_ATR=2;
double stdArray[];
input int k_period,d_period,slowing;
void OnTick()
  {
//---
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   //MqlRates PriceInfo[];
   
   //int PriceData = CopyRates(_Symbol,_Period,0,3,PriceInfo);
   
   string signal_MACD="None";
   string signal_sto = "None";
   string signal_ADX = "None";
   double MAArray[];
   double MACDArray1[],MACDArray2[];
   double ADXArray1[],ADXArray2[];
   double stoArray[];
   
   int MA_Definition = iMA(_Symbol,PERIOD_M15,S,0,MODE_EMA,PRICE_CLOSE);
   int MACD_Definition = iMACD(_Symbol,PERIOD_M15,F,S,ma,PRICE_CLOSE); 
   int ADX_Definition = iADX(_Symbol,PERIOD_M15,ma_period_ADX);
   int Stochastic_Definition = iStochastic(_Symbol,PERIOD_M15,k_period,d_period,slowing,MODE_SMA,STO_LOWHIGH);
   int std_deviationDefinition = iATR(_Symbol,PERIOD_M1,10);
   
   CopyBuffer(MACD_Definition,1,0,3,MACDArray1);
   CopyBuffer(MACD_Definition,0,0,3,MACDArray2);
   
   CopyBuffer(ADX_Definition,1,0,3,ADXArray1);
   CopyBuffer(ADX_Definition,0,0,3,ADXArray2);
   
   CopyBuffer(Stochastic_Definition,1,0,3,stoArray);

   CopyBuffer(std_deviationDefinition,0,0,3,stdArray);
   
            
    if(ADXArray2[1]>ADX_sup)
      {
       signal_ADX="up";
       lineal_coeff=a0+a2*(stoArray[0]-50)/100+0*a3*(stoArray[1]-stoArray[0])/10;
      if (lineal_coeff > 0)
         signal_MACD="sell";
      else
         signal_MACD="buym";
      }
      else
        {
         signal_MACD="None";
        }
    //Comment("MACD: ",signal_MACD,"\n","Stochastic: ",signal_sto,"\n","ADX: ",signal_ADX);
    Comment("Stochastic: ",stoArray[0],"\n",lineal_coeff);
        
    // lineal combination
    
           

        
   if(PositionsTotal()<1)
     {
     double range=b0*stdArray[1]+MathAbs(b1*lineal_coeff)*_Point;
      if(signal_MACD=="sell")
         trade.Sell(0.01,NULL,Bid,Bid+range,Bid-range,NULL);
      
      if(signal_MACD=="buy")
         trade.Buy(0.01,NULL,Ask,Ask-range,Ask+range,NULL);
     }


//CheckTrailingStop((Ask+Bid)/2);
     }
     

//+------------------------------------------------------------------+

     void CheckTrailingStop(double Ask)
     {
     
     for(int i=0;i<PositionsTotal();i++)
       {
     
     ulong PositionTicket = PositionGetTicket(i);
     
     //Comment(PositionGetInteger(POSITION_TYPE));
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