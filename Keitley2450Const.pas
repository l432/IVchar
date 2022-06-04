unit Keitley2450Const;

interface

uses
  SCPI, StdCtrls;
const

  Kt_2450_Test='KEITHLEY INSTRUMENTS,MODEL 2450';
  Kt2450DisplayDNLabel='.5 digit';
  Kt2450DefBuffer='defbuffer1';
  Kt2450DefBuffer2='defbuffer2';
  MyBuffer='OlegData';

  RootNoodKt_2450:array[0..22]of string=
  ('*idn?','*rcl ','*rst','*sav',':acq',':outp',':disp',':syst','scr:run',
//   0       1       2      3      4        5       6        7      8
  'rout',':sens',':sour',':curr', ':volt', ':res',':func',':azer:once','init',
//  9       10     11        12      13      14      15         16       17
  ':abor',':trac',':coun',':read',':fetc');
//   18      19      20      21      22

  SuffixKt_2450:array[0..7]of string=('on','off', 'rst',{'?','prot',}'def',
//                                      0    1      2                  3
 'amp','volt','ohm','watt' );
//   4     5    6      7

  FirstNodeKt_2450:array[0..35]of string=
  (':scr',':user1:text',':user2:text','cle',':pos',':int:stat',':term',
//     0       1             2         3      4        5         6
   ':rsen',':smod',':ocom',':prot',':trip',':vlim',':ilim',':unit',
//    7       8       9       10      11      12      13      14
   ':rang',':rang:auto',':read:back',':llim',':ulim',':azer',':del',
//   15         16            17        18     19      20       21
   ':del:auto',':list',':app',':swe',':nplc',':high:cap',':dig',':make',
//      22        23      24     25     26        27       28      29
   ':del',':poin',':fill:mode',':data',':cle',':act');
//   30     31         32         33     34     35


   PartDelimiter=', ';

type

 TKt2450_SetupMemorySlot=0..4;
 TKt2450_OutputTerminals=(kt_otFront, kt_otRear);
 TKt2450_Source=(kt_sVolt, kt_sCurr);
 TKt2450_SourceBool=array[TKt2450_Source]of boolean;
 TKt2450_SourceDouble=array[TKt2450_Source]of double;
 TKt2450_Measure=(kt_mCurrent,kt_mVoltage,kt_mResistance{,kt_mPower});
 TKt2450_Sense=(kt_s4wire,kt_s2wire);
 TKt2450_Senses=array[TKt2450_Measure]of TKt2450_Sense;
 TKt2450_MeasureBool=array[TKt2450_Measure]of boolean;
 TKt2450_MeasureDouble=array[TKt2450_Measure]of double;

 TKt_2450_OutputOffState=(kt_oos_norm,kt_oos_zero,kt_oos_himp,kt_oos_guard);
 TKt_2450_OutputOffStates=array[TKt2450_Source]of TKt_2450_OutputOffState;

 TKt_2450_VoltageProtection=(kt_vp2,kt_vp5,kt_vp10,kt_vp20,kt_vp40,kt_vp60,
                            kt_vp80,kt_vp100,kt_vp120,kt_vp140,kt_vp160,
                            kt_vp180,kt_vpnone);
 TKt_2450_MeasureUnit=(kt_mu_amp,kt_mu_volt, kt_mu_ohm, kt_mu_watt);
 TKt_2450_MeasureUnits=array[TKt2450_Measure]of TKt_2450_MeasureUnit;

 TKt_2450_Mode=(kt_md_sVmC,kt_md_sVmV,kt_md_sVmR,kt_md_sVmP,
                kt_md_sImC,kt_md_sImV,kt_md_sImR,kt_md_sImP);

 TKt2450_Settings=(kt_voltprot,kt_mode,kt_meascount);
 TKt2450_SourceSettings=(kt_ss_outputoff,kt_ss_delay,kt_ss_value,
         kt_ss_limit,kt_ss_range);

 TKt2450_MeasureSettings=(kt_ms_rescomp,kt_ms_displaydn,
                          kt_ms_sense,kt_ms_range,
                          kt_ms_time,kt_ms_lrange);
 TKt2450_MeasureShowType=(kt_mst_cur,kt_mst_volt,kt_mst_res,kt_mst_pow);

 TKt2450VoltageRange=(kt_vrAuto,kt_vr20mV,kt_vr200mV,kt_vr2V,
                      kt_vr20V,kt_vr200V);

 TKt2450CurrentRange=(kt_crAuto,kt_cr10nA,kt_cr100nA,kt_cr1uA,
                      kt_cr10uA,kt_cr100uA,kt_cr1mA,kt_cr10mA,
                      kt_cr100mA,kt_cr1A);

 Kt2450DisplayDigitsNumber=3..6;
 TKt2450_MeasureDisplayDN=array[TKt2450_Measure]of Kt2450DisplayDigitsNumber;

 TKt2450_SweepRangeType=(kt_srt_Auto,kt_srt_Best,kt_srt_Fixed);

 TKt2450_SweepSettings=(kt_sws_start,kt_sws_stop,kt_sws_delay,
                        kt_sws_stpo,kt_sws_count,kt_sws_ranget);

 TKt2450_SweepButtons=(kt_swb_create,kt_swb_init,kt_swb_stop);

 TKt2450_SweepButtonArray=array[TKt2450_SweepButtons] of TButton;

 TKt2450_BufferStyle=(kt_bs_comp,{6.5 digits, 1 us accurate relative
                                timestamp with a one-hour time span
                                before the timestamp starts over}
                      kt_bs_stan,{full accuracy with formatting,
                                 the timestamp is absolute; full
                                 date and time is recorded}
                      kt_bs_full,// plus additional information
                      kt_bs_writ,{буфер, куди не можна записувати результати
                                 вимірювань, для збереження якоїсь зовнішньої
                                 інформації}
                      kt_bs_fwrite);// два зовнішніх значення на запис
TKt2450_BufferFillMode=(kt_fm_cont,kt_fm_once);
{в першому випадку при досягнення кінці запис продовжується спочатку,
в другому - виникає помилка}

{що саме хочемо отримати від приладу}
TKt2450_ReturnedData=(kt_rd_MS,{результат виміру та значення джерела}
                      kt_rd_MT,{результат виміру та його час}
                      kt_rd_MST, {результат виміру, джерело, час}
                      kt_rd_M);{результат виміру}

const
 Kt2450_TerminalsName:array [TKt2450_OutputTerminals]
            of string=('fron', 'rear');
 Kt2450_TerminalsButtonName:array [TKt2450_OutputTerminals]
            of string=('Front Terminals', 'Rear Terminals');
 Kt2450_OutPutOnOffButtonName:array [Boolean]
            of string=('OutPut off', 'OutPut on');

 Kt2450_SourceName:array [TKt2450_Source] of string=
           ('volt', 'curr');
// Kt2450_MeasureName:array [TKt2450_Measure] of string=
//           (':curr', ':volt', ':res'{, ':pow??'});
 Kt_2450_OutputOffStateName:array[TKt_2450_OutputOffState]of string=
          ('norm','zero', 'himp', 'guar');
 Kt_2450_VoltageProtectionLabel:array[TKt_2450_VoltageProtection]of string=
          ('2V','5V','10V','20V','40V','60V','80V','100V','120V',
           '140V','160V','180V','none');
 Kt_2450_VoltageLimLimits:TLimitValues=(0.02,210);
 Kt_2450_VoltageLimDef=21;
 Kt_2450_CurrentLimLimits:TLimitValues=(1e-9,1.05);
 Kt_2450_CurrentLimDef=1.05e-4;

 Kt_2450_RangesLimits:array[TKt2450_Measure] of TLimitValues=
  ((1e-8,1),(0.02,200),(2,2e8));
 Kt_2450_SourceDelayLimits:TLimitValues=(0,1e3);
 Kt_2450_SweepDelayLimits:TLimitValues=(5e-5,1e3);

 Kt_2450_MeasureTimeLimits:TLimitValues=(0.01,10);
 KT_2450_MeaureTimeConvertConst=20;

 Kt_2450_SourceSweepLimits:array[TKt2450_Source] of TLimitValues=
 ((-210,210),(-1.05,1.05));
 Kt_2450_SweepPointsLimits:TLimitValues=(2,1e6);
 Kt_2450_SweepCountLimits:TLimitValues=(1,268435455);
 Kt_2450_BufferSizeLimits:TLimitValues=(10,1e6);
 {загалом ємність всіх буферів - 4,500,000 стандартних
  записів або 20,000,000 компактних}

 KT2450_SenseLabels:array[TKt2450_Sense]of string=
 ('4-Wire','2-Wire');
 KT2450_OutputOffStateLabels:array[TKt_2450_OutputOffState]of string=
 ('Normal','Zero','H-Impedance','Guard');
 KT2450_ModeLabels:array[TKt_2450_Mode]of string=
 ('sourceV measI','sourceV measV','sourceV measI(R)','sourceV measI(P)',
  'sourceI measI','sourceI measV','sourceI measV(R)','sourceI measI(P)');

 KT2450_VoltageRangeLabels:array[TKt2450VoltageRange]of string=
         ('Auto','20 mV', '200 mV', '2 V', '20 V', '200 V');
 KT2450_CurrentRangeLabels:array[TKt2450CurrentRange]of string=
         ('Auto','10 nA', '100 nA', '1 µA', '10 µA', '100 µA',
          '1 mA', '10 mA', '100 mA', '1 A');
 KT2450_SweepRangeNames:array[TKt2450_SweepRangeType]of string=
         ('auto','best', 'fix');
 KT2450_SweepRangeLabels:array[TKt2450_SweepRangeType]of string=
         ('Auto','Best', 'Fixed');
 Kt2450_SweepButtonNames:array[TKt2450_SweepButtons] of string=
        ('Create','Init','Abort');
 Kt2450_SweepLabelNames:array[TKt2450_SweepSettings]of string=
          ('From, ','To, ', 'Delay, s', 'Step, ',
           'Times to run','Used range');

Kt2450_PartInRespond:array[TKt2450_ReturnedData] of integer=
               (2,2,3,1);



//  OperationKod:array [TKt2450_Settings] of array[0..2] of byte=
////                  RootNood  FirstNode  LeafNode
//{kt_curr_sense}   ((  10,         0,           0),
//{kt_volt_sense}    (  10,         1,           0),
//{kt_res_sense}     (  10,         2,           0),
//{kt_outputoff}     (   5,         2,           0),
//{kt_rescomp}       (  10,         2,           1),
//{kt_voltprot}      (  11,         1,           0)
//
//    );



implementation

end.
