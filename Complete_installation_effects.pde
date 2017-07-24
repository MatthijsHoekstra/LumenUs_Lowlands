class PulseOverInstallation {

  int turnOnPositionAnimation = 0;
  int turnOffPositionAnimation = 0;

  boolean finished = false;

  boolean tubesToTurnOn[] = new boolean[numTubes];
  boolean tubesToTurnOff[] = new boolean[numTubes];

  int startTimeTimer;

  boolean firedRemovePulse = false;

  boolean firedOn = false;

  PulseOverInstallation(int startLocation) {
    Ani.to(this, 1.5, "turnOnPositionAnimation", numTripods - 1, Ani.SINE_OUT);

    Ani.to(this, 3, 2, "turnOffPositionAnimation", numTripods - 1, Ani.SINE_OUT);

    println("Added PulseOverInstallation");

    startTimeTimer = millis();
  }

  void update() {


    //println(currentBeginPositionAnimation);

    for (int i = 0; i < tubesToTurnOn.length; i++) {
      tubesToTurnOn[i] = false;
      tubesToTurnOff[i] = false;
    }

    int tubeNumberStartOn = turnOnPositionAnimation * 3;
    int tubeNumberStartOff = turnOffPositionAnimation * 3;

    println(tubeNumberStartOn + " , " + tubeNumberStartOff);


    if (firedOn == false) {
      for (int i = tubeNumberStartOn; i < tubeNumberStartOn + 3; i++) {
        tubesToTurnOn[i] = true;
        
      }
    }

    if (tubeNumberStartOn == 69 && firedOn != false) {
      firedOn = true;
    }

    for (int i = tubeNumberStartOff; i < tubeNumberStartOff + 3; i++) {
      if (millis() > startTimeTimer + 2000) { //This should always be equal to the delay of the second Ani animation    !!IMPORTANT
        tubesToTurnOff[i] = true;
      } else {
        break;
      }
    }
  }

  void finished() {
    finished = true;
  }
}