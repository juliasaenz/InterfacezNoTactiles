public void posicionMano(float x_, float y_) {
  //Recibe por osc la posición de la mano
  //Acomoda la posición de la mano a el tamaño de la pantalla de la interfaz
  x = x_*width;
  y = y_*height;
}

//////////////// BORRAR DE ACA /////////////////////////////////////
void mandarMensaje(float x, float y) {
  // el tag le indica que vaya directo al método del mismo nombre
  //OscMessage myMessage = new OscMessage("/posicionMano");
  // valores que se mandan
  //myMessage.add(x);
  //myMessage.add(y); 
  //oscP5.send(myMessage, myRemoteLocation);
}

void inicializarBotones(Boton[] botones) {
  // mala forma
  int x1 = (width/7)*2;
  int x2 = (width/7)*5;
  int y1 = (height/10)*3;
  int y2 = (height/10)*7;
  botones[0] = new Boton(1, x1, y1); 
  botones[1] = new Boton(2, x2, y1);
  botones[2] = new Boton(3, x1, y2);
  botones[3] = new Boton(4, x2, y2);
}
