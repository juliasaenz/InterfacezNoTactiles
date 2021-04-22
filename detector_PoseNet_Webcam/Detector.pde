class Detector {
  float x, y = -1;
  float easing = .05;
  String parte = "rightWrist";
  Timer timer;

  Detector() {
    timer = new Timer(2);
  }

  void detectar(Pose[] poses, int nPoses) {
    if (nPoses > 0) {
      HashMap<String, Keypoint> keypoints;
      try {
        keypoints = poses[0].keypoints;
      }
      catch(Exception e) {
        return;//meh
      }
      if (!keypoints.containsKey(parte)) {
        return;
      }
      if (!keypoints.containsKey(parte)) {
        return;
      }
      PVector p1 = keypoints.get(parte).position;
      float ax = p1.x - x;
      float ay = p1.y - y;
      x += ax * easing;
      y += ay * easing;
      timer.guardarTiempo();
    } else {
      if (timer.pasoElTiempo()) {
        x = -1;
        y = -1;
      }
    }
  }

  ////////
}
