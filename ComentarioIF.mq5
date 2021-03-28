//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
//---
   Comment("La hora es: ", TimeLocal());
   int a = 2;
   int b = 4;
   int c = a + b;
   if (c > 3)
      Comment("Condicion es True");
   else
      Comment("Condicion es False");
}
//+------------------------------------------------------------------+
