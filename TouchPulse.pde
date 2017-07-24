class TouchPulse {

  int tubeModulus;
  int tripodNumber;
  int touchLocation;
  
  int tubeNumber;

  int x = 0;

  int opacity = 0;

  PImage pulse;
  
  boolean finished = false;

  TouchPulse(int tubeModulus, int tripodNumber, int touchLocation) {

    this.tubeModulus = tubeModulus;
    this.tripodNumber = tripodNumber;
    
    tubeNumber = this.tripodNumber * 3 + tubeModulus;

    this.touchLocation = touchLocation;

    Ani.to(this, 0.8, "x", tubeLength, Ani.QUAD_OUT, "onEnd:animateToBegin");

    println("TouchPulse added");

    Ani.to(this, 0.4, "opacity", 255, Ani.QUAD_OUT);
  }


  void display() {
    pushMatrix();
    translate(this.tubeModulus * (numLEDsPerTube * rectWidth) + (this.tubeModulus * 20 + 20), this.tripodNumber * 21 + 21);

    pushStyle();

    fill(360, 0, 100, opacity);

    //if (this.touchLocation == 0) {
    rect(0, 0, x, rectHeight);
    //}

    //if (this.touchLocation == 1) {
    //  rect(tubeLength/2, 0, tubeLength/2, rectHeight);
    //}


    popStyle();
    popMatrix();
  }

  void animateToEnd() {
    Ani.to(this, 1.2, 0.3, "x", tubeLength, Ani.QUAD_OUT, "onEnd:animateToBegin");
  }

  void animateToBegin() {
    Ani.to(this, 2, 0.3, "x", 0, Ani.QUAD_OUT, "onEnd:animateToEnd");

    changeHue(tubeNumber);
  }
  
  void fadeOut(){
    Ani.to(this, 0.5, "opacity", 0, Ani.QUAD_OUT, "onEnd:finished");
  }
  
  void finished(){
    finished = true;
  }
}