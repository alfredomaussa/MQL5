# MQL5 repository codes - Metatrader expert advisor
Aquí pondré los códigos de MQL5
En este canal de youtube me he apoyado para los códigos: [url:https://www.youtube.com/channel/UCokIBdJXNOSOeYkKDvENWYA/videos]

---

## Contenido
* Comentar
* Swich case


### Simple code: Comment
``` MQL5
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
```
### Switch
<details>
  <summary>Mostrar <code>Codigo</code>, click aquí</summary>
   
   ``` MQL5
   //+------------------------------------------------------------------+
   //|                                                      ProjectName |
   //|                                      Copyright 2020, CompanyName |
   //|                                       http://www.companyname.net |
   //+------------------------------------------------------------------+
   int choice = 5;

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void OnTick() {
   //---
      string entry = "";
      switch(choice) {
      case  5:
         entry += " customer wants RSI";
         break;
      case  4:
         entry += " customer wants Bollinger Bands";
         break;
      case  3:
         entry += " customer wants MACD";
         break;
      case  (1+1):
         entry += " customer wants Random entries";
         break;
      default:
         entry += " customer dont know";
         break;
      }
      Comment(entry);
   }
   //+------------------------------------------------------------------+
   ```
</details>
### MACD (oscilator)

