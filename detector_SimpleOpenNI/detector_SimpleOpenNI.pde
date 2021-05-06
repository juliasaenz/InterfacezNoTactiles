//==== Importacion Librerias ====
import netP5.*;
import oscP5.*;
import SimpleOpenNI.*;

//==== Variables Librerias ====
OscP5 oscP5;
NetAddress myRemoteLocation;
SimpleOpenNI kinect;

Detector detector;

void setup() {
  size(640, 480);

  oscP5 = new OscP5(this, 1000);
  myRemoteLocation = new NetAddress("127.0.0.1", 3);

  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser();

  detector = new Detector();
}

void draw() {
  kinect.update();
  image(kinect.depthImage(), 0, 0);

  IntVector userList = new IntVector();
  kinect.getUsers(userList);

  if (userList.size() > 0) {
    int userId = userList.get(0);
    if ( kinect.isTrackingSkeleton(userId)) {
      detector.medicion(userId);
    }
  }

  mandarMensaje(detector.x/width, detector.y/height);
}

void mandarMensaje(float x, float y) {
  // el tag le indica que vaya directo al método del mismo nombre
  OscMessage myMessage = new OscMessage("/posicionMano");
  // valores que se mandan
  myMessage.add(x);
  myMessage.add(y); 
  oscP5.send(myMessage, myRemoteLocation);
}

//==== Funciones Estado de la captura ====

void onNewUser(SimpleOpenNI kinect, int userID) {
  println("Start tracking");
  kinect.startTrackingSkeleton(userID);
}

void onLostUser(SimpleOpenNI curContext, int userId) {
  println("onLostUser - userId: " + userId);
}
