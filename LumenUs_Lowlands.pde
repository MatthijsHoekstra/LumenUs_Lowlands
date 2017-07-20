import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

import spout.*;



//------------------------------ Numbers for setup -----------------------------

int numModules = 6;

//------------------------------------------------------------------------------

int numTripods = numModules * 4;
int numTubes = numTripods * 3;
int numLEDsPerTube = 56;

int rectWidth = 9;
int rectHeight = 8;
int tubeLength = rectWidth * numLEDsPerTube;

int totalLengthInstallation = tubeLength*numTripods;

int x;
int y;

int selectedTube, tubeNumber;

Tube[] tubes = new Tube[numTubes];

Spout spout;

void setup() {
  size(1600, 880, OPENGL);
  frameRate(90);
  background(0);
  noStroke();
  noSmooth();

  colorMode(HSB, 360, 100, 100);

  int counter = 0;

  //Initialize tubes with rainbow pattern over installation

  for (int i=0; i< numTubes; i++) {
    if (i % 3 == 0 && i != 0) {
      counter++; 
      println(counter + " , " + numTubes);
    }

    int hueValue = int(map(counter, 0, numTripods, 0, 360));

    println(hueValue);

    tubes[i] = new Tube(i, hueValue);
  }

  //drawRaster(); // drawRaster helps us with the LED mapping in ELM

  // Setup MQTT

  client = new MQTTClient(this);
  client.connect("mqtt://localhost", "processing");
  //client.subscribe("tripods/" + 0 + "/tube/" + 0 + "/side/" + 0);

  for (int i = 0; i < numTripods; i++) {
    for (int j = 0; j < 3; j++) {
      for (int k = 0; k < 2; k++) {
        //println(
        client.subscribe("tripods/" + i + "/tube/" + j + "/side/" + k);
      }
    }
  }

  spout = new Spout(this);

  Ani.init(this);
}

void draw() {

  background(0);

  for (int i=0; i<numTubes; i++) {
    tubes[i].update();
  }
  //pushMatrix();
  //pushStyle();



  //for (int i = 0; i<numTripods; i++) {
  //  for (int j = 0; j < tubeLength; j+= rectWidth) {
  //    for (int k = 0; k < 3; k++) {
  //      fill(map((i * tubeLength) + j, 0, totalLengthInstallation, 0, 100), 100, 100); 

  //      rect(k * (numLEDsPerTube * rectWidth) + (k * 20 + 20) + j, i * 21 + 21, rectWidth, rectHeight);
  //    }
  //  }
  //}

  //popStyle();
  //popMatrix();



  selectingSystem();

  showFrameRate();

  //drawRaster();

  spout.sendTexture();
}

void keyPressed() {

  int tubeNumber = currentSelectedTube + currentSelectedTripod * 3;


  //Selecting system for adding objects
  if (key == CODED) {
    if (keyCode == LEFT) {
      currentSelectedTube --;
    }
    if (keyCode == RIGHT) {
      currentSelectedTube ++;
    }
    if (keyCode == UP) {
      currentSelectedTripod --;
    }
    if (keyCode == DOWN) {
      currentSelectedTripod ++;
    }
  }

  if (key == '9') {
    for (int i=0; i<numTubes; i++) {
      tubes[i].isTouched(0);
      tubes[i].isTouched(1);
    }
  }

  if (key == '0') {
    for (int i=0; i<numTubes; i++) {
      tubes[i].isUnTouched(0);
      tubes[i].isUnTouched(1);
    }
  }

  if (key == '1') {
    tubes[tubeNumber].isTouched(0);
  }

  if (key == '2') {
    tubes[tubeNumber].isTouched(1);
  }
}

//Simulating the sensor input 0 - released

void keyReleased() {
  int tubeNumber = currentSelectedTube + currentSelectedTripod * 3;

  if (key == '1') {
    tubes[tubeNumber].isUnTouched(0);
  }

  if (key == '2') {
    tubes[tubeNumber].isUnTouched(1);
  }
}