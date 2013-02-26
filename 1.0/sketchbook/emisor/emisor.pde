#include <XBee.h>

XBee xbee = XBee();

const int potenciometroGiro = 8;
const int potenciometroMotor = 9;
const int pinFreno = 10;

int giro;
int motor;
int freno;

void setup(){
 pinMode(potenciometroGiro, INPUT);
 pinMode(potenciometroMotor, INPUT);
 pinMode(pinFreno, INPUT);
 xbee.begin(9600);
 Serial.begin(9600); 
}
void loop(){
 
   freno = 0;
   
   giro = analogRead(potenciometroGiro);
   motor = analogRead(potenciometroMotor);
   if(analogRead(pinFreno)==HIGH){
     freno = 1;
    }
   
   uint8_t payload[] = {freno, motor, giro };
   Tx16Request tx = Tx16Request(0x9999, payload, sizeof(payload));
   TxStatusResponse txStatus = TxStatusResponse();
   xbee.send(tx);
   if (xbee.readPacket(5000)) {         	
     if (xbee.getResponse().getApiId() == TX_STATUS_RESPONSE) {
    	xbee.getResponse().getZBTxStatusResponse(txStatus);
        if (txStatus.getStatus() == SUCCESS) {
          
           } 
        }      
     }
}
