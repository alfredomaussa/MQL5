//+------------------------------------------------------------------+
//|                                             PythonIndicators.mq5 |
//|                                   Copyright 2020, Andrey Dibrov. |
//|                           https://www.mql5.com/ru/users/tomcat66 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Andrey Dibrov."
#property link      "https://www.mql5.com/ru/users/tomcat66"
#property version   "1.00"
#property strict
#property script_show_inputs

input string Date="2004.07.01 00:00";
input string DateOut="2010.12.31 23:00";
input int History=0;

double Stochastic0[];
double Stochastic1[];
double CCI_Open[];
double CCI_Low[];
double CCI_High[];
double Momentum_Open[];
double Momentum_Low[];
double Momentum_High[];
double RSI_Open[];
double RSI_Low[];
double RSI_High[];
double WPR[];
double MACD_Open[];
double MACD_Low[];
double MACD_High[];
double OsMA_Open[];
double OsMA_Low[];
double OsMA_High[];
double TriX_Open[];
double TriX_Low[];
double TriX_High[];
double BearsPower[];
double BullsPower[];
double ADX_MINUSDI[];
double ADX_PLUSDI[];
double StdDev_Open[];
double StdDev_Low[];
double StdDev_High[];

//--------------------------
double DibMin1_1[];
double DibMax1_1 [];

int DibMin1_1Handle;
int DibMax1_1Handle;
//--------------------------
double inB[60];
double inS[60];

string Date1;

int HandleInputNet2OutNet1Min;
int HandleOutNet2Min;
int HandleInputNet2OutNet1Max;
int HandleOutNet2Max;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   int k=iBars(NULL,PERIOD_H1)-1;

//------ Daily Low

   DibMin1_1Handle=iCustom(NULL,PERIOD_H1,"DibMin1-1",History);
   CopyBuffer(DibMin1_1Handle,0,0,k,DibMin1_1);
   ArraySetAsSeries(DibMin1_1,true);

   DibMax1_1Handle=iCustom(NULL,PERIOD_H1,"DibMax1-1",History);
   CopyBuffer(DibMax1_1Handle,0,0,k,DibMax1_1);
   ArraySetAsSeries(DibMax1_1,true);

   int Stochastic_handle=iStochastic(NULL,PERIOD_H1,5,3,3,MODE_SMA,STO_LOWHIGH);
   CopyBuffer(Stochastic_handle,0,0,k,Stochastic0);
   CopyBuffer(Stochastic_handle,1,0,k,Stochastic1);
   ArraySetAsSeries(Stochastic0,true);
   ArraySetAsSeries(Stochastic1,true);

   int CCI_Open_handle=iCCI(NULL,PERIOD_H1,14,PRICE_OPEN);
   CopyBuffer(CCI_Open_handle,0,0,k,CCI_Open);
   ArraySetAsSeries(CCI_Open,true);

   int CCI_Low_handle=iCCI(NULL,PERIOD_H1,14,PRICE_LOW);
   CopyBuffer(CCI_Low_handle,0,0,k,CCI_Low);
   ArraySetAsSeries(CCI_Low,true);

   int Momentum_Open_handle=iMomentum(NULL,PERIOD_H1,14,PRICE_OPEN);
   CopyBuffer(Momentum_Open_handle,0,0,k,Momentum_Open);
   ArraySetAsSeries(Momentum_Open,true);

   int Momentum_Low_handle=iMomentum(NULL,PERIOD_H1,14,PRICE_LOW);
   CopyBuffer(Momentum_Low_handle,0,0,k,Momentum_Low);
   ArraySetAsSeries(Momentum_Low,true);

   int RSI_Open_handle=iRSI(NULL,PERIOD_H1,14,PRICE_OPEN);
   CopyBuffer(RSI_Open_handle,0,0,k,RSI_Open);
   ArraySetAsSeries(RSI_Open,true);

   int RSI_Low_handle=iRSI(NULL,PERIOD_H1,14,PRICE_LOW);
   CopyBuffer(RSI_Low_handle,0,0,k,RSI_Low);
   ArraySetAsSeries(RSI_Low,true);

   int WPR_handle=iWPR(NULL,PERIOD_H1,14);
   CopyBuffer(WPR_handle,0,0,k,WPR);
   ArraySetAsSeries(WPR,true);

   int MACD_Open_handle=iMACD(NULL,PERIOD_H1,12,26,9,PRICE_OPEN);
   CopyBuffer(MACD_Open_handle,0,0,k,MACD_Open);
   ArraySetAsSeries(MACD_Open,true);

   int MACD_Low_handle=iMACD(NULL,PERIOD_H1,12,26,9,PRICE_LOW);
   CopyBuffer(MACD_Low_handle,0,0,k,MACD_Low);
   ArraySetAsSeries(MACD_Low,true);

   int OsMA_Open_handle=iOsMA(NULL,PERIOD_H1,12,26,9,PRICE_OPEN);
   CopyBuffer(OsMA_Open_handle,0,0,k,OsMA_Open);
   ArraySetAsSeries(OsMA_Open,true);

   int OsMA_Low_handle=iOsMA(NULL,PERIOD_H1,12,26,9,PRICE_LOW);
   CopyBuffer(OsMA_Low_handle,0,0,k,OsMA_Low);
   ArraySetAsSeries(OsMA_Low,true);

   int TriX_Open_handle=iTriX(NULL,PERIOD_H1,14,PRICE_OPEN);
   CopyBuffer(TriX_Open_handle,0,0,k,TriX_Open);
   ArraySetAsSeries(TriX_Open,true);

   int TriX_Low_handle=iTriX(NULL,PERIOD_H1,14,PRICE_LOW);
   CopyBuffer(TriX_Low_handle,0,0,k,TriX_Low);
   ArraySetAsSeries(TriX_Low,true);

   int BearsPower_handle=iBearsPower(NULL,PERIOD_H1,13);
   CopyBuffer(BearsPower_handle,0,0,k,BearsPower);
   ArraySetAsSeries(BearsPower,true);

   int ADX_MINUSDI_handle=iADX(NULL,PERIOD_H1,14);
   CopyBuffer(ADX_MINUSDI_handle,2,0,k,ADX_MINUSDI);
   ArraySetAsSeries(ADX_MINUSDI,true);

   int StdDev_Open_handle=iStdDev(NULL,PERIOD_H1,20,0,MODE_SMA,PRICE_OPEN);
   CopyBuffer(StdDev_Open_handle,0,0,k,StdDev_Open);
   ArraySetAsSeries(StdDev_Open,true);

   int StdDev_Low_handle=iStdDev(NULL,PERIOD_H1,20,0,MODE_SMA,PRICE_LOW);
   CopyBuffer(StdDev_Low_handle,0,0,k,StdDev_Low);
   ArraySetAsSeries(StdDev_Low,true);
//---------------------------------------------------------------------------------------------------------------------------

   HandleInputNet2OutNet1Min=FileOpen(Symbol()+"InputNet2OutNet1Min.csv",FILE_CSV|FILE_WRITE|FILE_SHARE_READ|FILE_ANSI|FILE_COMMON,";");
   HandleOutNet2Min=FileOpen(Symbol()+"OutNet2Min.csv",FILE_CSV|FILE_WRITE|FILE_SHARE_READ|FILE_ANSI|FILE_COMMON,";");
   FileSeek(HandleInputNet2OutNet1Min,0,SEEK_END);
   FileSeek(HandleOutNet2Min,0,SEEK_END);

   if(HandleInputNet2OutNet1Min>0)
     {
      Alert("Writing the files InputNet2OutNet1Min and OutNet2Min");

      for(int i=iBars(NULL,PERIOD_H1)-1; i>=0; i--)
        {
         Date1=TimeToString(iTime(NULL,PERIOD_H1,i));

         if(DateOut>=Date1 && Date<=Date1)
           {
            if(((DibMin1_1[i]==-1 && DibMin1_1[i+1]==1 && DibMax1_1[i]==1)) || (DibMin1_1[i]==1 && DibMax1_1[i]==1))

              {
               for(int m=0; m<=35; m++)
                 {
                  inB[m]=inB[m+12];
                 }

               inB[36]=Stochastic0[i];
               inB[37]=Stochastic1[i];
               inB[38]=CCI_Low[i];
               inB[39]=Momentum_Low[i];
               inB[40]=RSI_Low[i];;
               inB[41]=WPR[i+1];
               inB[42]=MACD_Low[i]*10000;
               inB[43]=OsMA_Low[i]*100000;
               inB[44]=TriX_Low[i]*100000;;
               inB[45]=BearsPower[i+1]*1000;
               inB[46]=ADX_MINUSDI[i+1];
               inB[47]=StdDev_Low[i]*10000;

               inB[48]=Stochastic0[i];
               inB[49]=Stochastic1[i];
               inB[50]=CCI_Open[i];
               inB[51]=Momentum_Open[i];
               inB[52]=RSI_Open[i];;
               inB[53]=WPR[i];
               inB[54]=MACD_Open[i]*10000;
               inB[55]=OsMA_Open[i]*100000;
               inB[56]=TriX_Open[i]*100000;;
               inB[57]=BearsPower[i]*1000;
               inB[58]=ADX_MINUSDI[i];
               inB[59]=StdDev_Open[i]*10000;

               FileWrite(HandleInputNet2OutNet1Min,
                         inB[0],inB[1],inB[2],inB[3],inB[4],inB[5],inB[6],inB[7],inB[8],inB[9],inB[10],inB[11],inB[12],inB[13],
                         inB[14],inB[15],inB[16],inB[17],inB[18],inB[19],inB[20],inB[21],inB[22],inB[23],inB[24],inB[25],inB[26],
                         inB[27],inB[28],inB[29],inB[30],inB[31],inB[32],inB[33],inB[34],inB[35],inB[36],inB[37],inB[38],inB[39],
                         inB[40],inB[41],inB[42],inB[43],inB[44],inB[45],inB[46],inB[47],inB[48],inB[49],inB[50],inB[51],inB[52],
                         inB[53],inB[54],inB[55],inB[56],inB[57],inB[58],inB[59]);

               FileWrite(HandleOutNet2Min,
                         (iOpen(NULL,PERIOD_D1,iBarShift(NULL,PERIOD_D1,iTime(NULL,PERIOD_H1,i)))-iOpen(NULL,PERIOD_H1,i))*10000);
              }
           }
        }
     }

   //------ Daily High

   int CCI_High_handle=iCCI(NULL,PERIOD_H1,14,PRICE_HIGH);
   CopyBuffer(CCI_High_handle,0,0,k,CCI_High);
   ArraySetAsSeries(CCI_High,true);

   int Momentum_High_handle=iMomentum(NULL,PERIOD_H1,14,PRICE_HIGH);
   CopyBuffer(Momentum_High_handle,0,0,k,Momentum_High);
   ArraySetAsSeries(Momentum_High,true);

   int RSI_High_handle=iRSI(NULL,PERIOD_H1,14,PRICE_HIGH);
   CopyBuffer(RSI_High_handle,0,0,k,RSI_High);
   ArraySetAsSeries(RSI_High,true);

   int MACD_High_handle=iMACD(NULL,PERIOD_H1,12,26,9,PRICE_HIGH);
   CopyBuffer(MACD_High_handle,0,0,k,MACD_High);
   ArraySetAsSeries(MACD_High,true);

   int OsMA_High_handle=iOsMA(NULL,PERIOD_H1,12,26,9,PRICE_HIGH);
   CopyBuffer(OsMA_High_handle,0,0,k,OsMA_High);
   ArraySetAsSeries(OsMA_High,true);

   int TriX_High_handle=iTriX(NULL,PERIOD_H1,14,PRICE_HIGH);
   CopyBuffer(TriX_High_handle,0,0,k,TriX_High);
   ArraySetAsSeries(TriX_High,true);

   int BullsPower_handle=iBullsPower(NULL,PERIOD_H1,13);
   CopyBuffer(BullsPower_handle,0,0,k,BullsPower);
   ArraySetAsSeries(BullsPower,true);

   int ADX_PLUSDI_handle=iADX(NULL,PERIOD_H1,14);
   CopyBuffer(ADX_PLUSDI_handle,1,0,k,ADX_PLUSDI);
   ArraySetAsSeries(ADX_PLUSDI,true);

   int StdDev_High_handle=iStdDev(NULL,PERIOD_H1,20,0,MODE_SMA,PRICE_HIGH);
   CopyBuffer(StdDev_High_handle,0,0,k,StdDev_High);
   ArraySetAsSeries(StdDev_High,true);
//---------------------------------------------------------------------------------------------------------------------------

   HandleInputNet2OutNet1Max=FileOpen(Symbol()+"InputNet2OutNet1Max.csv",FILE_CSV|FILE_WRITE|FILE_SHARE_READ|FILE_ANSI|FILE_COMMON,";");
   HandleOutNet2Max=FileOpen(Symbol()+"OutNet2Max.csv",FILE_CSV|FILE_WRITE|FILE_SHARE_READ|FILE_ANSI|FILE_COMMON,";");
   FileSeek(HandleInputNet2OutNet1Max,0,SEEK_END);
   FileSeek(HandleOutNet2Max,0,SEEK_END);

   if(HandleInputNet2OutNet1Max>0)
     {
      Alert("Writing the files InputNet2OutNet1Max and OutNet2Max");

      for(int i=iBars(NULL,PERIOD_H1)-1; i>=0; i--)
        {
         Date1=TimeToString(iTime(NULL,PERIOD_H1,i));

         if(DateOut>=Date1 && Date<=Date1)
           {
            if(((DibMax1_1[i]==-1 && DibMax1_1[i+1]==1 && DibMin1_1[i]==1)) || (DibMin1_1[i]==1 && DibMax1_1[i]==1))

              {
               for(int m=0; m<=35; m++)
                 {
                  inS[m]=inS[m+12];
                 }

               inS[36]=Stochastic0[i];
               inS[37]=Stochastic1[i];
               inS[38]=CCI_High[i];
               inS[39]=Momentum_High[i];
               inS[40]=RSI_High[i];;
               inS[41]=WPR[i+1];
               inS[42]=MACD_High[i]*10000;
               inS[43]=OsMA_High[i]*100000;
               inS[44]=TriX_High[i]*100000;;
               inS[45]=BullsPower[i+1]*1000;
               inS[46]=ADX_PLUSDI[i+1];
               inS[47]=StdDev_High[i]*10000;

               inS[48]=Stochastic0[i];
               inS[49]=Stochastic1[i];
               inS[50]=CCI_Open[i];
               inS[51]=Momentum_Open[i];
               inS[52]=RSI_Open[i];;
               inS[53]=WPR[i];
               inS[54]=MACD_Open[i]*10000;
               inS[55]=OsMA_Open[i]*100000;
               inS[56]=TriX_Open[i]*100000;;
               inS[57]=BullsPower[i]*1000;
               inS[58]=ADX_PLUSDI[i];
               inS[59]=StdDev_Open[i]*10000;

               FileWrite(HandleInputNet2OutNet1Max,
                         inS[0],inS[1],inS[2],inS[3],inS[4],inS[5],inS[6],inS[7],inS[8],inS[9],inS[10],inS[11],inS[12],inS[13],
                         inS[14],inS[15],inS[16],inS[17],inS[18],inS[19],inS[20],inS[21],inS[22],inS[23],inS[24],inS[25],inS[26],
                         inS[27],inS[28],inS[29],inS[30],inS[31],inS[32],inS[33],inS[34],inS[35],inS[36],inS[37],inS[38],inS[39],
                         inS[40],inS[41],inS[42],inS[43],inS[44],inS[45],inS[46],inS[47],inS[48],inS[49],inS[50],inS[51],inS[52],
                         inS[53],inS[54],inS[55],inS[56],inS[57],inS[58],inS[59]);

               FileWrite(HandleOutNet2Max,
                         (iOpen(NULL,PERIOD_H1,i)-iOpen(NULL,PERIOD_D1,iBarShift(NULL,PERIOD_D1,iTime(NULL,PERIOD_H1,i))))*10000);
              }
           }
        }
     }

   Alert("Files written");
  }
//+------------------------------------------------------------------+