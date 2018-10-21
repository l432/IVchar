#include "DS18B20.h"


DS18B20::DS18B20(): ds(DS18B20Pin)
{
  SetInterval(800);
  _pin = DS18B20Pin;
}
void DS18B20::Begin()
{
  if (_pin != PinControl)
  {
//    delete &ds;
    _pin = PinControl;
//    OneWire ds(_pin);
  };
  ds.reset();
  ds.write(0xCC);
  ds.write(0x44);
  Start();
}
void DS18B20::Process()
{
  byte data[2];
  ds.reset();
  ds.write(0xCC);
  ds.write(0xBE);

  for ( byte i = 0; i < 2; i++) {
    data[i] = ds.read();
  }
  DeviceId = DS18B20Command;
  ActionId = _pin;
  CreateAndSendPacket(data, sizeof(data));
  Stop();
}
//
//void DS18B20() {
//  if (DS18B20Pin != PinAndID::PinControl)
//  {
//    delete &ds;
//    DS18B20Pin = PinAndID::PinControl;
//    OneWire ds(DS18B20Pin);
//  };
//  ds.reset();
//  ds.write(0xCC);
//  ds.write(0x44);
//
//  EndDS18B20delay = millis() + 800;
//}
//
//void DS18B20End() {
//  byte data[2];
//  ds.reset();
//  ds.write(0xCC);
//  ds.write(0xBE);
//
//  for ( byte i = 0; i < 2; i++) {
//    data[i] = ds.read();
//  }
//  PinAndID::DeviceId = DS18B20Command;
//  PinAndID::ActionId = DS18B20Pin;
//  PinAndID::CreateAndSendPacket(data, sizeof(data));
//  EndDS18B20delay = 0;
//}

