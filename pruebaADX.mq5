#include<Trade\Trade.mqh>
CTrade   trade;

input int S=26,F=16,ma=7;
input double thres = 0.0006;
input int max_pip_SL=630;
input int ma_period_ADX=15;
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
   
   string signal="None";
   string signal_MACD="None";
   string signal_sto = "None";
   string signal_ADX = "None";
   double MAArray[];
   double MACDArray1[],MACDArray2[];
   double ADXArray1[],ADXArray2[],ADXArray3[];
   double stoArray[];
   
   //int MA_Definition = iMA(_Symbol,PERIOD_M15,S,0,MODE_EMA,PRICE_CLOSE);
   //int MACD_Definition = iMACD(_Symbol,PERIOD_M15,F,S,ma,PRICE_CLOSE); 
   int ADX_Definition = iADX(_Symbol,PERIOD_M1,ma_period_ADX);
   int Stochastic_Definition = iStochastic(_Symbol,PERIOD_M15,k_period,d_period,slowing,MODE_SMA,STO_LOWHIGH);
   //int std_deviationDefinition = iATR(_Symbol,PERIOD_M1,10);
   
   //CopyBuffer(MACD_Definition,1,0,3,MACDArray1);
   //CopyBuffer(MACD_Definition,0,0,3,MACDArray2);
   
   CopyBuffer(ADX_Definition,0,0,3,ADXArray1);
   CopyBuffer(ADX_Definition,1,0,3,ADXArray2);
   CopyBuffer(ADX_Definition,2,0,3,ADXArray3);
   
   CopyBuffer(Stochastic_Definition,1,0,3,stoArray);
Comment(stoArray[2]);
   //CopyBuffer(std_deviationDefinition,0,0,3,stdArray);
   if(PositionsTotal()<1)
   {
   if(ADXArray1[2]>52)
     {
     if(ADXArray2[2]-ADXArray3[2]>0)
       {
        ObjectCreate(_Symbol,Ask,OBJ_ARROW_BUY,1,TimeCurrent(),50);
              
        
         trade.Buy(0.01,NULL,Ask,Ask-160*_Point,Ask+160*_Point,NULL);
        
       }
       else
         {
          ObjectCreate(_Symbol,Ask,OBJ_ARROW_SELL,1,TimeCurrent(),50);
          trade.Sell(0.01,NULL,Bid,Bid+140*_Point,Bid-140*_Point,NULL);
         }
      }
    }
        


//CheckTrailingStop((Ask+Bid)/2);
     }
     

//+------------------------------------------------------------------+

