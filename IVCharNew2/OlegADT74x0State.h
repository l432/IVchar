#ifndef OlegADT74State_H
#define OlegADT74State_H

#if ARDUINO >= 100
  #include <Arduino.h>
#else
  #include <WProgram.h>
#endif


class ADT74x0State
{
  public:
  ADT74x0State(){};
  virtual void Begin(){};
  virtual bool End(){return false;};
};


#endif


