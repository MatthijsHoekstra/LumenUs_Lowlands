void registerTouch(int tubeNumber, int state) {
  int tripodNumber = tubeNumber / 3;

  int IDController = -1;

  switch(state) {
  case TOUCHED:
    println("registered TOUCH");

    boolean insideController = false;

    for (int i = 0; i < controllerstouch.size(); i ++) {
      ControllerTouch controllers = controllerstouch.get(i);

      if (controllers.tripodsIncluded[tripodNumber] == true) {
        IDController = i;
        insideController = true;

        controllers.addTripod(tripodNumber);

        break;
      }
    }

    if (insideController == false) {
      controllerstouch.add(new ControllerTouch(tripodNumber));
    }

    updateTubesWithinArea(TOUCHED);

    break;

  case UNTOUCHED: 
    break;
  }
}

class ControllerTouch {
  boolean tripodsIncluded[] = new boolean[numTripods];

  int minTripodNumber;
  int maxTripodNumber;

  boolean firstRun = true;

  int positionPulse = 0;

  int hueValue;

  boolean animationToEnd = true;
  boolean animationToBegin = false;

  ControllerTouch(int tripodNumber) {
    tripodsIncluded[constrainThis(tripodNumber, TRIPODNUMBER)] = true;

    tripodsIncluded[constrainThis(tripodNumber - 1, TRIPODNUMBER)] = true;
    tripodsIncluded[constrainThis(tripodNumber + 1, TRIPODNUMBER)] = true;

    println("new ControllerTouch created" + tripodNumber);

    //Controller for simustainysly (WTF am i writing) pulse

    //Ani.to(this, 2, "positionPulse", tubeLength, Ani.QUAD_OUT, "onEnd:animateToBegin");
  }

  void addTripod(int tripodNumber) {
    if (tripodNumber == minTripodNumber) {
      tripodsIncluded[constrainThis(minTripodNumber - 1, TRIPODNUMBER)] = true;

      int tubeNumberStart = constrainThis(tripodNumber - 1, TRIPODNUMBER) * 3;

      for (int i = 0; i < 3; i ++) {
        tubes[tubeNumberStart + i].setHue(hueValue, 0);
      }
    }

    if (tripodNumber == maxTripodNumber) {
      tripodsIncluded[constrainThis(maxTripodNumber + 1, TRIPODNUMBER)] = true;

      int tubeNumberStart = constrainThis(tripodNumber + 1, TRIPODNUMBER) * 3;

      for (int i = 0; i < 3; i ++) {
        tubes[tubeNumberStart + i].setHue(hueValue, 0);
      }
    }
  }

  void updateSize() {
    int count = 0;
    boolean firstTrue = false;

    for (int i = 0; i < tripodsIncluded.length; i ++) {
      if (tripodsIncluded[i] && firstTrue == false) {
        minTripodNumber = i;

        if (minTripodNumber < 0) {
          minTripodNumber = 0;
        }

        firstTrue = true;
      }

      if (tripodsIncluded[i]) {
        count++;
      }
    }

    maxTripodNumber = minTripodNumber + count - 1;

    if (maxTripodNumber > numTripods - 1) {
      maxTripodNumber = numTripods - 1;
    }

    if (positionPulse == tubeLength && animationToBegin) {
      animateToBegin();

      animationToBegin = false;
      animationToEnd = true;
    } else if (positionPulse == 0 && animationToEnd) {
      animateToEnd();

      animationToBegin = true;
      animationToEnd = false;
    }
  }

  boolean finished() {
    boolean allFalse = true;

    for (int i = 0; i < tripodsIncluded.length; i++) {
      if (tripodsIncluded[i] == true) {
        allFalse = false;
      }
    }

    if (allFalse) {
      for (int i = minTripodNumber; i <= maxTripodNumber; i++) {
        int startTubeNumber = i * 3;

        for (int j = startTubeNumber; j < startTubeNumber + 3; j++) {
          tubes[j].setColorOff(0, 0);
          tubes[j].partOfArea = false;

          //println("set colorOff");
        }
      }

      println("removed TouchController");

      return true;
    } else {
      return false;
    }
  }

  void animateToEnd() {
    Ani.to(this, 2, 0.3, "positionPulse", tubeLength, Ani.QUAD_OUT);
    println("end animation");
  }

  void animateToBegin() {
    Ani.to(this, 1, 0.3, "positionPulse", 0, Ani.QUAD_OUT);
    println("beginAnimation");

    if (addHueValue() == -1) {
      for (int i = minTripodNumber; i <= maxTripodNumber; i++) {
        int tubeNumberStart = i * 3;

        for (int j = 0; j < 3; j++) {
          tubes[tubeNumberStart + j].hueValue = 0;
        }
      }
    } else {
      setHueValue(hueValue);
    }
  }

  void setHueValue(int value) {    
    println(value);

    for (int i = minTripodNumber; i <= maxTripodNumber; i++) {
      int tubeNumberStart = i * 3;

      for (int j = 0; j < 3; j++) {
        if (!firstRun) {
          tubes[tubeNumberStart + j].setHue(value, 0);
        } else if (firstRun) {
          tubes[tubeNumberStart + j].setHue(value, 3);
        }
      }
    }
  }

  int addHueValue() {
    hueValue += 30;

    if (hueValue > 320) {
      hueValue = 0;
      return -1;
    } else {
      return 0;
    }
  }
}

void updateTubesWithinArea(int stateTouch) {  
  if (stateTouch == TOUCHED) {
    for (int i = 0; i < controllerstouch.size(); i ++) {
      ControllerTouch controllers = controllerstouch.get(i);

      controllers.updateSize(); //Forcing to calculate the size of the 

      int counterFirstRun = 0;

      for (int j = 0; j < controllers.tripodsIncluded.length; j++) {
        if (controllers.tripodsIncluded[j] == true) {
          boolean delayAnimationOutside = false;
          boolean delayAnimationInside = false;
          int tubeNumberStart = j * 3;

          if (controllers.firstRun == true) {
            //println("delayAnimation" + controllers.maxTripodNumber + " , " + j);
            if (controllers.minTripodNumber == j) {
              delayAnimationOutside = true;
              counterFirstRun ++;
            }
            if (controllers.maxTripodNumber == j) {
              delayAnimationOutside = true;
              counterFirstRun ++;
            }
            if (controllers.minTripodNumber + 1 == j) {
              delayAnimationInside = true; 
              counterFirstRun ++;
            }
          }

          for (int k = 0; k < 3; k++) {
            if (tubes[tubeNumberStart + k].partOfArea == false) {
              tubes[tubeNumberStart + k].partOfArea = true;

              if (delayAnimationInside == true) {
                tubes[tubeNumberStart + k].setColorOn(0, 2);
              } else if (delayAnimationOutside == true) {
                tubes[tubeNumberStart + k].setColorOn(0, 2); //Animation of the outside tubes when an area is first created, change the delay to create fade effect to the outside
              } else {
                tubes[tubeNumberStart + k].setColorOn(0, 0);
              }
              //println("set colorOn");
            }
          }
        }
      }

      if (counterFirstRun == 3) {
        int hueValues[] = new int[(controllers.maxTripodNumber - controllers.minTripodNumber + 1) * 3];
        int counterArray = 0;

        for (int j = controllers.minTripodNumber; j <= controllers.maxTripodNumber; j++) {
          int tubeNumberToStart = j * 3;

          for (int k = 0; k < 3; k++) {
            hueValues[counterArray] = tubes[tubeNumberToStart + k].hueValue;
            counterArray ++;
          }
        }

        int HueValuesTotal = 0;
        for (int j = 0; j < hueValues.length; j++) {
          HueValuesTotal += hueValues[j];
        }
        int averageHueValue = HueValuesTotal / hueValues.length;

        controllers.setHueValue(averageHueValue);

        controllers.hueValue = averageHueValue;

        controllers.firstRun = false;
      }
    }
  }
}