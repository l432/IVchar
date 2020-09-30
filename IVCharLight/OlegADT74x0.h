#ifndef OlegADT74x0_H
#define OlegADT74x0_H

#if ARDUINO >= 100
  #include <Arduino.h>
#else
  #include <WProgram.h>
#endif

#include "SmartDelay.h"
#include "WireObject.h"
#include "OlegPacket.h"
#include "OlegConstant.h"

class ADT74o;
class ADT_Init;

class ADT74x0State
{
  public:
//  ADT74x0State(){};
  ADT74x0State(ADT74o* adt74) {adt74in = adt74;}; 
  virtual void Begin(){};
  virtual bool End(){return false;};
  ADT74o* adt74in;
};

class ADT74o: public SmartDelay, public WireObject, public PinAndID
{
  public:
    ADT74o();
    bool Begin();
    void Process();
    bool DataIsReady();
    ADT74x0State* adtstate;
//    ADT74x0State* adtInit; 
    ADT_Init* adtInit; 
    ADT74x0State* adtOneShot; 
    ADT74x0State* adtShutDown;
};

class ADT_Init:public ADT74x0State
{
  public:
//  ADT_Init(ADT74o &adt74){ adt74in = adt74;} ;
  ADT_Init(ADT74o* adt74):ADT74x0State(adt74){} ;
  void Begin();
//  ADT74o adt74in; 
};

class ADT_OneShot:public ADT74x0State
{
  public:
//  ADT_OneShot(ADT74o &adt74){ adt74in = adt74;} ;
  ADT_OneShot(ADT74o* adt74):ADT74x0State(adt74){} ;
  void Begin();
  bool End();
//  ADT74o adt74in; 
};

class ADT_ShutDown:public ADT74x0State
{
  public:
//  ADT_ShutDown(ADT74o &adt74){ adt74in = adt74;} ;
  ADT_ShutDown(ADT74o* adt74):ADT74x0State(adt74){} ;
  void Begin();
  bool End();
//  ADT74o adt74in; 
};

#endif

