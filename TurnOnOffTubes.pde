//void changeStateTubes(int tubeNumber, String request) { 

//  int tripodNumber = tubeNumber / 3;
//  int tubeModulus = tubeNumber % 3;

//  if (request.equals("ON") == true) {
//    tubes[tubeNumber].setColorOn(0, 0);

//    for (int i = tripodNumber * 3; i < tripodNumber * 3 + 3; i++) {
//      if (tubeModulus == i - (tripodNumber * 3)) { // Prevent that the tube that needs to light immediate becomes delayed
//        continue;
//      }

//      tubes[i].setColorOn(0, 0.5);
//    }

//    for (int i = tripodNumber * 3 - 3; i < tripodNumber * 3; i++) {
//      if (i < 0 || i >= numTripods) {
//        continue;
//      }
//      tubes[i].setColorOn(2, 1.5);
//    }

//    for (int i = tripodNumber * 3 + 3; i < tripodNumber * 3 + 3; i++) {
//      if (i < 0 || i >= numTripods) {
//        continue;
//      }
//      tubes[i].setColorOn(1, 1.5);
//    }
//  }


//  if (request.equals("OFF") == true) {
//    tubes[tubeNumber].setColorOff(0, 0);
//  }
//}