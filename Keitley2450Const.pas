unit Keitley2450Const;

interface
const

  Kt_2450_Test='KEITHLEY INSTRUMENTS,MODEL 2450';

  RootNoodKt_2450:array[0..14]of string=
  ('*idn?','*rcl ','*rst','*sav',':acq',':outp','disp:',':syst','scr:run',
//   0       1      2      3      4        5       6        7      8
  'rout',':sens',':sour',':curr', ':volt', ':res');
//  9       10     11        12      13      14


  SuffixKt_2450:array[0..4]of string=('on','off', 'rst', {'?',}'prot','def');

  FirstNodeKt_2450_5:array[0..2]of string=
  (':stat',':int:stat',':smod');
//   0       1             2         3

  FirstNodeKt_2450:array[0..5]of string=
  ('scr','user1:text','user2:text','cle',':pos',':int:stat');
//   0       1             2         3      4        5

//  FirstNodeKt_2450_6:array[0..3]of string=
//  ('scr','user1:text','user2:text','cle');
////   0       1             2         3
//
//  FirstNodeKt_2450_7:array[0..1]of string=
//  (':pos','???');

//  FirstNodeKt_2450_8:array[0..1]of string=
//  (':run','???');

  FirstNodeKt_2450_9:array[0..1]of string=
  (':term','???');

  FirstNodeKt_2450_10_3:array[0..2]of string=
  (':rsen',':ocom',':func');

  FirstNodeKt_2450_11_3:array[0..4]of string=
  (':prot',':ocom',':vlim',':ilim',':trip');

//:SOURce[1]:FUNCtion[:MODE] <function>
//[:SENSe[1]]:FUNCtion[:ON] "<function>"

type
 TLimits=(lvMin,lvMax);
 TLimitValues=array[TLimits] of double;

 TKt2450_SetupMemorySlot=0..4;
 TKt2450_OutputTerminals=(kt_otFront, kt_otRear);
 TKt2450_Source=(kt_sVolt, kt_sCurr);
 TKt2450_Measure=(kt_mCurrent,kt_mVoltage,kt_mResistance{,kt_mPower});
 TKt2450_Sense=(kt_s4wire,kt_s2wire);
 TKt2450_Settings=(kt_curr_sense,kt_volt_sense,kt_res_sense,
                   kt_outputoff,kt_rescomp,kt_voltprot);
 TKt_2450_OutputOffState=(kt_oos_norm,kt_oos_zero,kt_oos_himp,kt_oos_guard);
 TKt_2450_VoltageProtection=(kt_vp2,kt_vp5,kt_vp10,kt_vp20,kt_vp40,kt_vp60,
                            kt_vp80,kt_vp100,kt_vp120,kt_vp140,kt_vp160,
                            kt_vp180,kt_vpnone);


const
 Kt2450_TerminalsName:array [TKt2450_OutputTerminals] of string=('fron', 'rear');
 Kt2450_SourceName:array [TKt2450_Source] of string=
           ('volt', 'curr');
 Kt2450_MeasureName:array [TKt2450_Measure] of string=
           (':curr', ':volt', ':res'{, ':pow??'});
 Kt_2450_OutputOffStateName:array[TKt_2450_OutputOffState]of string=
          ('norm','zero', 'himp', 'guard');
 Kt_2450_VoltageProtectionLabel:array[TKt_2450_VoltageProtection]of string=
          ('2V','5V','10V','20V','40V','60V','80V','100V','120V',
           '140V','160V','180V','none');
 Kt_2450_VoltageLimLimits:TLimitValues=(0.02,210);
 Kt_2450_VoltageLimDef=21;
 Kt_2450_CurrentLimLimits:TLimitValues=(1e-9,1.05);
 Kt_2450_CurrentLimDef=1.05e-4;

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
