class Timer {
  int espera;
  int time;

  Timer(int espera_) {
    espera = espera_;
  }

  void guardarTiempo() {
    time = millis();
  }

  boolean pasoElTiempo() {
    //println(millis()-time, " ", espera);
    if (millis() - time >= espera) {
      println("confirmo seleccion");
      return true;
    }
    return false;
  }

  ////
}
