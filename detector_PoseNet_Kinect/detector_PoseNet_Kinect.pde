//Librerías
import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import com.runwayml.*;
import oscP5.*;
import netP5.*;

//Objetos
RunwayHTTP runway;
Kinect kinect;
Timer timer;
OscP5 oscP5;
NetAddress myRemoteLocation;
Detector detector = new Detector();

// La Data detectada de Runway
JSONObject data;

float espera = 2.10;
float x, y;  

void setup() {
  size(600, 400);
  OscProperties myProperties = new OscProperties();
  myProperties.setDatagramSize(10000); 
  myProperties.setRemoteAddress("127.0.0.1", 1000);
  oscP5 = new OscP5(this, myProperties);
  myRemoteLocation = new NetAddress("127.0.0.1", 4000);
  
  runway = new RunwayHTTP(this);
  runway.setAutoUpdate(false);

  timer = new Timer(espera);
  timer.guardarTiempo();

  kinect = new Kinect(this);
  kinect.initVideo();
  kinect.enableMirror(true);
}

void draw() {
  background(0);
  if (timer.pasoElTiempo()) {
    sendFrameToRunway();
    timer.guardarTiempo();
  }


  kinect.enableIR(true);
  ///image(kinect.getVideoImage(), 0, 0);
  detector.deteccion(data);
  mandarMensaje(detector.posX()/width, detector.posY()/height);
}

void mandarMensaje(float x, float y) {
  // el tag le indica que vaya directo al método del mismo nombre
  OscMessage myMessage = new OscMessage("/posicionMano");
  // valores que se mandan
  myMessage.add(x);
  myMessage.add(y); 
  oscP5.send(myMessage, myRemoteLocation);
}

void sendFrameToRunway() {
  // Mandar imagen a Runway
  PImage image = kinect.getVideoImage();
  runway.query(image);
}

void runwayDataEvent(JSONObject runwayData) {
  // Recibir los datos de Runway 
  data = runwayData;
}
