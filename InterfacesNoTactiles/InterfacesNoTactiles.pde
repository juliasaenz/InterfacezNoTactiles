// Librerías
import oscP5.*;
import netP5.*;
// Objetos
OscP5 oscP5;
NetAddress myRemoteLocation;
Boton botones[] = new Boton[4];
//
float x, y = 0;
String estado = "inicio";
Timer timer = new Timer(6000);

void setup() {
  size(400, 225);
  //size(1000,562);
  frameRate(25);
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 2);
  myRemoteLocation = new NetAddress("127.0.0.1", 1);
  // Manda el mensaje directo al método con el mismo nombre
  oscP5.plug(this, "posicionMano", "/posicionMano");

  inicializarBotones(botones);
}

void draw() {
  background(0, 0, 0);
  if (estado == "inicio") {
    for (int i= 0; i<4; i++) {
      //chequear que botón fue seleccionado
      if (botones[i].cualTag() != -1) {
        timer.guardarTiempo();
        botones[i].reseteoValores();
        estado = "opcion"+(i+1);
      }
      botones[i].dibujar(x, y);
    }
  } else {
    //opciones de estados
    if (estado.equals("opcion1")) {
      background(200, 0, 0);
    } else if (estado.equals("opcion2")) {
      background(0, 200, 0);
    } else if (estado.equals("opcion3")) {
      background(0, 0, 200);
    } else {
      background(0);
    }
    //volver al inicio cuando pase X tiempo
    if (timer.pasoElTiempo()) {
      estado = "inicio";
    }
  }
  
  //este es el "cursor" que probablemente dsp cambie
  ellipse(x, y, 20, 20);
}
