#ifndef OLEG_INA226
#define OLEG_INA226

#if ARDUINO >= 100
#include <Arduino.h>
#else
#include <WProgram.h>
#endif

#include "SmartDelay.h"
#include "WireObject.h"
#include "OlegPacket.h"
#include "OlegConstant.h"

const uint8_t  INA_CONFIGURATION_REGISTER   =      0;                       // Registers common to all INAs     //
const uint8_t  INA_SHUNT_VOLTAGE_REGISTER   =      1;                       //                                  //
const uint8_t  INA_BUS_VOLTAGE_REGISTER     =      2;                       //                                  //
const uint8_t  INA_MASK_ENABLE_REGISTER     =      6;                       //                                  //
const uint16_t INA_CONFIG_AVG_MASK          = 0x0E00;                       // Bits 9-11                        //
const uint16_t INA_CONFIG_BUS_TIME_MASK     = 0x01C0;                       // Bits 6-8                         //
const uint16_t INA_CONFIG_SHUNT_TIME_MASK   = 0x0038;                       // Bits 3-5                         //
const uint8_t  INA_CONVERSION_READY_MASK    = 0x08;                         // Bit 4                            //
const uint16_t INA_CONFIG_MODE_MASK         = 0x0007;                       // Bits 0-2                         //
const uint16_t INA_TO_SLEEP_MODE_MASK       = 0xFFF8;                       // Bits 0-2 in 0                    //
const uint8_t  INA_MODE_TRIGGERED_SHUNT     =   B001;                       // Triggered shunt, no bus          //
const uint8_t  INA_MODE_TRIGGERED_BUS       =   B010;                       // Triggered bus, no shunt          //
const uint8_t  INA_MODE_TRIGGERED_BOTH      =   B011;                       // Triggered bus and shunt          //

const uint16_t INA226_averages[8] = {1, 4, 16, 64, 128, 256, 512, 1024};
const uint16_t INA226_ConvTime[8] = {140, 204, 332, 588, 1100, 2116, 4156, 8244};


class INA226o: public SmartDelay, public WireObject, public PinAndID, public FastIVData
{
  public:
    INA226o();
    bool Begin();
    void Process();
  private:
    uint16_t _config;
    uint8_t _mode;
    uint8_t _timeFactor;
    bool isConversionFinished();
    unsigned long DelayTime();
    void ToSleepMode();
};


#endif
