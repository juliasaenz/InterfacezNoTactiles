class Detector {
  OpenCV opencv;
  Timer timer;
  float x, y, px, py= -1;
  int tam = 5;
  float lerping = .8;

  Detector(OpenCV opencv_, String ruta) {
    opencv = opencv_;
    opencv.loadCascade(ruta, true);
    timer = new Timer(5);
  }

  void medicion(PImage feed) {
    opencv.loadImage(feed);  
    // ScaleFactor, MinNeighbour, flags, minSize, maxSize
    Rectangle [] manos = opencv.detect(1.05, 50, 1, 30, 200);
    if (manos.length > 0) {
      px = x;
      py = y;
      if ( dist(px, py, x, y) < 20) {
        x = lerp(px, manos[0].x + manos[0].width/2, lerping);
        y = lerp(py, manos[0].y + manos[0].height/2 + 20, lerping);
      }
      timer.guardarTiempo();
    } else {
      if (timer.pasoElTiempo()) {
        px = -1;
        py = -1;
        x = -1;
        y = -1;
      }
    }
    // Descomentar cuando se este calibrando o comprobando la detección 
    /*_mostrarAreaDeteccion(manos);
    _mostrarPuntoDeteccion(x,y); */
  }
  
  private void _mostrarAreaDeteccion(Rectangle[] manos) {
    //Muestra rectangulo con la mano detectada
    for (int i=0; i < manos.length; i++) {
      noFill();
      strokeWeight(3);
      stroke(0, 255, 0);
      rect(manos[i].x, manos[i].y, manos[i].width, manos[i].height);
    }
  }
  
  private void _mostrarPuntoDeteccion(float x, float y){
    //Ver el punto
    pushStyle();
    noStroke();
    fill(255,0, 0);
    ellipse(x, y, tam, tam);
    popStyle();
  }


  // fin de clase
}
