//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include<Trade\Trade.mqh>
CTrade   trade;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick() {
//---
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   MqlRates PriceInfo[];
   ArraySetAsSeries(PriceInfo, true);
   int PriceData = CopyRates(_Symbol, _Period, 0, 3, PriceInfo);
   if (PriceInfo[1].close > PriceInfo[1].open)
      if(PositionsTotal() == 0) {
         trade.Buy(0.10, NULL, Ask, Ask - 300 * _Point, Ask + 150 * _Point, NULL);
      }
}
//+------------------------------------------------------------------+
