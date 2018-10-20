#ifndef SignPinObject_H
#define SignPinObject_H

#include <Wire.h>
#include "OlegConstant.h"

#if ARDUINO >= 100
#include <Arduino.h>
#else
#include <WProgram.h>
#endif

class SignPinObject {
  protected:
    byte _signPin;
    bool _signIsPositiv;

  public:
    bool signMustBeChanged;


//    SignPinObject(byte SignPin) {
//      _signPin = SignPin;
//    }

    void SetSignPin (byte SignPin) {
      _signPin = SignPin;
    }

    bool SignMustBeChangedDetermine (byte Sign) {
      signMustBeChanged =
        ((Sign == DAC_Neg && !_signIsPositiv) ||
         (Sign == DAC_Pos && !_signIsPositiv));
      return signMustBeChanged;
    }

    void SetSignIsPositivValue(bool Value) {
      _signIsPositiv = Value;
    }

    void Setup() {
      pinMode(_signPin, OUTPUT);
      digitalWrite(_signPin, LOW);
      _signIsPositiv = true;
    }

    void ChangeSign() {
      _signIsPositiv = !_signIsPositiv;
      if  (_signIsPositiv)
      {
        digitalWrite(_signPin, LOW);
      } else {
        digitalWrite(_signPin, HIGH);
      };
      signMustBeChanged = false;
    }


};

#endif

