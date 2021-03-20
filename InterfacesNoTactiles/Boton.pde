class Boton {
  int tag;
  float x, y;
  float unidadX = (width/7)*2;
  float unidadY = height/5;
  int elegido = -1;
  boolean enZona, prevEnZona = false;
  //timer
  Timer timer = new Timer(4000);

  Boton(int tag_, float x_, float y_) {
    tag = tag_;
    x = x_;
    y = y_;
  }

  void dibujar(float posX, float posY) {
    prevEnZona = enZona;
    rectMode(CENTER);  
    pushStyle();
    if (posX > x-unidadX/2 && posX < x+unidadX/2 && posY > y-unidadY/2 && posY < y+unidadY/2) {
      enZona = true;
      // guardar tiempo cuando entre a una zona
      if (!prevEnZona && enZona) {
        println("entre en un area");
        timer.guardarTiempo();
      }
      if (timer.pasoElTiempo()) {
        elegido = tag;
      }
      fill(255, 0, 0);
    } else {
      fill(255, 255, 255);
      elegido = -1;
      enZona = false;
    }
    // todas estas cosas despues se van a ir
    rect(x, y, unidadX, unidadY);
    fill(0, 0, 0);
    textSize(width/20);
    text(tag, x, y);
    popStyle();
  }

  int cualTag() {
    return elegido;
  }

  void reseteoValores() {
    elegido = -1;
    enZona = false;
    prevEnZona = false;
  }


  ///
}
