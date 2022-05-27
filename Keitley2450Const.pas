unit Keitley2450Const;

interface

uses
  SCPI;
const

  Kt_2450_Test='KEITHLEY INSTRUMENTS,MODEL 2450';

  RootNoodKt_2450:array[0..15]of string=
  ('*idn?','*rcl ','*rst','*sav',':acq',':outp','disp:',':syst','scr:run',
//   0       1      2      3      4        5       6        7      8
  'rout',':sens',':sour',':curr', ':volt', ':res',':func');
//  9       10     11        12      13      14      15


  SuffixKt_2450:array[0..7]of string=('on','off', 'rst',{'?','prot',}'def',
//                                      0    1      2                  3
 'amp','volt','ohm','watt' );
//   4     5    6      7

  FirstNodeKt_2450:array[0..17]of string=
  ('scr','user1:text','user2:text','cle',':pos',':int:stat',':term',
//     0       1             2         3      4        5         6
   ':rsen',':smod',':ocom',':prot',':trip',':vlim',':ilim',':unit',
//    7       8       9       10      11      12      13      14
   ':rang',':rang:auto',':read:back');
//   15         16            17



type

 TKt2450_SetupMemorySlot=0..4;
 TKt2450_OutputTerminals=(kt_otFront, kt_otRear);
 TKt2450_Source=(kt_sVolt, kt_sCurr);
 TKt2450_Measure=(kt_mCurrent,kt_mVoltage,kt_mResistance{,kt_mPower});
 TKt2450_Sense=(kt_s4wire,kt_s2wire);
 TKt2450_Senses=array[TKt2450_Measure]of TKt2450_Sense;
 TKt2450_MeasureBool=array[TKt2450_Measure]of boolean;
 TKt2450_SourceBool=array[TKt2450_Source]of boolean;

 TKt_2450_OutputOffState=(kt_oos_norm,kt_oos_zero,kt_oos_himp,kt_oos_guard);
 TKt_2450_OutputOffStates=array[TKt2450_Source]of TKt_2450_OutputOffState;

 TKt_2450_VoltageProtection=(kt_vp2,kt_vp5,kt_vp10,kt_vp20,kt_vp40,kt_vp60,
                            kt_vp80,kt_vp100,kt_vp120,kt_vp140,kt_vp160,
                            kt_vp180,kt_vpnone);
 TKt_2450_MeasureUnit=(kt_mu_amp,kt_mu_volt, kt_mu_ohm, kt_mu_watt);
 TKt_2450_MeasureUnits=array[TKt2450_Measure]of TKt_2450_MeasureUnit;

 TKt_2450_Mode=(kt_md_sVmC,kt_md_sVmV,kt_md_sVmR,kt_md_sVmP,
                kt_md_sImC,kt_md_sImV,kt_md_sImR,kt_md_sImP);

 TKt2450_Settings=({kt_curr_sense,kt_volt_sense,kt_res_sense,}
                   {kt_outputoff,kt_rescomp,}kt_voltprot,kt_mode);
 TKt2450_SourceSettings=(kt_ss_outputoff,kt_ss_limit,kt_ss_range);

 TKt2450_MeasureSettings=(kt_ms_rescomp,kt_ms_sense);
 TKt2450_MeasureShowType=(kt_mst_cur,kt_mst_volt,kt_mst_res,kt_mst_pow);

 TKt2450VoltageRange=(kt_vrAuto,kt_vr20mV,kt_vr200mV,kt_vr2V,
                      kt_vr20V,kt_vr200V);

 TKt2450CurrentRange=(kt_crAuto,kt_vr10nA,kt_vr100nA,kt_vr1uA,
                      kt_vr10uA,kt_vr100uA,kt_vr1mA,kt_vr10mA,
                      kt_vr100mA,kt_vr1A);



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

 KT2450_SenseLabels:array[TKt2450_Sense]of string=
 ('4-Wire','2-Wire');
 KT2450_OutputOffStateLabels:array[TKt_2450_OutputOffState]of string=
 ('Normal','Zero','H-Impedance','Guard');
 KT2450_ModeLabels:array[TKt_2450_Mode]of string=
 ('sourceV measI','sourceV measV','sourceV measR(I)','sourceV measP(I)',
  'sourceI measI','sourceI measV','sourceI measR(I)','sourceI measP(I)');

 KT2450_VoltageRangeLabels:array[TKt2450VoltageRange]of string=
         ('Auto','20 mV', '200 mV', '2 V', '20 V', '200 V');
// KT2450_VoltageRangeData:array[TKt2450VoltageRange]of string=
//         ('def','2e-2', '0.2', '2', '20', '200');
 KT2450_CurrentRangeLabels:array[TKt2450CurrentRange]of string=
         ('Auto','10 nA', '100 nA', '1 µA', '10 µA', '100 µA',
          '1 mA', '10 mA', '100 mA', '1 A');
//          Low Limit äî 100 mA  | äî 20 Â

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
