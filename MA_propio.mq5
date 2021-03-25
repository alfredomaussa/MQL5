#include<Trade\Trade.mqh>
CTrade   trade;

input int S=26,F=16,ma=7;
input double thres = 0.0006;
input int max_pip_SL=630;
input int ma_period_ADX=15;
input int ADX_sup=60;
double lineal_coeff;
input double a0,a1,a2,a3,b0,b1;
input int under_n_ATR=2;
double stdArray[];
input int k_period,d_period,slowing;
input int sto_inf=10,sto_sup=10;
double perdidas_consecutivas=0;
double Last_Balance=600;
void OnTick()
  {
//---
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   string signal = "None";
   double MAArray[];

   
   int MA_Definition = iMA(_Symbol,PERIOD_M15,S,0,MODE_EMA,PRICE_CLOSE);
    
    if(PositionsTotal()<1)
        {    

     //double range=b0*stdArray[1]+MathAbs(b1*lineal_coeff)*_Point;
     double lote=0.01*floor(1/pow(0.9,perdidas_consecutivas));
     //Comment(lote);
      if(signal=="sell")
         trade.Sell(lote,NULL,Bid,Bid+0.5*160*_Point,Bid-0.5*60*_Point,NULL);
      
      if(signal=="buy")
         trade.Buy(lote,NULL,Ask,Ask-0.5*160*_Point,Ask+0.5*60*_Point,NULL);
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
     
  