// Librerías
import oscP5.*;
import netP5.*;
// Objetos
OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {  
  size(300,300);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,1);
  // A dónde mando
  myRemoteLocation = new NetAddress("127.0.0.1",2);
}

void draw() {
  background(0);
  mandarMensaje(float(mouseX)/width,float(mouseY)/height);
  //println(float(mouseX)/width+" "+float(mouseY)/height);
}

void mandarMensaje(float x, float y) {
  // el tag le indica que vaya directo al método del mismo nombre
  OscMessage myMessage = new OscMessage("/posicionMano");
  // valores que se mandan
  myMessage.add(x);
  myMessage.add(y); 
  oscP5.send(myMessage, myRemoteLocation); 
}
