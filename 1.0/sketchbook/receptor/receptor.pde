#include <Servo.h>
#include <XBee.h>
 

XBee xbee = XBee();
XBeeResponse response = XBeeResponse(); 
Rx16Response rx16 = Rx16Response();

const int enableVSS = 12;
const int control1 = 11;
const int control2 = 10;
const int pinServo = 9;
const int pinLed = 13;

int freno = 0;
int motor = 0;
int giro = 0;
Servo myservo;
 
void setup(){
  
  xbee.begin(9600);
  pinMode(enableVSS,OUTPUT);
  pinMode(control1,OUTPUT);
  pinMode(control2,OUTPUT);
  pinMode(pinLed, OUTPUT);
  
  digitalWrite(enableVSS,HIGH);
  myservo.attach(pinServo);
}

void loop(){ 
    xbee.readPacket();
    digitalWrite(pinLed,LOW);
    
    if (xbee.getResponse().isAvailable()) {
        if (xbee.getResponse().getApiId() == RX_16_RESPONSE) {
                xbee.getResponse().getRx16Response(rx16);
                digitalWrite(pinLed,HIGH);
                
                giro = rx16.getData(2);
                motor = rx16.getData(1);
                freno = rx16.getData(0);
                
                if(freno == 0){
                  controlMotor(motor);
                 }
                else{
                  frenar();
                }
                girar(giro);
              }
      }
}


void controlMotor (int valor){
 
  if(valor>511){
    digitalWrite(control1,HIGH);
    digitalWrite(control2,LOW);
  }
  else{
    digitalWrite(control1,LOW);
    digitalWrite(control2,HIGH);
  }
}

void girar(int valor){
 
 int val = 0;
 val = map(valor, 0, 1023, 0, 179);
 myservo.write(val);
 delay(15);
  
}

void frenar(){
  
  digitalWrite(control1,LOW);
  digitalWrite(control2,LOW);
  
}
