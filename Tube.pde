/* The Lighteffect class is the mediator of the entire code
 lighteffect.update is the only function that is CONSTANTLY running
 .update checks the tubes that are active, decides what light-effect they should show and exectues the corrosponding functions
 */

//import toxi.util.events.*;

class Tube {
  private int tubeNumber;
  private int tubeModulus;
  private int tripodNumber;

  ArrayList<Block> blocks = new ArrayList<Block>();
  ArrayList<TouchPulse> touchpulses = new ArrayList<TouchPulse>();

  boolean effectSide0 = false;
  boolean effectSide1 = false;

  int hueValue;
  int saturationValue = 100;
  int brightnessValue = 0;

  int opacityRectHue = 255;

  int correctionEffectLeftToRight = 0;
  int correctionEffectRightToLeft = 0;

  Tube(int tubeNumber, int hueValue) {
    this.tubeNumber = tubeNumber; //0 - numTubes
    this.tubeModulus = tubeNumber % 3; // 0, 1, 2
    this.tripodNumber = tubeNumber / 3; //0 - numTubes / 3

    this.hueValue = hueValue;
  }

  //Event when tube is touched

  void isTouched(int touchLocation) {
    if (touchLocation == 0 && effectSide0 == false) {
      //blocks.add(new Block(tubeModulus, tripodNumber, 0));
      touchpulses.add(new TouchPulse(tubeModulus, tripodNumber, 0));

      effectSide0 = true;
    }

    if (touchLocation == 1 && effectSide1 == false) {
      //blocks.add(new Block(tubeModulus, tripodNumber, 1));
      touchpulses.add(new TouchPulse(tubeModulus, tripodNumber, 1));

      effectSide1 = true;
    }

    changeStateTubes(tubeNumber, "ON");
  }

  //Event when tube is released

  void isUnTouched(int touchLocation) {
    for (int i = 0; i < touchpulses.size(); i++) {
      TouchPulse touchpulse = touchpulses.get(i);

      if (touchpulse.touchLocation == touchLocation) {
        touchpulse.finished = true;
      }
    }
  }

  // Executed every frame, for updating continiously things
  void update() {

    pushStyle();

    pushMatrix();
    translate(this.tubeModulus * (numLEDsPerTube * rectWidth) + (this.tubeModulus * 20 + 20), this.tripodNumber * 21 + 21);

    fill(hueValue, saturationValue, brightnessValue, opacityRectHue);

    rect(0 + correctionEffectRightToLeft, 0, tubeLength - correctionEffectLeftToRight, rectHeight);

    popStyle();

    popMatrix();

    //Keep hue continiously

    if (hueValue > 320) {
      hueValue = 0;
    } else if (hueValue < 0) {
      hueValue = 360;
    }

    //Hide hue rectangle if the color is black

    if (brightnessValue == 0) {
      opacityRectHue = 0;
    } else if (brightnessValue > 0) {
      opacityRectHue = 255;
    }

    for (int i = 0; i < touchpulses.size(); i++) {
      TouchPulse touchpulse = touchpulses.get(i);

      touchpulse.display();

      if (touchpulse.finished) {
        if (touchpulse.touchLocation == 0) {
          effectSide0 = false;
        }
        if (touchpulse.touchLocation == 1) {
          effectSide1 = false;
        }

        touchpulses.remove(i);

        println("removed TouchPulse");
      }
    }
  }

  void changeHue() {
    int newHue = hueValue + 40;
    Ani.to(this, 1, "hueValue", newHue, Ani.QUAD_OUT);
  }

  //sort: 0 - complete tube lights up in one piece, 1 - lights up from left to right, 2 - right to left
  void setColorOff(int sort, float delay) {
    if (sort == 0) {
      brightnessValue = 100;
      correctionEffectRightToLeft = 0;
      correctionEffectLeftToRight = 0;

      Ani.to(this, 1, delay, "brightnessValue", 0, Ani.QUAD_OUT);
    } else if (sort == 1) {
      brightnessValue = 100;
      correctionEffectRightToLeft = 0;
      correctionEffectLeftToRight = tubeLength;

      Ani.to(this, 1, delay, "correctionEffectLeftToRight", 0, Ani.QUAD_OUT);
    } else if (sort == 2) {
      brightnessValue = 100;
      correctionEffectRightToLeft = tubeLength;
      correctionEffectLeftToRight = 0;

      Ani.to(this, 1, delay, "correctionEffectRightToLeft", 0, Ani.QUAD_OUT);
    }
  }


  void setColorOn(int sort, float delay) {
    if (sort == 0) {
      brightnessValue = 0;
      correctionEffectRightToLeft = 0;
      correctionEffectLeftToRight = 0;

      Ani.to(this, 1, delay, "brightnessValue", 100, Ani.QUAD_OUT);
    } else if (sort == 1) {
      brightnessValue = 100;
      correctionEffectRightToLeft = 0;
      correctionEffectLeftToRight = tubeLength;

      Ani.to(this, 1, delay, "correctionEffectLeftToRight", 0, Ani.QUAD_OUT);
    } else if (sort == 2) {
      brightnessValue = 100;
      correctionEffectRightToLeft = tubeLength;
      correctionEffectLeftToRight = 0;

      Ani.to(this, 1, delay, "correctionEffectRightToLeft", 0, Ani.QUAD_OUT);
    }
  }
}