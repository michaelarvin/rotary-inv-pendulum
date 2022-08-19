#include <SimpleFOC.h>

HardwareSerial Serial3(PC5, PC4); //Rx, Tx

const byte numChars = 6;
uint8_t receivedChars[numChars];   // an array to store the received data
byte numReceived = 0;
boolean newData = false;

float dataNumber = 0;             // new for this version


// init BLDC motor
BLDCMotor motor = BLDCMotor( 14 );

BLDCDriver3PWM driver = BLDCDriver3PWM(PA8, PA9, PA10, PC7);
// init encoder
Encoder encoder = Encoder(PB4, PB5, 2048);
// channel A and B callbacks
void doA(){encoder.handleA();}
void doB(){encoder.handleB();}

// pendulum encoder init
Encoder pendulum = Encoder(PB6, PB7, 2048);
// interrupt routine 
void doPA(){pendulum.handleA();}
void doPB(){pendulum.handleB();}

void setup()
{
  
  // initialize motor encoder hardware
  encoder.init();
  encoder.enableInterrupts(doA,doB);
  
  // driver config
  driver.voltage_power_supply = 12;
  driver.init();
  
  // init the pendulum encoder
  pendulum.init();
  pendulum.enableInterrupts(doPA,doPB);
  
  // set control loop type to be used
  motor.torque_controller = TorqueControlType::voltage;
  motor.controller = MotionControlType::torque;

  
  // link the motor to the encoder
  motor.linkSensor(&encoder);
  // link the motor to the driver
  motor.linkDriver(&driver);
  
  Serial.begin(115200);
  Serial3.begin(115200);
  
  // initialize motor
  motor.init();
  // align encoder and start FOC
  motor.initFOC();
}

void loop()
{
  recvWithStartEndMarker();
  showNewNumber();
  
  motor.loopFOC();
  // pendulum sensor read
  pendulum.update();
  
  motor.move(dataNumber);
}


void recvWithStartEndMarker() {
    static boolean recvInProgress = false;
    static byte ndx = 0;
    uint8_t startMarker = 100;
    uint8_t endMarker = 200;
    uint8_t rc;
    
    while (Serial3.available() > 0 && newData == false) {
        rc = Serial3.read();

        if (recvInProgress == true) {
            if (rc != endMarker) {
                receivedChars[ndx] = rc;
                ndx++;
                if (ndx >= numChars) {
                    ndx = numChars - 1;
                }
            }
            else {
                receivedChars[ndx] = '\0'; // terminate the string
                recvInProgress = false;
                numReceived = ndx;
                ndx = 0;
                newData = true;
            }
        }

        else if (rc == startMarker) {
            recvInProgress = true;
        }
    }
}

void showNewNumber() {
    if (newData == true) {
        dataNumber = 0;
        dataNumber = (receivedChars[0] | receivedChars[1] << 8) - 12;
        
        Serial.print("This just in ... ");
        for (byte n = 0; n < numReceived; n++) {
            Serial.print(receivedChars[n]);
            Serial.print(' ');
        }
        Serial.println();
        Serial.print("Data as Number ... ");
        Serial.println(dataNumber);
        newData = false;
    }
}
