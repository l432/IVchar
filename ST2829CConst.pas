unit ST2829CConst;

interface

uses
  SCPI;

const

  ST2829C_Test='SOURCETRONIC, ST2829C,Ver 2.0.0';
  ST2829C_MemFileMaxLength=16;
//  KeitleyDisplayDNLabel='.5 digit';
//  KeitleyDefBuffer='defbuffer1';
//  KeitleyDefBuffer2='defbuffer2';
//  MyBuffer='OlegData';
//  MySourceList='OlegSourceList';
//  MyMeasList='OlegMeasList';

  RootNodeST2829C:array[0..8]of string=
  ('*idn?','*rst','*trg', 'mmem', 'disp','freq','ampl:alc','volt','curr');
//   0       1       2      3       4       5       6       7       8

  FirstNodeST2829C:array[0..4]of string=
  (':load:stat',':stor:stat',':page',':rfon',':line');
//     0             1           2      3      4        5         6


  SuffixST2829C:array[0..1]of string=('on','off');
//                                      0    1     2     3

type

 TST2829C_SetupMemoryRecord=0..39;
 {реально- до 39, але вікно з кнопками завелике}

 {що саме можна робити}
 TST2829CAction=(st_aReset,st_aTrig,st_aMemLoad,st_aMemSave,
//                 0           1         2          3
                 st_aDispPage,st_aChangFont,st_aFreqMeas,
//                  4               5              6
                 st_aALE, st_aVMeas, st_aIMeas);
//                  7          8          9

 TST2829C_DisplayPage=(st_dpMeas, st_dpBNum, st_dpBCO,
                       st_dpList, st_dpMset, st_dpCset,
                       st_dpLtab, st_dpLSet, st_dpSyst,st_dpFlis);
//MEASurement    Set the display page as the LCR measurement display.
//BNUMber         Set the display page as the bin number display.
//BCOunt           Set the display page as the bin count display.
//LIST              Set the display page as the list sweep display.
//MSETup           Set the display page as the measurement display.
//CSETup           Set the display page as the correction setup.
//LTABle            Set the display page as the limit table setup.
//LSETup           Set the display page as the list sweep setup.
//SYSTem          Set the display page as the system setup page.
//FLISt             Set the display page as the file list page.

 TST2829C_Font=(st_lLarge, st_lTine, st_lOff);

const
 ST2829C_DisplayPageCommand:array [TST2829C_DisplayPage]
            of string=('meas', 'bnum', 'bco',
                       'list', 'mset', 'cset',
                       'ltab', 'lset', 'syst','flis');

 ST2829C_DisplayPageResponce:array [TST2829C_DisplayPage]
            of string=('meas display',
                       'bin no. disp',
                       'bin count disp',
                       'list sweep disp',
                       'measure setup',
                       'correction',
                       'limit table setup',
                       'list sweep setup',
                       'system setup',
                       'file list');

 ST2829C_FontCommand:array [TST2829C_Font]
            of string=('large', 'tiny', 'off');

 ST2829C_FreqMeasLimits:TLimitValues=(20,1000000);
 ST2829C_VmrsMeasLimits:TLimitValues=(0.005,2);
 ST2829C_ImrsMeasLimits:TLimitValues=(0.05,20);
 ST2829C_VmrsMeasLimitsForAL:TLimitValues=(0.01,1);
 ST2829C_ImrsMeasLimitsForAL:TLimitValues=(0.1,10);


 implementation

end.
