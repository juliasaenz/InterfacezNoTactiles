class Detector {
  OpenCV opencv;
  Timer timer;
  float x, y, px, py= -1;
  int tam = 20;
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
        text("no veo nada", 20, 20);
        px = -1;
        py = -1;
        x = -1;
        y = -1;
      }
    }
    _mostrarDeteccionTodo(manos);
    pushStyle();
    noStroke();
    fill(0, 0, 255);
    ellipse(x, y, tam, tam);
    popStyle();
  }

  private void _mostrarDeteccion(Rectangle[] manos) {
    //Muestra rectangulo con la mano detectada
    if (manos.length > 0) {
      noFill();
      strokeWeight(3);
      stroke(255, 0, 0);
      rect(manos[0].x, manos[0].y, manos[0].width, manos[0].height);
    }
  }

  private void _mostrarDeteccionTodo(Rectangle[] manos) {
    //Muestra rectangulo con la mano detectada
    for (int i=0; i < manos.length; i++) {
      noFill();
      strokeWeight(3);
      stroke(255, 0, 0);
      rect(manos[i].x, manos[i].y, manos[i].width, manos[i].height);
    }
  }



  // fin de clase
}
