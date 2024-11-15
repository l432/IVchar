﻿unit ST2829CConst;

interface

uses
  SCPI;

const

  ST2829C_Test='SOURCETRONIC, ST2829C,Ver 2.0.0';
  ST2829C_MemFileMaxLength=16;

  ST2829CName='ST2829C';
  ST2829CNameSpeed='Speed:';
  ST2829CNameAverCount='Average Count:';
  ST2829CNameDelay='Delay, ms:';



  RootNodeST2829C:array[0..15]of string=
  ('*idn?','*rst','*trg', 'mmem', 'disp','freq','ampl:alc','volt','curr',
//   0       1       2      3       4       5       6       7       8
   'bias','ores','func','aper','trig','fetc','corr');
//   9      10     11     12     13     14     15

  FirstNodeST2829C:array[0..19]of string=
  (':load:stat',':stor:stat',':page',':rfon',':line',':stat',':volt',':curr',
//     0             1           2      3      4        5        6      7
  ':imp',':rang',':auto',':smon',':vac',':iac',':sour',':del',':leng',
//   8      9       10      11     12     13      14     15     16
  ':open',':shor',':spot');
//   17     18      19      20     21     22      23     24     25


  SuffixST2829C:array[0..1]of string=('on','off');
//                                      0    1     2     3

type

 TST2829C_SetupMemoryRecord=0..39;
 {реально- до 39, але вікно з кнопками завелике}

// TST2829C_SpotNumber=1..201;

 {що саме можна робити}
 TST2829CAction=(st_aReset,st_aTrg,st_aMemLoad,st_aMemSave,
//                 0           1         2          3
                 st_aDispPage,st_aChangFont,st_aFreqMeas,
//                  4               5              6
                 st_aALE, st_aVMeas, st_aIMeas,st_aBiasEn,st_aBiasVol,
//                  7          8          9          10       11
                 st_aOutImp, st_aSetMeasT, st_aRange, st_aVrmsToMeas, st_aIrmsToMeas,
//                  12         13             14         15               16
                 st_aSpeedMeas,st_aAverTimes,st_aBiasCur,st_aTriger,st_aTrigSource,
//                  17            18             19         20               21
                 st_aTrigDelay,st_aGetMeasData,st_aGetVrms,st_aGetIrms,st_aCorCable,
//                   22            23             24         25            26
                 st_aOpenMeas,st_aShortMeas,st_aOpenState,st_aShortState,st_aCorSpotState,
//                   27            28             29         30               31
                 st_aCorSpotFreq,st_aCorSpotShort,st_aCorSpotOpen);
//                   32               33                34           35               36

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

 TST2829C_MeasureType=(st_mtCpD, st_mtCpQ, st_mtCpG, st_mtCpRp,
                        st_mtCsD, st_mtCsQ, st_mtCsRs,
                        st_mtLpQ, st_mtLpD, st_mtLpG, st_mtLpRp,st_mLpZ,
                        st_mtLsD, st_mtLsQ, st_mtLsRs,st_mLsZ,
                        st_mtRX,st_mRpQ,st_mRsQ,
                        st_mtZTd, st_mtZTr,st_mZQ,
                        st_mtGB, st_mtYTd, st_mtYTr, st_mtDCR);


 TST2829C_OutputImpedance=({st_oi10,}st_oi30,st_oi50,st_oi100);

 TST2829C_Range=(st_rAuto,st_r10,st_r30,st_r100,st_r300,
                 st_r1k,st_r3k,st_r10k{,st_r30k,st_r100k,
                 st_r300k,st_r1M});

 TST2829C_MeasureSpeed=(st_msSlow,st_msMed,st_msFast,st_msFastPlus);

 TST2829C_TrigerSource=(st_tsInt,st_tsHold,st_tsBus);

 TST2829C_SweepParametr=(st_spBiasVolt,st_spBiasCurr,st_spFreq,
                         st_spVrms,st_spIrms);

 TST2829C_SweepData=(st_sdPrim,st_sdSecon,st_sdBoth);

 TST2829C_CorCable=(st_cc0M,st_cc1M,st_cc2M,st_cc4M);




const
 ST2829CMeasureSpeedDefault=st_msFast;

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

 ST2829C_OutputImpedanceLabels:array[TST2829C_OutputImpedance]of string=
         ({'10 Ohm', }'30 Ohm', '50 Ohm', '100 Ohm');



 ST2829C_MeasureTypeCommands:array [TST2829C_MeasureType]
          of string=('cpd', 'cpq', 'cpg', 'cprp',
                     'csd','csq','csrs',
                     'lpq', 'lpd', 'lpg', 'lprp','lpz',
                     'lsd','lsq','lsrs','lsz',
                     'rx','rpq','rsq',
                     'ztd', 'ztr','zq',
                     'gb', 'ytd', 'ytr', 'dcr');
 ST2829C_MeasureTypeLabels:array [TST2829C_MeasureType]
          of string=('Cp-Dissipation', 'Cp-Quality', 'Cp-Conductance',
            'Cp-Rp','Cs-Dissipation','Cs-Quality','Cs-Rs',
            'Lp-Quality', 'Lp-Dissipation', 'Lp-Conductance', 'Lp-Rp','Lp-Impedance',
            'Ls-Dissipation', 'Ls-Quality', 'Ls-Rs','Lz-Impedance',
            'R-Reactance','Rp-Quality','Rs-Quality',
            'Impedance-Phase(deg)', 'Impedance-Phase(rad)','Impedance-Quality',
            'Conductance-Admittance', 'Admittance-Phase(deg)',
            'Admittance-Phase(rad)', 'DC resistance');

 ST2829C_RangeLabels:array[TST2829C_Range]of string=
         ('Auto','10 Ohm', '30 Ohm', '100 Ohm', '300 Ohm', '1 kOhm',
         '3 kOhm', '10 kOhm'{,'30 kOhm', '100 kOhm', '300 kOhm', '1 MOhm'});


 ST2829C_MeasureSpeedCommands:array[TST2829C_MeasureSpeed]of string=
        ('slow','med','fast','fast+');

// ST2829C_MeasureSpeedLabels:array[TST2829C_MeasureSpeed]of string=
//        ('slow (650 ms)','med (90 ms)','fast (13 ms)','fast+ (8 ms)');
 ST2829C_MeasureSpeedLabels:array[TST2829C_MeasureSpeed]of string=
        ('650 ms','90 ms','13 ms','8 ms');

 ST2829C_TrigerSourceCommands:array[TST2829C_TrigerSource]of string=
        ('int','hold','bus');
 ST2829C_TrigerSourceLabels:array[TST2829C_TrigerSource]of string=
        ('Continious','Manual','RS232');

 ST2829C_SweepParametrLabels:array[TST2829C_SweepParametr]of string=
        ('Bias Voltage','Bias Current','Frequancy',
        'Measure Voltage','Measure Current');
 ST2829C_SweepParametrUnitLabels:array[TST2829C_SweepParametr]of string=
        (', V:',', mA:',', Hz:',', V:',', mA:');

 ST2829C_SweepParametrSalt:array[TST2829C_SweepParametr]of string=
        ('BV','BC','Fr', 'MV','MC');

  ST2829C_SweepDataLabels:array[TST2829C_SweepData]of string=
        ('Primery','Secondary','Both');

 ST2829C_CorCableCommands:array[TST2829C_CorCable]of string=
        ('0m','1m','2m','4m');


 ST2829C_FreqMeasLimits:TLimitValues=(20,1000000);
 ST2829C_VrmsMeasLimits:TLimitValues=(0.005,10);
 ST2829C_IrmsMeasLimits:TLimitValues=(0.05,100);
 ST2829C_VmrsMeasLimitsForAL:TLimitValues=(0.01,10);
 ST2829C_ImrsMeasLimitsForAL:TLimitValues=(0.1,100);
 ST2829C_BiasVoltageLimits:TLimitValues=(-10,10);
 ST2829C_BiasCurrentLimits:TLimitValues=(-100,100);
 ST2829C_AverTimes:TLimitValues=(1,255);
 ST2829CAverTimeDefault=1;
 ST2829C_DelayTime:TLimitValues=(0,60000);
 ST2829CDelayTimeDefault=10;
 ST2829C_SpotNumber:TLimitValues=(1,201);

 ST2829C_BiasOnOffButtonCaption:array [Boolean]
            of string=('Bias off', 'Bias on');

 implementation

end.
