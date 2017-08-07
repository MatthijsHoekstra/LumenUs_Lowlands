import mqtt.*;

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

ArrayList<PulseOverInstallation> pulsesoverinstallation = new ArrayList<PulseOverInstallation>();

ArrayList<ControllerTouch> controllerstouch = new ArrayList<ControllerTouch>();

//------------------------------ Static values ------------------------------------

static final int LEFT_TO_RIGHT = 0;
static final int RIGHT_TO_LEFT = 1;

static final int TOUCHED = 0;
static final int UNTOUCHED = 1;

static final int TUBENUMBER = 0;
static final int TRIPODNUMBER = 1;

//---------------------------------------------------------------------------------

void setup() {
  size(1600, 880, OPENGL);
  frameRate(120);
  background(0);
  noStroke();
  noSmooth();

  colorMode(HSB, 360, 100, 100);

  //Initialize tubes with rainbow pattern over installation

  int counter = 0;

  for (int i=0; i< numTubes; i++) {
    if (i % 3 == 0 && i != 0) {
      counter++;
    }

    int hueValue = int(map(counter, 0, numTripods, 0, 320));

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

  updateInstallationEffects();

  for (int i=0; i<numTubes; i++) {
    tubes[i].update();
  }

  for (int i = 0; i < controllerstouch.size(); i ++) {
    ControllerTouch controllers = controllerstouch.get(i);

    controllers.updateSize();

    boolean areaTouched = false;

    for (int j = controllers.minTripodNumber; j <= controllers.maxTripodNumber; j++) {

      int tubeNumberStart = j * 3;
      
      for (int k = 0; k < 3; k++) {

        //Set the position of the controllers pulse to the tubes pulses itself

        tubes[tubeNumberStart + k].setPulsePosition(controllers.positionPulse);

        //Check if any of the tubes in the area are touched

        if (tubes[tubeNumberStart + k].pulseRunning == true) {
          areaTouched = true;
        }
      }
    }

    if (areaTouched == false) {
      for (int j = 0; j < controllers.tripodsIncluded.length; j++) {
        controllers.tripodsIncluded[j] = false;
      }
    }

    if (controllers.finished()) {
      controllerstouch.remove(i);
    }
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

  if (key == 'w') {
    for (int i=0; i<numTubes; i++) {
      tubes[i].setColorOn(0, 0);
    }
  }
  if (key == 'q') {
    for (int i=0; i<numTubes; i++) {
      tubes[i].setColorOff(0, 0);
    }
  }
  if (key == 'e') {
    pulsesoverinstallation.add(new PulseOverInstallation(LEFT_TO_RIGHT));
  }

  if (key == 'f') {
    pulsesoverinstallation.add(new PulseOverInstallation(RIGHT_TO_LEFT));
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