const int A = 4;
const int B = 8;

int value = 0;
int aLast;

void setup() {
  Serial.begin(9600);

  pinMode(A, INPUT);
  pinMode(B, INPUT);
  aLast = digitalRead(A);
}

void loop() {
  int aNow = digitalRead(A);
  int bNow = digitalRead(B);

  if (aLast != aNow){
    if (bNow != aNow){
      value++;
    }else{
      value--;
    }
    aLast = aNow;
    Serial.println(value);
  }
}
