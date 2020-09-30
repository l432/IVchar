#ifndef SMART_DELAY_H
#define SMART_DELAY_H

#if ARDUINO >= 100
 #include <Arduino.h>
#endif

class SmartDelay {
  private:
    enum SMART_DELAY_STATE {
      SMART_DELAY_START=0,
      SMART_DELAY_STOP
    };

    unsigned long smMikros;
    unsigned long smLast;
    SMART_DELAY_STATE state;

  public:
    SmartDelay();
    bool Now();
    void SetInterval(unsigned long tick);
    unsigned long GetInterval();
    void Stop();
    void Start();
    bool isReady();
    unsigned long TimeFromStart();       
    void End(); // to pun into loop()
    virtual void Process(); // to overload
};


#endif

