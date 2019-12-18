
Function Byte2Hex(B: Byte):String;
Const hStr : String ='0123456789ABCDEF';
Begin
 Byte2Hex:= hStr[(B div 16)+1]+ hStr[(B mod 16)+1];
End;

Function Long2Hex(B: Longint):String;
Begin
 Long2Hex:= Byte2Hex(B div $100)+ Byte2Hex(B and $0FF);
End;

{ Возвращает базовый адрес порта с номером PortIndex }
Function GetBaseAdr(PortIndex : Byte) : Word;
Var LowAdr : Word;
Begin
 { вычисляем младшую часть адреса в таблице }
 LowAdr := (PortIndex-1)*2;
 { получаем базовый адрес порта из таблицы }
 GetBaseAdr:= MemW[$0040:LowAdr];
End;

Var
 PortIndex : Byte;
 BaseAdr   : Word;

Begin
 { Опрос базовых адресов 4 портов }
 For PortIndex:= 1 to 8 do begin
  { Получить базовый адрес}
  BaseAdr:= GetBaseAdr(PortIndex);

  { Анализируем базовый адрес }
  If BaseAdr = 0 then
   WriteLn('COM', PortIndex,' не обнаружен')
  Else
   WriteLn('Базовый адрес COM',PortIndex,' равен ', Long2Hex(BaseAdr));

 End;
 readln;
End.