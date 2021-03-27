import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

int tam = 20;
float x, y;

void setup() {
  size(640, 480);

  oscP5 = new OscP5(this, 1);
  myRemoteLocation = new NetAddress("127.0.0.1", 3);
}

void draw() {
  background(0);

  pushStyle();
  noStroke();
  fill(0, 0, 255);
  ellipse(x, y, tam, tam);
  popStyle();

  mandarMensaje(x/width, y/height);
}

void mandarMensaje(float x, float y) {
  // el tag le indica que vaya directo al método del mismo nombre
  OscMessage myMessage = new OscMessage("/posicionMano");
  // valores que se mandan
  myMessage.add(x);
  myMessage.add(y); 
  oscP5.send(myMessage, myRemoteLocation);
}


//==== Funcion de recibir data de TSPS ====
void oscEvent(OscMessage theOscMessage) {

  String addr = theOscMessage.addrPattern();
  
  float calibrarValores = 50;

  if ( addr.equals("/TSPS/scene") ) { 
    x = map(theOscMessage.get(3).floatValue(), -calibrarValores, calibrarValores, 0, width);
    y = map(theOscMessage.get(4).floatValue(), -calibrarValores, calibrarValores, 0, height);
    println(x, y);
  }
}
