#include<Trade\Trade.mqh>
CTrade   trade;

input int S=26,F=16,ma=7;
input double thres = 0.0006;
input int max_pip_SL=630;
input int ma_period_ADX=35;
input int ADX_sup=60;
double lineal_coeff;
input double a0=-23,a1=3.3,a2=8,a3=5,a4=10,b0,b1;
input int under_n_ATR=2;
double stdArray[];
input int k_period,d_period,slowing;
input int sto_inf=10,sto_sup=10;
double perdidas_consecutivas=0;
double Last_Balance=600;
int LastAngle;
void OnTick()
  {
//---
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   string signal = "None";
   string signal_MACD="None";
   string signal_sto = "None";
   string signal_ADX = "None";
   double MAArray[];
   double MACDArray1[],MACDArray2[];
   double ADXArray1[],ADXArray2[],ADXArray3[];
   double stoArray[];
   
   int MA_Definition = iMA(_Symbol,PERIOD_M1,100,0,MODE_EMA,PRICE_CLOSE);
   int MACD_Definition = iMACD(_Symbol,PERIOD_M1,F,S,ma,PRICE_CLOSE); 
   int ADX_Definition = iADX(_Symbol,PERIOD_M1,ma_period_ADX);
   int Stochastic_Definition = iStochastic(_Symbol,PERIOD_M1,k_period,d_period,slowing,MODE_SMA,STO_LOWHIGH);
   int std_deviationDefinition = iATR(_Symbol,PERIOD_M1,10);
   
   CopyBuffer(MA_Definition,0,0,30,MAArray);
   
   CopyBuffer(MACD_Definition,1,0,3,MACDArray1);
   CopyBuffer(MACD_Definition,0,0,3,MACDArray2);
   
   CopyBuffer(ADX_Definition,0,0,3,ADXArray1);
   CopyBuffer(ADX_Definition,1,0,3,ADXArray2);
   CopyBuffer(ADX_Definition,2,0,3,ADXArray3);
   
   CopyBuffer(Stochastic_Definition,1,0,3,stoArray);

   CopyBuffer(std_deviationDefinition,0,0,3,stdArray);   

    if(PositionsTotal()<1)
        {    
         if(ADXArray1[2]>ADX_sup)
            signal="onp";
         if(stoArray[1] > sto_sup || stoArray[1] < sto_inf)
            {signal="onp";
            ObjectCreate(_Symbol,Ask,OBJ_ARROW,3,TimeCurrent(),50);}
         if(MACDArray1[2]*MACDArray1[1]<0)
           {signal="on";
           ObjectCreate(_Symbol,Ask,OBJ_ARROW,1,TimeCurrent(),0);}
         if((ADXArray2[1]-ADXArray3[1])*(ADXArray2[0]-ADXArray3[0])<0)
           {signal="onp";
           ObjectCreate(_Symbol,Bid,OBJ_ARROW,2,TimeCurrent(),ADXArray2[1]);}
      }
      
    //Comment("MACD: ",signal_MACD,"\n","Stochastic: ",signal_sto,"\n","ADX: ",signal_ADX);
    //Comment("MACD: ",MACDArray2[1],"\n","Stochastic: ",stoArray[0],"\n","ADX: ",(stoArray[1]-stoArray[0]),"\n",lineal_coeff);
        
    // lineal combination
    
           

        
   if(PositionsTotal()<1)
     {
     
     double lote=0.01*floor(1/pow(0.9,perdidas_consecutivas));
     
      if(signal=="on")
         {
         Comment(10000*(MAArray[0]-MAArray[28]));
         ObjectCreate(_Symbol,Ask,OBJ_TRENDBYANGLE,0,TimeCurrent(),MAArray[28],0,0);
         LastAngle=MathTanh(1000*(MAArray[28]-MAArray[0]))*60; //in degree
         ObjectSetDouble(_Symbol,Ask,OBJPROP_ANGLE,LastAngle);
         
         signal="None";
         lineal_coeff=a0+a1*MACDArray1[1]*100000+a2*ADXArray1[1]/100+a3*stoArray[1]/100+a4*(LastAngle);
         if(lineal_coeff>0)
            trade.Sell(lote,NULL,Bid,Bid+30*_Point,Bid-20*_Point,LastAngle);}
      
      //if(signal=="buy")
        // trade.Buy(lote,NULL,Ask,Ask-0.5*160*_Point,Ask+0.5*60*_Point,NULL);
     }

//CheckPerdidas();
//((Ask+Bid)/2);
     }
     
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---

   if(AccountInfoDouble(ACCOUNT_BALANCE)<Last_Balance)
     {
     perdidas_consecutivas+=0.5;
      
     }
     if(AccountInfoDouble(ACCOUNT_BALANCE)>Last_Balance)
       {
         perdidas_consecutivas=0;
       }
      // Comment("Perdiste: ", perdidas_consecutivas);
   Last_Balance = AccountInfoDouble(ACCOUNT_BALANCE);
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
        double CurrentPrice=PositionGetDouble(POSITION_PRICE_CURRENT);

        if(CurrentStopLoss<SL)
          {
           trade.PositionModify(PositionTicket,CurrentStopLoss+0.05*(CurrentPrice-CurrentStopLoss),0);
          }
       }
     else
      {// en venta
       double SL = NormalizeDouble(Ask+MathMin(under_n_ATR*stdArray[1],max_pip_SL*_Point),_Digits);
         
       double CurrentStopLoss=PositionGetDouble(POSITION_SL);
       double CurrentPrice=PositionGetDouble(POSITION_PRICE_CURRENT);
       
       if(CurrentStopLoss>SL)
       {
        trade.PositionModify(PositionTicket,CurrentStopLoss-10*_Point,0);
       }
      }
 
     }
     }
     
  