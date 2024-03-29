unit DMM6500_Const;

interface

uses
  Keitley2450Const, SCPI;

type
 TDMM6500_State=(dm_st_front,dm_st_rare,dm_st_ch1,dm_st_ch2,dm_st_ch3,
                 dm_st_ch4,dm_st_ch5,dm_st_ch6,dm_st_ch7,dm_st_ch8,
                 dm_st_ch9,dm_st_ch10);

 TDMM6500_VoltageDCRange=(dm_vdrAuto,dm_vdr100mV,dm_vdr1V,dm_vdr10V,
                         dm_vdr100V,dm_vdr1000V);
 {TDMM6500_VoltageRatio}
 {DMM6500_VoltageDigRange - ��� Auto}
 TDMM6500_VoltageDigRange=dm_vdr100mV..dm_vdr1000V;

 TDMM6500_VoltageACRange=(dm_varAuto,dm_var100mV,dm_var1V,dm_var10V,
                         dm_var100V,dm_var750V);

 TDMM6500_CurrentDCRange=(dm_cdrAuto,dm_cdr10uA,dm_cdr100uA,
                         dm_cdr1mA,dm_cdr10mA,dm_cdr100mA,
                         dm_cdr1A,dm_cdr3A,dm_cdr10A);
 TDMM6500_CurrentACRange=(dm_carAuto,dm_car100uA,
                         dm_car1mA,dm_car10mA,dm_car100mA,
                         dm_car1A,dm_car3A,dm_car10A);
 {DMM6500_CurrentDigRange - ��� Auto}
 TDMM6500_CurrentDigRange=dm_cdr100uA..dm_cdr10A;

 TDMM6500_CapacitanceRange=(dm_crAuto,dm_cr1nF,dm_cr10nF,
                     dm_cr100nF,dm_cr1uF,dm_cr10uF,dm_cr100uF);

 TDMM6500_Resistance2WRange=(dm_r2rAuto,dm_r2r10,dm_r2r100,
       dm_r2r1k,dm_r2r10k,dm_r2r100k,dm_r2r1M,dm_r2r10M,dm_r2r100M);
 TDMM6500_Resistance4WRange=(dm_r4rAuto,dm_r4r1,dm_r4r10,dm_r4r100,
       dm_r4r1k,dm_r4r10k,dm_r4r100k,dm_r4r1M,dm_r4r10M,dm_r4r100M);

 TDMM6500_DigSampleRate=1000..1000000;

 TDMM6500_VoltageUnits=(dm_vuVolt, dm_vuDB, dm_vuDBM);

 TDMM6500_TempUnits=(dm_tuKelv, dm_tuCels, dm_tuFahr);

 TDMM6500_InputImpedance=(dm_iiAuto, dm_ii10M);

 TDMM6500_DetectorBandwidth=(dm_dbw3Hz, dm_dbw30Hz, dm_dbw300Hz);

 TDMM6500_VoltageRatioMethod=(dm_vrmRes, dm_vrmPart);

 TDMM6500_OffsetCompen=(dm_ocOff, dm_ocOn, dm_ocAuto);

 TDMM6500_TempTransducer=(dm_ttCouple,dm_ttTherm,dm_tt2WRTD,dm_tt3WRTD,
                          dm_tt4WRTD,dm_ttCJC);

 TDMM6500_TCoupleRefJunct=(dm_trjSim,dm_trjExt);

 TDMM6500_RTDType=(dm_rtdPT100,dm_rtdPT385,dm_rtdPT3916,
                      dm_rtdD100,dm_rtdF100,dm_rtdUser);
 TDMM6500_RTDPropertyNumber=4..6;
 TDMM6500_MeasParameters=(dm_tp_TransdType,dm_tp_RefJunction,
    dm_tp_RTDAlpha,dm_tp_RTDBeta,dm_tp_RTDDelta,dm_tp_RTDZero,
    dm_tp_W2RTDType,dm_tp_W3RTDType,dm_tp_W4RTDType,dm_tp_ThermistorType,
    dm_tp_TCoupleType,dm_tp_SimRefTemp,dm_dp_BiasLevel,dm_vrp_VRMethod,
    dm_pp_OffsetCompen,dm_pp_OpenLeadDetector,dm_pp_LineSync,
    dm_pp_AzeroState,dm_pp_DetectorBW,dm_pp_InputImpedance,
    dm_pp_Units,dm_pp_DbmWReference,dm_pp_DecibelReference,
    dm_pp_Aperture,dm_pp_MeasureTime,dm_pp_NPLC,
    dm_pp_SampleRate,dm_pp_DelayAuto,dm_pp_Range,
    dm_pp_ThresholdRange,dm_pp_RangeVoltDC,dm_pp_RangeVoltAC,
    dm_pp_RangeCurrentDC,dm_pp_RangeCurrentAC,
    dm_pp_RangeResistance2W,dm_pp_RangeResistance4W,
    dm_pp_RangeCapacitance,dm_tp_UnitsTemp,
    dm_pp_UnitsVolt,dm_pp_ApertureAuto,dm_pp_RangeVoltDig,
    dm_pp_RangeCurrentDig);

 TDMM6500_ThermistorType=(dm_tt2252,dm_tt5000,dm_tt10000);

 TDMM6500_TCoupleType=(dm_tctB,dm_tctE,dm_tctJ,dm_tctK,
                      dm_tctN,dm_tctR,dm_tctS,dm_tctT);

 TDMM6500_DiodeBiasLevel=(dm_dbl10uA,dm_dbl100uA,dm_dbl1mA,dm_dbl10mA);

// TDMM6500_ControlElementType=(dm_cetST,dm_cetL,dm_cetCB);

// TDMM6500_Types=class of (TDMM6500_DiodeBiasLevel,TDMM6500_TCoupleType);
 // TFitFunctionNew_Class=class of TFitFunctionNew;

const
 DMM6500_Test='KEITHLEY INSTRUMENTS,MODEL DMM6500';
 SCAN2000_Test='2000,10-Chan Mux';
// TCSCAN2001_Test='2000,10-Chan Mux';
 Pseudocard_Test='2000,Pseudo 10Ch Mux';

 CardLeafNodeDMM6500:array[0..3]of string=
 (':vch',':star',':end',':vmax');

 RTDLeafNode:array[0..6]of string=
 (':alph',':beta',':delt',':zero',':two',':thr',':four');

 TermoCoupleLeafNode:array[0..2]of string=
 (':rjun:sim',':rjun:rsel',':type');

 DMM6500_VoltageDCRangeLabels:array[TDMM6500_VoltageDCRange]of string=
         ('Auto','100 mV', '1 V', '10 V', '100 V', '1000 V');
 DMM6500_VoltageACRangeLabels:array[TDMM6500_VoltageACRange]of string=
         ('Auto','100 mV', '1 V', '10 V', '100 V', '750 V');
 DMM6500_CurrentDCRangeLabels:array[TDMM6500_CurrentDCRange]of string=
         ('Auto','10 mkA', '100 mkA', '1 mA', '10 mA', '100 mA',
         '1 A', '3 A','10 A');
 DMM6500_CurrentACRangeLabels:array[TDMM6500_CurrentACRange]of string=
         ('Auto', '100 mkA', '1 mA', '10 mA', '100 mA',
         '1 A', '3 A','10 A');
 DMM6500_CapacitanceRangeRangeLabels:array[TDMM6500_CapacitanceRange]of string=
    ('Auto', '1 nF', '10 nF', '100 nF', '1 mkF', '10 mkF', '100 mkF');
 DMM6500_Resistance2WRangeLabels:array[TDMM6500_Resistance2WRange]of string=
    ('Auto', '10 Ohm', '100 Ohm','1 kOhm','10 kOhm','100 kOhm',
    '1 MOhm','10 MOhm','100 MOhm');
 DMM6500_Resistance4WRangeLabels:array[TDMM6500_Resistance4WRange]of string=
    ('Auto', '1 Ohm','10 Ohm', '100 Ohm','1 kOhm','10 kOhm','100 kOhm',
    '1 MOhm','10 MOhm','100 MOhm');


// DMM6500_VoltageUnitsCommand:array[TDMM6500_VoltageUnits]of string=
// ('volt', 'db', 'dbm');
 DMM6500_VoltageUnitsLabel:array[TDMM6500_VoltageUnits]of string=
 ('Volt', 'dB', 'dBm');
 DMM6500_TempUnitsCommand:array[TDMM6500_TempUnits]of string=
 ('kelv', 'cels', 'fahr');
 DMM6500_TempUnitsLabel:array[TDMM6500_TempUnits]of string=
 ('Kelvin', 'Celsius', 'Fahrenheit');
 DMM6500_InputImpedanceCommand:array[TDMM6500_InputImpedance]of string=
 ('auto', 'mohm10');
 DMM6500_InputImpedanceLabel:array[TDMM6500_InputImpedance]of string=
 ('Auto', '10 MOhm');
 DMM6500_DetectorBandwidthCommand:array[TDMM6500_DetectorBandwidth]of integer=
 (3, 30, 300);
 DMM6500_DetectorBandwidthLabel:array[TDMM6500_DetectorBandwidth]of string=
 ('3 Hz', '30 Hz', '300 Hz');

  DMM6500_VoltageRatioMethodCommand:array[TDMM6500_VoltageRatioMethod]of string=
 ('res', 'part');
  DMM6500_VoltageRatioMethodLabel:array[TDMM6500_VoltageRatioMethod]of string=
 ('Result', 'Parts');

  DMM6500_OffsetCompenLabel:array[TDMM6500_OffsetCompen]of string=
 ('Off', 'On','Auto');

 DMM6500_TempTransducerCommand:array[TDMM6500_TempTransducer]of string=
 ('tc', 'ther','rtd','trtd','frtd','cjc2001');
 DMM6500_TempTransducerLabel:array[TDMM6500_TempTransducer]of string=
 ('TCouple', 'Thermistor','2W-RTD','3W-RTD','4W-RTD','2001-TCSCAN');

 DMM6500_TCoupleRefJunctCommand:array[TDMM6500_TCoupleRefJunct]of string=
 ('sim', 'ext');
 DMM6500_TCoupleRefJunctLabel:array[TDMM6500_TCoupleRefJunct]of string=
 ('Simulated', 'External');

  DMM6500_WiRTDTypeLabel:array[TDMM6500_RTDType]of string=
 ('PT100', 'PT385','PT3916','D100','F100','User');

//  DMM6500_ThermistorTypeLabel:array[TDMM6500_ThermistorType]of string=
// ('2252 Ohm', '5000 Ohm','10000 Ohm');
  DMM6500_ThermistorTypeValues:array[TDMM6500_ThermistorType]of integer=
 (2252,5000,10000);
  DMM6500_ThermistorTypeSyffix=' Ohm';

  DMM6500_TCoupleTypeLabel:array[TDMM6500_TCoupleType]of string=
 ('B', 'E','J','K','N','R','S','T');

  DMM6500_DiodeBiasLevelLabel:array[TDMM6500_DiodeBiasLevel]of string=
 ('10 mkA', '100 mkA','1 mA','10 mA');

DMM6500_ScanMonitorModeCommand:array[TKeitley_ScanLimitType]of string=
 ('upp', 'low','wind','outs','off');
DMM6500_ScanMonitorModeLabel:array[TKeitley_ScanLimitType]of string=
 ('Above Upper Limit', 'Below Lower Limit','Between Limits','Outside Limits','Monitor Off');

 DMM6500_RTDAlphaLimits:TLimitValues=(0,0.01);
 DMM6500_RTDBetaLimits:TLimitValues=(0,1);
 DMM6500_RTDDeltaLimits:TLimitValues=(0,5);
 DMM6500_RTDZeroLimits:TLimitValues=(0,10000);
 DMM6500_CountDigLimits:TLimitValues=(1,55000000);
 DMM6500_CountLimits:TLimitValues=(1,1000000);
 DMM6500_ScanCountLimits:TLimitValues=(0,1000000000);
 DMM6500_ScanIntervalLimits:TLimitValues=(0,100000);

 DMM6500_DelayAfterCloseLimits:TLimitValues=(0,1000000);

 DMM6500_RefTempLimits:array[TDMM6500_TempUnits] of TLimitValues=
  ((273.15,338.15),(0,65),(32,149));
 DMM6500_RefTempInitValue:array[TDMM6500_TempUnits] of double=
  (296.15,23,73.4);
 DMM6500_NPLCLimits:TLimitValues=(0.0005,12);

 DMM6500_ScanLeafNode:array[0..11]of string=
 ('',':add',':add:sing',':coun:scan',':coun:step',':int',
//0     1        2            3            4         5
  ':meas:int',':stat',':mon:mode',':mon:chan',':mon:lim:low',':mon:lim:upp');
//     6        7          8           9            10             11


implementation

end.
