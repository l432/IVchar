
byte Mode = 2;
const int MaxLow = 102;
const int MaxHigh = 819;
const int MinLow = 410;
const int MinHigh = 614;

void setup() {
  pinMode(0, OUTPUT);
  pinMode(1, OUTPUT);
  pinMode(3, OUTPUT);
  digitalWrite(3, HIGH);
  SetMode();
}

// the loop routine runs over and over again forever:
void loop() {
// Mode=0;
// SetMode();
// delay(1000);
// Mode=1;
// SetMode();
// delay(1000);
//  Mode=2;
// SetMode();
// delay(1000);
// Mode=3;
// SetMode();
 delay(1000);
//
//  int Value=analogRead(A1);
//
//    showResult(Value);
//    PORTB = B00001011;
//    delay(500);
//    PORTB = B00001000;
//    delay(500);
//    PORTB = B00001011;
//    delay(500);
//    PORTB = B00001000;
//    delay(500);

//
//  if (((Value<MaxLow)||(Value>MaxHigh))&&(Mode>0)){
//    Mode--;
//    SetMode();
//  };
//  if (((Value<MinHigh)&&(Value>MinLow))&&(Mode<3)){
//    Mode++;
//    SetMode();
//  };
  
}

void SetMode() {
  if (Mode & B00000001){
    digitalWrite(0, HIGH);
  } else {
    digitalWrite(0, LOW);
  }
 
  if (Mode & B00000010){
    digitalWrite(1, HIGH);
  } else {
    digitalWrite(1, LOW);
  }
  
}


void showResult(int val) {
  for (int i = 0; i < 10; i++) {
    byte kk = byte(val >> i) & B00000001;
    if (kk) {
      PORTB = B00001001;
    } else {
      PORTB = B00001010;
    }
    delay(1000);
    PORTB = B00001000;
delay(1000);
  }

}


