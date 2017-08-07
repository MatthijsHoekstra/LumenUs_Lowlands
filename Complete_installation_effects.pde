void updateInstallationEffects() {
  for (int i=0; i<pulsesoverinstallation.size(); i++) {
    PulseOverInstallation pulseoverinstallation = pulsesoverinstallation.get(i);

    pulseoverinstallation.update();

    for (int j = 0; j < pulseoverinstallation.tubesToTurnOn.length; j++) {
      if (pulseoverinstallation.tubesToTurnOn[j] && tubes[j].partOfArea == false) {       
        tubes[j].setColorOn(0, 0);
      }
    }

    for (int j = 0; j < pulseoverinstallation.tubesToTurnOff.length; j++) {
      if (pulseoverinstallation.tubesToTurnOff[j] && tubes[j].partOfArea == false) {       
        tubes[j].setColorOff(0, 0);
      }
    }

    if (pulseoverinstallation.finished()) {
      pulsesoverinstallation.remove(i);

      println("Pulse Over Installation Removed");
    }
  }
}


class PulseOverInstallation {

  int turnOnPositionAnimation = 0;
  int turnOffPositionAnimation = 0;

  boolean finished = false;

  boolean tubesToTurnOn[] = new boolean[numTubes];
  boolean tubesToTurnOff[] = new boolean[numTubes];

  int startTimeTimer;

  boolean firedRemovePulse = false;

  boolean firedOn = false;

  boolean tripodsFiredOn[] = new boolean[numTripods];
  boolean tripodsFiredOff[] = new boolean[numTripods];

  int startLocation;

  //---------------------------------Tweakable values

  float durationPulse = 0.75; 

  int delayOff = 500;

  //-------------------------------------------------

  PulseOverInstallation(int startLocation) {
    this.startLocation = startLocation;

    if (startLocation == 0) {
      Ani.to(this, 2, "turnOnPositionAnimation", numTripods - 1, Ani.SINE_OUT);
      Ani.to(this, 2.2, 0.4, "turnOffPositionAnimation", numTripods - 1, Ani.SINE_OUT);
    }

    if (startLocation == 1) {
      turnOnPositionAnimation = numTripods - 1;
      turnOffPositionAnimation = numTripods - 1;

      Ani.to(this, 2, "turnOnPositionAnimation", 0, Ani.SINE_OUT);
      Ani.to(this, 2.2, 0.4, "turnOffPositionAnimation", 0, Ani.SINE_OUT);
    }

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

    if (tripodsFiredOn[tubeNumberStartOn / 3] == false) {
      tubesToTurnOn[tubeNumberStartOn] = true;
      tubesToTurnOn[tubeNumberStartOn + 1] = true;
      tubesToTurnOn[tubeNumberStartOn + 2] = true;

      tripodsFiredOn[turnOnPositionAnimation] = true;

      //println(tubeNumberStartOn + " , " + tubeNumberStartOff);
    }

    if (tripodsFiredOff[tubeNumberStartOff / 3] == false && millis() >= startTimeTimer + 400) {
      tubesToTurnOff[tubeNumberStartOff] = true;
      tubesToTurnOff[tubeNumberStartOff + 1] = true;
      tubesToTurnOff[tubeNumberStartOff + 2] = true;

      tripodsFiredOff[turnOffPositionAnimation] = true;

      //println(turnOnPositionAnimation + " , " + turnOffPositionAnimation);
    }
  }

  boolean finished() {
    if (this.startLocation == 0 && turnOnPositionAnimation * 3 == 69 && turnOffPositionAnimation * 3 == 69) {
      return true;
    } else if (this.startLocation == 1 && turnOnPositionAnimation * 3 == 0 && turnOffPositionAnimation * 3 == 0) {
      return true;
    } else {
      return false;
    }
  }
}