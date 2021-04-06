class Detector {
  
  float x, y;
  int tam = 20;

  float easing = .06; //Variable para equilibrar el ruido

  Detector() {
  }

  void medicion(int userId) {

    //Mano Derecha
    PVector rightHand = new PVector();
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
    PVector convertedRightHand = new PVector();
    kinect.convertRealWorldToProjective(rightHand, convertedRightHand);
    
    //Reduccion de ruido
    float targetX = convertedRightHand.x;
    float dx = targetX - x;
    x += dx * easing;

    float targetY = convertedRightHand.y;
    float dy = targetY - y;
    y += dy * easing;
    
    //Circulo de referencia
    pushStyle();
    noStroke();
    fill(0, 0, 255);
    ellipse(x, y, tam, tam);
    popStyle();
  }
}
