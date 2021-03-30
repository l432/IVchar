#include "SmartDelay.h"

SmartDelay::SmartDelay()
{
  smMikros = 0;
  smLast = 0 ;
  state    = SMART_DELAY_STOP;
};

bool SmartDelay::Now() {
  if ((state == SMART_DELAY_STOP) ||
      (TimeFromStart() < smMikros)) return false;

  state = SMART_DELAY_STOP;
  return true;
}

unsigned long SmartDelay::GetInterval() {
  return smMikros;
}

void SmartDelay::SetInterval(unsigned long tick) {
  smMikros = tick;
}

void SmartDelay::Start() {
  smLast = micros();
  state = SMART_DELAY_START;
}

unsigned long SmartDelay::TimeFromStart() {
  unsigned long mcs = micros();
  if (mcs >= smLast) {
    return (mcs - smLast);
  } else {
    return (0xffff - mcs + smLast);
  }
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

