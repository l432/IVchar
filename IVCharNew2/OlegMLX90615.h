#ifndef OlegMLX_H
#define OlegMLX_H

#if ARDUINO >= 100
  #include <Arduino.h>
#else
  #include <WProgram.h>
#endif

#include "SmartDelay.h"
#include "WireObject.h"
#include "OlegPacket.h"
#include "OlegConstant.h"

#define MLX_Write_Emissivity     (0x43)

/* я не зміг розбудити термометр після
 введення у Sleep Mode i тому перероробив
 программу на варіант без очікування, але з великим споживанням  
 */

//class MLX90615o: public SmartDelay, public WireObject, public PinAndID
class MLX90615o: public WireObject, public PinAndID
{
  public:
    MLX90615o();
    bool Begin();
//    void Process();

  private:
//    byte _DataToSend[4];
/*  in _DataToSend[0] - operation cod
  if _DataToSend[0] == MLX_Write_Emissivity, then
  in _DataToSend[1,2] - new emissivity value, in _DataToSend[3] - FCS
*/
};

#endif
