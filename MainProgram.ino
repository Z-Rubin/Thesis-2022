long startTime = 0;
int hall_sensor = A0;
int trigger_mag = 11;
int startTest = 3;
int led_pin = 2;
long long prevTime;
long long currentTime;
long iterCount;
bool testRunning;
long currentMeasure = 0;
long prevMeasure = 0;
long totalTime;
float totalTimeSeconds;
long period = 0;
float periodSeconds;
void setup() {
  // put your setup code here, to run once:
Serial.begin(9600);
pinMode(hall_sensor, INPUT);
pinMode(trigger_mag, OUTPUT);
pinMode(startTest, INPUT_PULLUP);
pinMode(led_pin, OUTPUT);

}

void loop() {
  if (!(digitalRead(startTest))){
    //initiate test
    Serial.println("Test started");
    testRunning = true;
    digitalWrite(trigger_mag, HIGH);
    delay(100);
    digitalWrite(trigger_mag, LOW);
    startTime = millis();
    currentTime = startTime;
    iterCount = 0;
    while (testRunning){
      
      prevMeasure = currentMeasure;
      currentMeasure = 0;
      for (int i = 0; i <3; i++){
        currentMeasure += analogRead(hall_sensor); 
      }
      currentMeasure /= 3;
      // check if magnet is detected.
      if ((prevMeasure - currentMeasure) > 25){    
        //Serial.println(prevMeasure - currentMeasure);  
        delay(20);
        digitalWrite(trigger_mag, HIGH);
        digitalWrite(led_pin, HIGH);

        if (iterCount != 0){
      //record half period measured
          prevTime = currentTime;
          currentTime = millis();
          if (currentTime-prevTime > 350){
            //periodMeasured[iterCount-1] = currentTime-prevTime; //-100 to account for delay above
            period = currentTime-prevTime;
            Serial.print(period);
            Serial.print(", ");
            totalTime += currentTime-prevTime;
            totalTimeSeconds = float(totalTime)/1000;
            Serial.println(totalTimeSeconds);
            iterCount += 1;   
          }
        } else {
          iterCount += 1;    
        }
        delay(200);
        digitalWrite(trigger_mag, LOW);  
        digitalWrite(led_pin, LOW);
      }
      // finish recordings
      if ((millis() - startTime)/1000 > 300){
        testRunning = false;
        Serial.println(startTime);
      }
      delay(5);
    }
  }
 
  




 delay(50);
}
