//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include<Trade\Trade.mqh>
CTrade   trade;

input int S = 50;
input int F = 20;
input int ma = 2;
input int TK_pips = 2;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick() {
//---
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
//MqlRates PriceInfo[];
//int PriceData = CopyRates(_Symbol,_Period,0,3,PriceInfo);
   string signal = "";
   string previus_signal = "";
   double MACDArray[], MACDArray2[], stdArray[];
//int std_deviationDefinition = iATR(_Symbol,_Period,300);
   int MACDDefinition = iMACD(_Symbol, _Period, F, S, ma, PRICE_CLOSE);
   CopyBuffer(MACDDefinition, 1, 0, 3, MACDArray);
   CopyBuffer(MACDDefinition, 0, 0, 3, MACDArray2);
//CopyBuffer(std_deviationDefinition,0,0,3,stdArray);
//double newM[]=MACDArray2-MACDArray;
//Comment(newM);
   if(MACDArray[2]*MACDArray[1] < 0) {
      //Sleep(5000);
      if (MACDArray[1] > 0)
         signal = "sell";
      if (MACDArray[1] < 0)
         signal = "buy";
   } else {
       signal = "";
   }
   if(PositionsTotal() < 2) {
      if(signal == "sell") {
         trade.Sell(0.01, NULL, Bid, Bid + 0.6 * TK_pips * _Point, Bid - TK_pips * _Point, NULL);
         previus_signal = "sell";
      }
      if(signal == "buy") {
         trade.Buy(0.01, NULL, Ask, Ask - 0.6 * TK_pips * _Point, Ask + TK_pips * _Point, NULL);
         previus_signal = "buy";
      }
   }
//Comment(MathMin(0.6*rangess*stdArray[0],400*_Point));
//Comment("Signal es: ", _Point);
}


//+------------------------------------------------------------------+
