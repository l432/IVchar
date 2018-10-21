#include "SmartDelay.h"

SmartDelay::SmartDelay()
{
  smMilis = 0;
  smLast = 0 ;
  state    = SMART_DELAY_STOP;
};

bool SmartDelay::Now() {
  if ((state == SMART_DELAY_STOP) ||
      (millis() - smLast < smMilis))
    return false;

  state = SMART_DELAY_STOP;
  return true;
}

unsigned long SmartDelay::GetInterval() {
  return smMilis;
}

void SmartDelay::SetInterval(unsigned long tick) {
  smMilis = tick;
}

void SmartDelay::Start() {
  smLast = millis();
  state = SMART_DELAY_START;
}

unsigned long SmartDelay::TimeFromStart() {
  return millis()-smLast;
  }


void SmartDelay::Stop() {
  state = SMART_DELAY_STOP;
}

bool SmartDelay::isReady() {
  return (state == SMART_DELAY_STOP);
}

// OOP methods
void SmartDelay::End() {
  if (Now()) Process();
}
void SmartDelay::Process() {}

