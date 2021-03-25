int choice = 5;

void OnTick()
  {
//---
string entry ="";

switch(choice)
  {
   case  5:
     entry+=" customer wants RSI";
     break;
   case  4:
     entry+=" customer wants Bollinger Bands";
     break;
   case  3:
     entry+=" customer wants MACD";
     break;   
   case  (1+1):
     entry+=" customer wants Random entries";
     break;   
   default:
     entry+=" customer dont know";
     break;
  }   
  
  Comment(entry);
  }
//+------------------------------------------------------------------+
