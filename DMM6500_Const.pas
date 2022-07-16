unit DMM6500_Const;

interface

uses
  Keitley2450Const;

type
 TDMM6500_State=(dm_st_front,dm_st_rare,dm_st_ch1,dm_st_ch2,dm_st_ch3,
                 dm_st_ch4,dm_st_ch5,dm_st_ch6,dm_st_ch7,dm_st_ch8,
                 dm_st_ch9,dm_st_ch10);

 TDMM6500_VoltageDCRange=(dm_vdrAuto,dm_vdr100mV,dm_vdr1V,dm_vdr10V,
                         dm_vdr100V,dm_vdr1000V);
 {TDMM6500_VoltageRatio}
 {DMM6500_VoltageDigRange - без Auto}
 TDMM6500_VoltageDigRange=dm_vdr100mV..dm_vdr1000V;

 TDMM6500_VoltageACRange=(dm_vcrAuto,dm_vcr100mV,dm_vcr1V,dm_vcr10V,
                         dm_vcr100V,dm_vcr750V);

 TDMM6500_CurrentDCRange=(dm_cdrAuto,dm_cdr10uA,dm_cdr100uA,
                         dm_cdr1mA,dm_cdr10mA,dm_cdr100mA,
                         dm_cdr1A,dm_cdr3A);
 TDMM6500_CurrentACRange=(dm_carAuto,dm_car100uA,
                         dm_car1mA,dm_car10mA,dm_car100mA,
                         dm_car1A,dm_car3A);
 {DMM6500_CurrentDigRange - без Auto}
 TDMM6500_CurrentDigRange=dm_cdr100uA..dm_cdr3A;

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

 TQuireFunction=Function():boolean of object;

const
 DMM6500_Test='KEITHLEY INSTRUMENTS,MODEL DMM6500';
 SCAN2000_Test='2000,10-Chan Mux';
// TCSCAN2001_Test='2000,10-Chan Mux';
 Pseudocard_Test='2000,Pseudo 10Ch Mux';

 CardeafNodeDMM6500:array[0..3]of string=
 (':vch',':star',':end',':vmax');

 DMM6500_VoltageDCRangeLabels:array[TDMM6500_VoltageDCRange]of string=
         ('Auto','100 mV', '1 V', '10 V', '100 V', '1000 V');
 DMM6500_VoltageACRangeLabels:array[TDMM6500_VoltageACRange]of string=
         ('Auto','100 mV', '1 V', '10 V', '100 V', '750 V');
 DMM6500_CurrentDCRangeLabels:array[TDMM6500_CurrentDCRange]of string=
         ('Auto','10 mkA', '100 mkA', '1 mA', '10 mA', '100 mA',
         '1 A', '3 A');
 DMM6500_CurrentACRangeLabels:array[TDMM6500_CurrentACRange]of string=
         ('Auto', '100 mkA', '1 mA', '10 mA', '100 mA',
         '1 A', '3 A');
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


//VOLTage[:DC]  RESistance  TEMPerature  VOLTage[:DC]:RATio
//VOLTage:AC  FRESistance  CONTinuity  DIGitize:VOLTage
//CURRent[:DC]  DIODe  FREQuency[:VOLTage]  DIGitize:CURRent
//CURRent:AC  CAPacitance  PERiod[:VOLTage]

implementation

end.
