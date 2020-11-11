class Detector {
  OpenCV opencv;
  OpenCV opencv2;
  Kinect kinect;
  /// Variables Kinect
  float deg; // angulo camara
  int minDepth = 0; // min pixel que ve
  int maxDepth = 700; // max pixel que ve
  PImage depthImg; 
  /// Variables OpenCV
  /// ------------ Actualizar el path
  /// ------------ Buscar el archivo en el buscador y copiar el path 
  String path = "C:/Users/Julia/Documents/GitHub/InterfacezNoTactiles/Processig openCV/INT_OpenCv/xml/Hand.Cascade.1.xml";
  /////
  float time;
  float x = width/2;
  float y = height/2;
  float lerping = 0.7;
  ///
  float tx = -10;
  float ty = -10;
  float ttam = 0;

  Detector(OpenCV opencv_, OpenCV opencv2_, Kinect kinect_) {
    /// OpenCV
    opencv = opencv_;
    opencv.loadCascade(path, true);
    opencv2 = opencv2_;
    opencv2.loadCascade(path, true);
    /// Kinect
    kinect = kinect_;
    kinect.initDepth();
    deg = kinect.getTilt();
    depthImg = new PImage(kinect.width, kinect.height);
  }

  void medicion() {
    kinect.enableIR(true);
    kinect.enableMirror(true);
    opencv.loadImage(kinect.getVideoImage());
    _depthimg();
    opencv2.loadImage(depthImg);
    //cursor_mano();
    encontrar_mano();
    println("tam: ",ttam);
  }

  void mostrar_camaras( boolean cual) {
    if (cual) {
      image(kinect.getVideoImage(), 0, 0 );
    } else {
      depthImg.updatePixels();
      image(depthImg, 0, 0);
    }

    // ----Descomentar si se quiere revisar cómo detecta cada feed
    //_detectar_manos(opencv, color(255, 0, 0));
    //_detectar_manos(opencv2, color(0, 0, 255));
  }

  boolean hayMano(float cant1, float cant2) {
    if (cant1 > 1 && cant2 > 1) {
      time = 0;
      return true;
    } else {
      time += 0.1;
      println(time);
      if (time >= 3) {
        return false;
      }
    }
    return true;
  }

  void encontrar_mano() {
    // Compara la detección de los dos feeds y se queda con el rectangulo que aparezca en ambas detecciones
    Rectangle[] hands = opencv.detect();
    Rectangle[] hands2 = opencv2.detect();
    for (int i =0; i<hands.length; i++) {
      for (int j=0; j<hands2.length; j++) {
        if (dist(hands[i].x, hands[i].y, hands2[j].x, hands2[j].y)<10) {
          tx = hands[i].x;
          ty = hands[i].y;
          ttam = hands[i].width;
        }
      }
    }
    if (hayMano(hands.length, hands2.length)) {
      _dibujar_rectangulo(color(0, 255, 0), tx, ty, ttam);
    } 
    cursor_mano(hands, hands2);
  }

  void cursor_mano(Rectangle[] hands, Rectangle[] hands2) { 
    /// Dibuja un circulo en el medio de la mano y suaviza su movimiento
    if (hayMano(hands.length, hands2.length)) {
      float dx = (tx+tx+ttam)/2;
      float dy = (ty+ty+ttam)/2;
      x = lerp(dx, x, lerping);
      y = lerp(dy, y, lerping);
      noStroke();  
      fill(255, 0, 0);
      ellipse(x, y, 30, 30);
    } else if (!hayMano(hands.length, hands2.length) && ttam > 150) {
      textSize(48);
      textAlign(CENTER);
      fill(255);
      text("MUY CERCA", width/2, height/2);
    } else if (!hayMano(hands.length, hands2.length) && ttam < 100) {
      textSize(48);
      textAlign(CENTER);
      fill(255);
      text("MUY LEJOS", width/2, height/2);
    }
  }

  void _detectar_manos(OpenCV feed, color colorcito) {
    /// Visualizar todas las manos que ve segun el feed y la cascada de haar
    noFill();
    strokeWeight(3);
    // deteccion
    pushStyle();
    stroke(colorcito);
    Rectangle[] hands = feed.detect();

    for (int i = 0; i < hands.length; i++) {
      rect(hands[i].x, hands[i].y, hands[i].width, hands[i].height);
    }
    popStyle();
  }

  void _dibujar_rectangulo(color c, float x, float y, float tam) {
    noFill();
    strokeWeight(3);
    stroke(c);
    rect(x, y, tam, tam);
  }

  void _depthimg() {
    /// Arma la depth image
    int[] rawDepth = kinect.getRawDepth();
    for (int i=0; i < rawDepth.length; i++) {
      if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
        depthImg.pixels[i] = color(255);
      } else {
        depthImg.pixels[i] = color(0);
      }
    }
  }


  /// fin clase
}
