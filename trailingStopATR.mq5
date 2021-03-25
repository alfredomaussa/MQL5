//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include<Trade\Trade.mqh>
CTrade   trade;

input int max_pip_SL = 160;
input double under_n_ATR = 13.5;
input int ATR_ma_period = 10;
double stdArray[];
void OnTick() {
//---
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   int std_deviationDefinition = iATR(_Symbol, _Period, ATR_ma_period);
   CopyBuffer(std_deviationDefinition, 0, 0, 3, stdArray);
   CheckTrailingStop((Ask + Bid) / 2);
   Comment("ATR in pips: ", int(stdArray[1] * 100000), "\n", "SL_by_ATR: ", int(under_n_ATR * int(stdArray[1] * 100000)));
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckTrailingStop(double Ask) {
   for(int i = 0; i < PositionsTotal(); i++) {
      ulong PositionTicket = PositionGetTicket(i);
      if(PositionGetInteger(POSITION_TYPE) == 0) {
         // si es compra
         double SL = NormalizeDouble(Ask - MathMin(under_n_ATR * stdArray[1], max_pip_SL * _Point), _Digits);
         double CurrentStopLoss = PositionGetDouble(POSITION_SL);
         if(CurrentStopLoss < SL) {
            trade.PositionModify(PositionTicket, CurrentStopLoss + 10 * _Point, 0);
         }
      } else {
         // si es venta
         double SL = NormalizeDouble(Ask + MathMin(under_n_ATR * stdArray[1], max_pip_SL * _Point), _Digits);
         double CurrentStopLoss = PositionGetDouble(POSITION_SL);
         if(CurrentStopLoss > SL) {
            trade.PositionModify(PositionTicket, CurrentStopLoss - 10 * _Point, 0);
         }
      }
   }
}

//+------------------------------------------------------------------+
