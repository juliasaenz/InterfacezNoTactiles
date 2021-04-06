//Kinect
import org.openkinect.freenect.*;
import org.openkinect.processing.*;
//Runway 
import com.runwayml.*;

//Objetos
RunwayHTTP runway;
Kinect kinect;
Timer timer;

// La Data detectada de Runway
JSONObject data;
JSONArray poses;


// This are the pair of body connections we want to form. 
// Try creating new ones!
int[][] connections = {
  {ModelUtils.POSE_NOSE_INDEX, ModelUtils.POSE_LEFT_EYE_INDEX},
  {ModelUtils.POSE_LEFT_EYE_INDEX, ModelUtils.POSE_LEFT_EAR_INDEX},
  {ModelUtils.POSE_NOSE_INDEX,ModelUtils.POSE_RIGHT_EYE_INDEX},
  {ModelUtils.POSE_RIGHT_EYE_INDEX,ModelUtils.POSE_RIGHT_EAR_INDEX},
  {ModelUtils.POSE_RIGHT_SHOULDER_INDEX,ModelUtils.POSE_RIGHT_ELBOW_INDEX},
  {ModelUtils.POSE_RIGHT_ELBOW_INDEX,ModelUtils.POSE_RIGHT_WRIST_INDEX},
  {ModelUtils.POSE_LEFT_SHOULDER_INDEX,ModelUtils.POSE_LEFT_ELBOW_INDEX},
  {ModelUtils.POSE_LEFT_ELBOW_INDEX,ModelUtils.POSE_LEFT_WRIST_INDEX}, 
  {ModelUtils.POSE_RIGHT_HIP_INDEX,ModelUtils.POSE_RIGHT_KNEE_INDEX},
  {ModelUtils.POSE_RIGHT_KNEE_INDEX,ModelUtils.POSE_RIGHT_ANKLE_INDEX},
  {ModelUtils.POSE_LEFT_HIP_INDEX,ModelUtils.POSE_LEFT_KNEE_INDEX},
  {ModelUtils.POSE_LEFT_KNEE_INDEX,ModelUtils.POSE_LEFT_ANKLE_INDEX}
};


int waitTime = 210;

void setup(){
  size(600,400);

  // Runway
  runway = new RunwayHTTP(this);
  // disable automatic polling: request data manually when a new frame is ready
  runway.setAutoUpdate(false);

  // Timer
  timer = new Timer(waitTime);
  timer.guardarTiempo();
  // Kinect
  kinect = new Kinect(this);
  kinect.initVideo();
  kinect.enableMirror(true);
}

void draw(){
  background(0);
  if (timer.pasoElTiempo()){
   sendFrameToRunway();
   timer.guardarTiempo();
  }
  
  //kinect.enableIR(true);
  image(kinect.getVideoImage(),0,0);
  
  // manually draw PoseNet parts
  //ModelUtils.drawPoseParts(data,g,10);
  drawParts();
}

void drawParts() {
  // Only if there are any humans detected
  if (data != null) {
    poses = data.getJSONArray("poses");
    for(int h = 0; h < poses.size(); h++) {
      JSONArray keypoints = poses.getJSONArray(h);
      // Now that we have one human, let's draw its body parts
      for (int k = 0; k < keypoints.size(); k++) {
        // Body parts are relative to width and weight of the input
        JSONArray point = keypoints.getJSONArray(9);
        float x = point.getFloat(0);
        float y = point.getFloat(1);
        ellipse(x * width, y * height, 10, 10);
      }
    }
  }
}

void sendFrameToRunway(){
  // Mandar imagen a Runway
  PImage image = kinect.getVideoImage();
  runway.query(image);
}

// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // point the sketch data to the Runway incoming data 
  data = runwayData;
  
}

// this is called each time Processing connects to Runway
// Runway sends information about the current model
public void runwayInfoEvent(JSONObject info){
  //println(info);
}

// if anything goes wrong
public void runwayErrorEvent(String message){
  //println(message);
}
