int DelayCounter = 1;

int MinNumber = 500000;

void OnTick()
  {
//---
   while(DelayCounter<MinNumber)
     {
      Comment("Contador: ",DelayCounter);
      DelayCounter+=1;
     }
  }
//+------------------------------------------------------------------+
