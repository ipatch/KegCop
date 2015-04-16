/*
 * kegboard-clone-4-KegCop
 * This code is public domain
 *
 * This sketch sends a receives a multibyte String from the iPhone
 * and performs functions on it.
 *
 * This Arduino sketch is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the MIT Public License
 * along with this sketch.
 *
 * Examples:
 * http://arduino.cc/en/Tutorial/SerialEvent
 * http://arduino.cc/en/Serial/read
 * http://stackoverflow.com/questions/16532586/arduino-sketch-that-responds-to-certain-commands-how-is-it-done/
 * http://davebmiller.wordpress.com/2011/01/18/arduino-flowmeter/
 * http://forum.arduino.cc/index.php?topic=52003.0
 * http://arduino.cc/en/Reference/AttachInterrupt
 * https://github.com/just-kile/Zapfmaster2000/blob/master/src/zapfmaster2000-zapfkit-avr/draftkitAVR.ino
 * http://www.pjrc.com/teensy/td_libs_Time.html
 * http://www.pjrc.com/teensy/td_libs_TimeAlarms.html
 * https://github.com/antoinet/arduino-countdown/blob/master/countdown/countdown.ino
 *
 * TODO:
 *
 *
 */
int valveClosed = 0;
unsigned int gNextOCR = 0;
volatile unsigned long gMillis = 0;
bool valveOpened = false;
#define GMilliSecondPeriod F_CPU / 1000
#define pourTime = 45000;
unsigned long currentTime = 0;
unsigned long pastTime = 0;
int currentState = 0;
int wait = 10000;

// flow_A LED
int led = 4;

// relay_A
const int RELAY_A = A0;

// string / serial event variables
String inputString = ""; // a string to hold incoming data
boolean stringComplete = false; // whether the string is complete
boolean valve_open = false;

// FLOWMETER STUFF
// flowmeter 0 pulse (input) = digital pin 2
// https://github.com/Kegbot/kegboard/blob/master/arduino/kegboard/kegboard_config.h
// which pin to use for reading the sensor? kegboard-mini shield has digital pin 2 allocated
// the SF800 outputs 5400 pulses per litre
// The hall-effect flow sensor (SF800) outputs approximately 5400 pulses per second per litre/minute of flow
// SF800 default (5400 ticks/Liter == 5.4 ticks/mL == 1/5.4 mL/tick)
int flowmeterPin = 2; // changed from byte
int flowmeterPinState = 0; // variable for storing state of sensor pin
// read RPM
unsigned long lastmillis = 0;

// NEW GLOBALS - 29JUL13
// initial ticks on flow meter
volatile unsigned int numTicks = 0;
// interval for flow meter frequency
int interval = 250;
volatile long previousMillis = 0;

void setup() {
    // initialize serial
    // Serial.flush(); // flush the serial buffer on setup.
    Serial.begin(115200); // open serial port, sets data rate to 9600bps
    Serial.println("Power on test");
    inputString.reserve(200);
    valve_open = false;
    
    // relay for solenoid cut off valve
    pinMode(RELAY_A, OUTPUT);
    
    // flowmeter shit
    pinMode(flowmeterPin, INPUT);
    digitalWrite(flowmeterPin, HIGH); // Need to set these HIGH so they won't just tick away
    
    // The Hall-effect sensor is connected to pin 2 which uses interrupt 0.
    // Configured to trigger on a RISING state change (transition from HIGH
    // state to LOW state)
    attachInterrupt(0, count, FALLING);
    
    setupTime();
    
}

// Just call this function within your setup
void setupTime(){
    TCCR2B |= _BV(CS02);
    TIMSK2 |= _BV(OCIE0A);
    
    sei(); // enable interupts
}

void open_valve() {
    digitalWrite(RELAY_A, HIGH); // turn RELAY_A on
    valve_open = true;
}

void close_valve() {
    digitalWrite(RELAY_A, LOW); // turn RELAY_A off
    valve_open = false;
}

void flow_A_blink() {
    digitalWrite(led, HIGH); // turn the LED on (HIGH is the voltage level)
    delay(1000); // wait for one second
    digitalWrite(led, LOW); // turn the LED off by making the voltage LOW
    delay(1000); // wait for a second
}

void flow_A_blink_stop() {
    digitalWrite(led, LOW);
}

void flow_A_on() {
    digitalWrite(led, HIGH); // turn the LED on (HIGH is the voltage level)
}

void flow_A_off() {
    digitalWrite(led, LOW); // turn the LED off by making the voltage LOW
}

// This interruption will be called every 1ms
ISR(TIMER2_COMPA_vect)
{
    if(valve_open){
        gMillis++;
        //    Serial.println(gMillis);
        if(gMillis >= 30000){
            close_valve();
            gMillis = 0;
            valveClosed = 1;
            loop();
        }
    }
    
    gNextOCR += GMilliSecondPeriod;
    OCR2A = gNextOCR >> 8; // smart way to handle millis, they will always be average of what they should be
}


// flowmeter stuff
bool getFlow4() {
    
    // call the countdown function for pouring beer
    
    
    // Serial.println(flowmeterPin);
    flowmeterPinState = digitalRead(flowmeterPin);
    // Serial.println(flowmeterPinStatePinState);
    volatile unsigned long currentMillis = millis();
    // if the predefined interval has passed
    if (millis() - lastmillis >= 250) { // Update every 1/4 second
        // disconnect flow meter from interrupt
        detachInterrupt(0); // Disable interrupt when calculating
        
        Serial.print("Ticks:");
        Serial.println(numTicks);
        // numTicks = 0; // Restart the counter.
        lastmillis = millis(); // Update lastmillis
        attachInterrupt(0, count, FALLING); // enable interrupt
    }
    if(numTicks >= 331 || valveClosed == 1) {
        close_valve();
        numTicks = 0; // Restart the counter.
        valveClosed = 0;
        return 0;
    }
}
// flow meter interrupt function
void count(){
    numTicks++;
    flow_A_blink();
}

/*
 * Main program loop, runs over and over repeatedly
 */

void loop() {
    if(stringComplete) {
        // Serial.println(inputString);
        
        if(inputString.equals("{open_valve}")) {
            // Serial.println("inputString equates :)");
            open_valve();
        }
        
        if(inputString.equals("{close_valve}")) {
            // Serial.println("close vavle.");
            close_valve();
        }
        if(valve_open) {
            // Serial.println("valve_open = true");
            inputString = "";
            stringComplete = false;
            while(getFlow4()) {
            }
            // Serial.println("I'm here now :)");
        }
        // clear the string:
        inputString = "";
        stringComplete = false;
    }
    //Serial.println("over and over");
}

/*
 SerialEvent occurs whenever a new data comes in the
 hardware serial RX. This routine is run between each
 time loop() runs, so using delay inside loop can delay
 response. Multiple bytes of data may be available.
 */

void serialEvent() {
    while(Serial.available()) {
        // get the new byte:
        char inChar = (char)Serial.read();
        // add it to the inputString:
        inputString += inChar;
        // if the incoming character is a newline, set a flag
        // so the main loop can do something about it:
        if (inChar == '}') {
            stringComplete = true;
        }
        // Serial.println(inputString.length());
    }
}