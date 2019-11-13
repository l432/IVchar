#include <avr/io.h>
#include <util/delay.h>

byte Mode = 0;
const int MaxLow = 142;
const int MaxHigh = 896;
const int MinLow = 511;
const int MinHigh = 520;

int main(void) {

  DDRB |= B00000011;
  SetMode();
  ADCSRA = 0;
  ADMUX = B00000001;
  //  ADMUX = B00000110;
  //  ADCSRB |= _BV(BIN);
  ADCSRA = B10000010;
  while (1) {


    int Value = anRead();

    //    showResult(Value);


    if ((Mode > 0) && ((Value < MaxLow) || (Value > MaxHigh))) {
      Mode--;
      SetMode();
    };
    if ((Mode < 2) && ((Value < MinHigh) && (Value > MinLow))) {
      Mode++;
      SetMode();
    };
  }
}

void showResult(int val) {
  for (int i = 0; i < 10; i++) {
    byte kk = byte(val >> i) & B00000001;
    if (kk) {
      PORTB = B00000001;
    } else {
      PORTB = B00000010;
    }
    _delay_ms(1000);
    PORTB = B00000000;
    _delay_ms(1000);
  }
  PORTB = B00000011;
  _delay_ms(500);
  PORTB = B00000000;
  _delay_ms(500);
  PORTB = B00000011;
  _delay_ms(500);
  PORTB = B00000000;
  _delay_ms(500);
}

//void setup() {
//
//  DDRB |= B00001011;
//  //  pinMode(0, OUTPUT);
//  //  pinMode(1, OUTPUT);
//  //  pinMode(3, OUTPUT);
//  PORTB |= B00001000;
//  //  digitalWrite(3, HIGH);
//  SetMode();
//}
//
//// the loop routine runs over and over again forever:
//void loop() {
//  int Value = anRead();
////  int Value = analogRead(A1);
//
//  if (((Value < MaxLow) || (Value > MaxHigh)) && (Mode > 0)) {
//    Mode--;
//    SetMode();
//  };
//  if (((Value < MinHigh) && (Value > MinLow)) && (Mode < 3)) {
//    Mode++;
//    SetMode();
//  };
//
//}

void SetMode() {
  PORTB = (PORTB & B11111100) + Mode;
  //  if (Mode & B00000001) {
  //    digitalWrite(0, HIGH);
  //  } else {
  //    digitalWrite(0, LOW);
  //  }
  //
  //  if (Mode & B00000010) {
  //    digitalWrite(1, HIGH);
  //  } else {
  //    digitalWrite(1, LOW);
  //  }
}

int anRead() {
  uint8_t l, h;
  //  ADMUX = (ADMUX & _BV(REFS0)) | 1 & 3;
  //  ADMUX = B00000000;


  ADCSRA |= _BV(ADSC);
  //  ADCSRA |=B01000000;
  //  while (ADCSRA & (1 << ADSC)); //Wait for conversion
  while (ADCSRA & B01000000); //Wait for conversion

  l = ADCL;  //Read and return 10 bit result
  h = ADCH;

  return (h << 8) | l;
}

void ResistCarousel() {
  Mode = 0;
  SetMode();
  _delay_ms(5000);
  Mode = 1;
  SetMode();
  _delay_ms(5000);
  Mode = 2;
  SetMode();
  _delay_ms(5000);
  Mode = 3;
  SetMode();
  _delay_ms(5000);
}

