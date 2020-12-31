#include "DS18B20.h"


DS18B20o::DS18B20o(): ds(DS18B20Pin)
{
  SetInterval(800000);
  _pin = DS18B20Pin;
}
bool DS18B20o::Begin()
{
  if (DeviceId != DS18B20Command) return false;
  if ((NumberByte < 4) || (!isReady())) return true;
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
  return true;
}

//      if ((PinAndID::DeviceId == DS18B20Command) && (ds18b20.isReady())) {
//        if (packet[0] < 4) goto start;
//        ds18b20.Begin();
//      }

void DS18B20o::Process()
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

