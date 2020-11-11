//  LIBRERIAS
import gab.opencv.*;
import java.awt.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

/// OBJETOS
OpenCV opencv;
OpenCV opencv2;
Kinect kinect;
Detector detector;


/// VARIABLES DE PRUEBA, SACAR DSP
boolean cual = true;

void setup() {
  size(640, 480);

  /// OBJETOS
  opencv = new OpenCV(this, 640, 480); 
  opencv2 = new OpenCV(this, 640, 480); 
  kinect = new Kinect(this);
  detector = new Detector(opencv, opencv2, kinect);
}

void draw () {
  background(0);
  //detector.mostrar_camaras(cual);
  //detector._rectangulos_todos();
  detector.medicion();
}

void keyPressed() {
  cual = !cual;
}
