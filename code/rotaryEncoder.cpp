const int A = 4;
const int B = 8;
const int GR = 5;
const int RO = 6;
const int GE = 7;

int value = 0;
int aLast;

int state = 000;

void setup() {
  Serial.begin(9600);

  pinMode(A, INPUT);
  pinMode(B, INPUT);
  aLast = digitalRead(A);

  digitalWrite(GR, HIGH);
  state = 001;
}

void loop() {
  int aNow = digitalRead(A);
  int bNow = digitalRead(B);
  
  if (aLast != aNow){
    if (bNow != aNow){
      value++;
      clockwise();
    }else{
      value--;
      counterclockwise();
    }
    aLast = aNow;
    Serial.println(value);
  }
}

void clockwise(){
  if (state == 001){
    digitalWrite(GR, LOW);
    digitalWrite(RO, HIGH);
    state = 010;
  }else if (state == 010){
    digitalWrite(RO, LOW);
    digitalWrite(GE, HIGH);
    state = 100;
  }else if (state == 100){
    digitalWrite(GE, LOW);
    digitalWrite(GR, HIGH);
    state = 001;
  }
}

void counterclockwise(){
  if (state == 001){
    digitalWrite(GR, LOW);
    digitalWrite(GE, HIGH);
    state = 100;
  }else if (state == 010){
    digitalWrite(RO, LOW);
    digitalWrite(GR, HIGH);
    state = 001;
  }else if (state == 100){
    digitalWrite(GE, LOW);
    digitalWrite(RO, HIGH);
    state = 010;
  }
}