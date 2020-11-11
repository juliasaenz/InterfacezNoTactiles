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
  String path = "C:/Users/Julia/Documents/xml/Hand.Cascade.1.xml";
  /////
  float x3 = width/2;
  float y3 = height/2;
  float tam3 = 0;
  float time;
  float x = width/2;
  float y = height/2;
  float lerping = 0.5;
  ///// estas despues se tienen que ir
  float x1 = width/2;
  float y1 = height/2;
  float tam1 = 0;
  float x2 = width/2;
  float y2 = height/2;
  float tam2 = 0;

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
    opencv.loadImage(kinect.getVideoImage());
    _depthimg();
    opencv2.loadImage(depthImg);
    cursor_mano();
  }

  void mostrar_camaras( boolean cual) {
    if (cual) {
      kinect.enableIR(true);
      image(kinect.getVideoImage(), 0, 0 );
      //_detectar_manos(opencv, color(255, 0, 0));
    } else {
      depthImg.updatePixels();
      image(depthImg, 0, 0);
      //_detectar_manos(opencv2, color(255));
    }
  }

  boolean hayMano(float cant1, float cant2) {
    if (cant1 > 1 || cant2 > 1) {
      time = 0;
      return true;
    } else {
      time += 0.1;
      println(time);
      if (time >= 2) {
        return false;
      }
    }
    return true;
  }
  void cursor_mano() {
    Rectangle[] hands = opencv.detect();
    if (hands.length > 1) {
      if (hands[0].width > 100) {
        x3 = hands[0].x;
        y3 = hands[0].y;
        tam3 = hands[0].width;
      }
    }
    Rectangle[] hands2 = opencv2.detect();
    if (hands2.length > 1) {
      if (hands2[0].width > 100) {
        x3 = hands2[0].x;
        y3 = hands2[0].y;
        tam3 = hands2[0].width;
      }
    }
    if (hayMano(hands.length, hands2.length)) {
      float dx = (x3+x3+tam3)/2;
      float dy = (y3+y3+tam3)/2;
      x = lerp(dx, x, lerping);
      y = lerp(dy, y, lerping);
      noStroke();  
      fill(255, 0, 0);
      ellipse(x, y, 30, 30);
    }
  }

  void _rectangulos_todos() {
    // Seguimiento de mano IR
    Rectangle[] hands = opencv.detect();
    if (hands.length > 1) {
      if (hands[0].width > 100) {
        x1 = hands[0].x;
        y1 = hands[0].y;
        tam1 = hands[0].width;
        x3 = hands[0].x;
        y3 = hands[0].y;
        tam3 = hands[0].width;
      }
    }

    // Seguimiento de mano DepthImage
    Rectangle[] hands2 = opencv2.detect();
    if (hands2.length > 1) {
      if (hands2[0].width > 80) {
        x2 = hands2[0].x;
        y2 = hands2[0].y;
        tam2 = hands2[0].width;
        x3 = hands2[0].x;
        y3 = hands2[0].y;
        tam3 = hands2[0].width;
      }
    }

    //dibujar
    if (hayMano(hands.length, hands2.length)) {
      _dibujar_rectangulo(color(0, 255, 0), x3, y3, tam3);
    }
  }

  void _dibujar_rectangulo(color c, float x, float y, float tam) {
    noFill();
    strokeWeight(3);
    stroke(c);
    rect(x, y, tam, tam);
  }

  void _detectar_manos(OpenCV feed, color colorcito) {
    /// ESTE ES DE PRUEBA, DSP BORRAR
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
