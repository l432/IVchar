unit ST2829CConst;

interface

const

  ST2829C_Test='SOURCETRONIC, ST2829C,Ver 2.0.0';
//  KeitleyDisplayDNLabel='.5 digit';
//  KeitleyDefBuffer='defbuffer1';
//  KeitleyDefBuffer2='defbuffer2';
//  MyBuffer='OlegData';
//  MySourceList='OlegSourceList';
//  MyMeasList='OlegMeasList';

  RootNodeST2829C:array[0..1]of string=
  ('*idn?','*rst');

//  ,'*rst','*sav',':acq',':outp',':disp',':syst','scr:run',
//   0       1       2      3      4        5       6       7      8


implementation

end.
