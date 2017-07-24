void changeHue(int tubeNumber) {

  int tripodNumber = tubeNumber / 3;
  //Change the color of the complete tripod

  for (int i = tripodNumber*3; i < tripodNumber*3 + 3; i++) {
    tubes[i].changeHue();
  }
  
  //println("changeHue , " + tripodNumber + " , " + tubeNumber);
}