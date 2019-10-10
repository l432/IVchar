
byte Mode = 0;
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
  int Value=analogRead(A1);

  if (((Value<MaxLow)||(Value>MaxHigh))&&(Mode>0)){
    Mode--;
    SetMode();
  };
  if (((Value<MinHigh)&&(Value>MinLow))&&(Mode<3)){
    Mode++;
    SetMode();
  };
  
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


