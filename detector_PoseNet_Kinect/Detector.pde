class Detector {
  Timer timer;
  float x, y = -1;
  float easing = .05;
  JSONArray poses;

  Detector() {
    timer = new Timer(3);
  }

  void deteccion(JSONObject data) {
    if (data != null) {
      // Si hay personas, guardar
      poses = data.getJSONArray("poses");
      if (poses.size() >= 1) {
        for (int h = 0; h < poses.size(); h++) {
          // De todas las poses, guardar los keypoints
          JSONArray keypoints = poses.getJSONArray(h);
          JSONArray point = keypoints.getJSONArray(9);
          float px = point.getFloat(0) - x;
          float py = point.getFloat(1) - y;
          x += px* easing;
          y += py* easing;
          timer.guardarTiempo();
        }
      } else {
        if (timer.pasoElTiempo()) {
          x = -1;
          y = -1;
        }
      }
    }
    // Descomentar cuando se este calibrando o comprobando la detección
    ellipse(x * width, y * height, 15, 15);
  }

  float posX() {
    return x * width;
  }

  float posY() {
    return y * height;
  }
  ///////
}
