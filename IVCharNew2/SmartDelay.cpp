#include "SmartDelay.h"

SmartDelay::SmartDelay()
{
  smMilis = 0;
  smLast = 0 ;
  state    = SMART_DELAY_STOP;
};

//SmartDelay::SmartDelay(unsigned long tick) {
//  smMicros = tick;
//  state    = SMART_DELAY_START;
//}
//
bool SmartDelay::Now() {
  if ((state == SMART_DELAY_STOP) ||
      (millis() - smLast < smMilis))
    return false;

  state = SMART_DELAY_STOP;
  return true;
}
//
//unsigned long SmartDelay::Get() const {
//  return smMicros;
//}
//
void SmartDelay::SetInterval(unsigned long tick) {
  smMilis = tick;
}
//
//unsigned long SmartDelay::Wait() {
//  unsigned long old = smMicros;
//  smLast = micros();
//  return old;
//}
//
//unsigned long SmartDelay::Reset() {
//  unsigned long old = smMicros;
//  smLast = 0; // РїСЂРѕ РїРµСЂРµРїРѕР»РЅРµРЅРёРµ С†РµР»РѕРіРѕ РїРѕРјРЅРёС‚СЊ!
//  return old;
//}
//
void SmartDelay::Start() {
  smLast = millis();
  state = SMART_DELAY_START;
}

void SmartDelay::Stop() {
  state = SMART_DELAY_STOP;
}
//
//// OOP methods
void SmartDelay::End() {
  if (Now()) Process();
}
void SmartDelay::Process() {}

