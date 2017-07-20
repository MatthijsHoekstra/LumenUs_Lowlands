class TouchPulse {

  int tubeModulus;
  int tripodNumber;
  int touchLocation;

  int x = 0;

  int opacity = 0;

  PImage pulse;

  TouchPulse(int tubeModulus, int tripodNumber, int touchLocation) {

    this.tubeModulus = tubeModulus;
    this.tripodNumber = tripodNumber;

    this.touchLocation = touchLocation;

    Ani.to(this, 0.8, "x", tubeLength, Ani.CIRC_OUT, "onEnd:AnimateToBegin");

    println("TouchPulse added");

    Ani.to(this, 0.4, "opacity", 220, Ani.CIRC_OUT);
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
    
    image(pulse, 0, 0);

    popStyle();
    popMatrix();
  }

  void animateToEnd() {
    Ani.to(this, 1.5, 0.3, "x", tubeLength, Ani.CIRC_OUT, "onEnd:animateToBegin");
    
    tube[tripodNumber*4+tubeModulus].
  }

  void AnimateToBegin() {
    Ani.to(this, 2, 0.3, "x", 0, Ani.CIRC_OUT, "onEnd:animateToEnd");
  }
}