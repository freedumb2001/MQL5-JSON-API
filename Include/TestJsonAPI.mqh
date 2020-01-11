//+------------------------------------------------------------------+
//|                                                         tAPI.mq5 |
//|                                   Copyright 2019, Gunther Schulz |
//|                                     https://www.guntherschulz.de |
//+------------------------------------------------------------------+
#property copyright "Gunther Schulz"
#property link      "https://www.guntherschulz.de"
#property version   "1.00"

#define SymbolInfoTick _SymbolInfoTick

CJAVal tPriceData;
int tTickCount=0;
int tTickPosition=0;
datetime tTimeLast=TimeCurrent();
datetime tTickTimeLast=0;

bool SymbolInfoTick(string symbol, MqlTick &tick)
  {
    if(tPriceData["symbol"]==symbol){
      int t1 = tPriceData["data"][tTickPosition][0].ToInt();
      int t2 = tPriceData["data"][tTickPosition-1][0].ToInt();
      int tTickLiveInterval=t1-t2;
      tick.time=tTickTimeLast + tTickLiveInterval;
      tick.bid=tPriceData["data"][tTickPosition][1].ToDbl();
      tick.ask=tPriceData["data"][tTickPosition][2].ToDbl();
  
      if (tTimeLast + tTickLiveInterval <= TimeCurrent()){
        tTimeLast=TimeCurrent();
        tTickPosition--; // go backwards in time
        tTickTimeLast=tTickTimeLast+tTickLiveInterval;
      }
    }
    return true;
  }

bool TPushHistoricalData(CJAVal &data, int tickCount)
  { 
    // Reset values for testing mode
    tTickCount=0;
    tTickPosition=0;
    tTimeLast=TimeCurrent();
    tTickTimeLast=0;
    
    PushHistoricalData(data, tickCount);
  
    if(tickCount>0)
      {
        tTickPosition=tickCount-2; // set postion to second to last tick
        tTickTimeLast=data["data"][tTickPosition][0].ToInt(); /// set starting postition to time of most recent tick
        tPriceData=data;
      }
    return true;
  }
