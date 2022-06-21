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
  MySourceList='OlegSourceList';
  MyMeasList='OlegMeasList';

  RootNoodKt_2450:array[0..27]of string=
  ('*idn?','*rcl ','*rst','*sav',':acq',':outp',':disp',':syst','scr:run',
//   0       1       2      3      4        5       6       7      8
  'rout',':sens',':sour',':curr', ':volt', ':res',':func',':azer:once','init',
//  9       10     11        12      13      14      15         16       17
  ':abor',':trac',':coun',':read',':fetc',':dig',':conf','*wai',':trig','*trg');
//   18      19      20      21      22      23    24      25     26      27

  SuffixKt_2450:array[0..7]of string=('on','off','rst','def',
//                                      0    1     2     3
 'amp','volt','ohm','watt' );
//   4     5    6      7

  FirstNodeKt_2450:array[0..45]of string=
  (':scr',':user1:text',':user2:text','cle',':pos',':int:stat',':term',
//     0       1             2         3      4        5         6
   ':rsen',':smod',':ocom',':prot',':trip',':vlim',':ilim',':unit',
//    7       8       9       10      11      12      13      14
   ':rang',':rang:auto',':read:back',':llim',':ulim',':azer',':del',
//   15         16            17        18     19      20       21
   ':del:auto',':list',':app',':swe',':nplc',':high:cap',':dig',':make',
//      22        23      24     25     26        27       28      29
   ':ligh:stat',':poin',':fill:mode',':data',':beep',':act',':line#:mode',
//     30          31         32         33     34      35        36
   ':line#:stat',':load', ':bloc',':buff',':bran',':mdig',':bran',':paus',':res');
//      37         38        39      40      41      42      43      44     45

 ConfLeafNodeKt_2450:array[0..3]of string=
 (':cre',':del',':rec',':stor');

 TrigLeafNodeKt_2450:array[0..8]of string=
 (':cle',':rec',':next',':stat',':alw',':cons',':lim:cons',':coun',':even');
//   0      1       2       3      4      5         6         7       8

   PartDelimiter=', ';
   CommandDelimiter='; ';

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

 TKt2450_SweepButtons=(kt_swb_create,kt_swb_init,kt_swb_stop,
                       kt_swb_pause,kt_swb_resume);

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

TKt2450_DigLines=1..6;
TKt2450_DigLineType=(kt_dt_dig, {як звичайні цифрові лінії}
                    kt_dt_trig, {тригерний режим, коли "1"-"0" задаються фронтом сигналу,
                                напрям імпульсів можна налаштовувати}
                    kt_dt_sync);{ще якийсь тригерний режим, де можна підключати декілька
                                Keitley-приладів... див. деталі в описі}
TKt2450_DigLineTypes=array[TKt2450_DigLines] of  TKt2450_DigLineType;

TKt2450_DigLineDirection=(kt_dd_in,  {працює на вхід, що означаї "1"-"0"
                                     суттєво залежить від типу лінії}
                         kt_dd_out, {працює на вихід, що означаї "1"-"0"
                                     суттєво залежить від типу лінії}
                         kt_dd_opdr, {режим з відкритим затвором,
                                       може бути як вхідним, так і вихідним,
                                      наскільки я зрозумів}
                         kt_dd_mas,
                         kt_dd_ac);   {два останні варіанти можуть бути
                                      використані лише для kt_dt_sync}

TKt2450_DigLineDirections=array[TKt2450_DigLines] of  TKt2450_DigLineDirection;

TKt2450_DisplayState=(kt_ds_on100,kt_ds_on75,kt_ds_on50,kt_ds_on25,
                      kt_ds_off,kt_ds_black);

TK2450_TrigLimitType=(kt_tlt_above, kt_tlt_below, kt_tlt_inside, kt_tlt_outside);
TK2450_TriggerEvents=(kt_te_comm,//подія через command interface
                      kt_te_disp,//натискування кнопки "TRIGGER" на панелі
                      kt_te_none,//відсутність події
                      kt_te_slim,//Source limit condition occurs
                      kt_te_timer,//завершився один з таймерів
                      kt_te_notify,//згенерувана одна з подій під час виконання моделі
                      kt_te_lan,//LXI trigger packet is received on LAN trigger object
                      kt_te_dig,//щось відбулося на цифрових лініях
                      kt_te_blend,//Trigger event blender, which combines trigger events
                      kt_te_tspl);//Line edge detected on TSP-Link synchronization line

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
 Kt_2450_TrigDelayLimits:TLimitValues=(1.67e-7,1e3);

 Kt_2450_MeasureTimeLimits:TLimitValues=(0.01,10);
 KT_2450_MeaureTimeConvertConst=20;

 Kt_2450_SourceSweepLimits:array[TKt2450_Source] of TLimitValues=
 ((-210,210),(-1.05,1.05));
 Kt_2450_SweepPointsLimits:TLimitValues=(2,1e6);
 Kt_2450_SweepCountLimits:TLimitValues=(1,268435455);
 Kt_2450_BufferSizeLimits:TLimitValues=(10,1e6);
 {загалом ємність всіх буферів - 4,500,000 стандартних
  записів або 20,000,000 компактних}
 Kt_2450_BeepDurationLimits:TLimitValues=(1e-3,1e2);
 Kt_2450_BeepFrequancyLimits:TLimitValues=(20,8000);

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
        ('Create','Init','Abort','Pause','Resume');
 Kt2450_SweepLabelNames:array[TKt2450_SweepSettings]of string=
          ('From, ','To, ', 'Delay, s', 'Step, ',
           'Times to run','Used range');

Kt2450_PartInRespond:array[TKt2450_ReturnedData] of integer=
               (2,3,4,1);

Kt2450_DigLineTypeCommand:array[TKt2450_DigLineType]of string=
       ('dig','trig','sync');

Kt2450_DigLineDirectionCommand:array[TKt2450_DigLineDirection]of string=
       ('in','out','open','mast','acc');

Kt2450_DisplayStateCommand:array[TKt2450_DisplayState]of string=
       ('on100','on75','on50','on25','off','blac');

Kt2450_DisplayStateLabel:array[TKt2450_DisplayState]of string=
       ('Full brightness','75% brightness','50% brightness',
        '25% brightness','Display off','Display & indicators off');

Kt2450_TrigLimitTypeCommand:array[TK2450_TrigLimitType]of string=
       ('abov','bel','in','out');

Kt2450_TriggerEventsCommand:array[TK2450_TriggerEvents]of string=
       ('comm','disp','none','slim','tim','not',
        'lan','dig','blen','tspl');




implementation

end.
