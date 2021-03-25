
void OnTick()
  {
//---
double myMovingAverageArray[];

int movingAverageDefinition = iMA(_Symbol,_Period,20,0,MODE_SMA,PRICE_CLOSE);

//CopyBuffer(movingAverageDefinition,0,0,3,myMovingAverageArray); 

//float myMovingAverage20 = myMovingAverageArray[0];

//Comment("myMovingAverage20: ",myMovingAverage20);

  }
//+------------------------------------------------------------------+
