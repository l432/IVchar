unit ST2829CConst;

interface

const

  ST2829C_Test='SOURCETRONIC, ST2829C,Ver 2.0.0';
  ST2829C_MemFileMaxLength=16;
//  KeitleyDisplayDNLabel='.5 digit';
//  KeitleyDefBuffer='defbuffer1';
//  KeitleyDefBuffer2='defbuffer2';
//  MyBuffer='OlegData';
//  MySourceList='OlegSourceList';
//  MyMeasList='OlegMeasList';

  RootNodeST2829C:array[0..3]of string=
  ('*idn?','*rst','*trg', 'mmem');
//   0       1       2      3      4        5       6       7      8

  FirstNodeST2829C:array[0..1]of string=
  (':load:stat',':stor:stat');
//     0             1             2          3      4        5         6

type

 TST2829C_SetupMemoryRecord=0..39;

implementation

end.
