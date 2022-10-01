import oscP5.*;
OscP5 oscP5;

int BODY_N_PART = 17;
int FACE_N_PART = 76;
int HAND_N_PART = 21;
int MAX_DET = 32;

class KeyPt{
  float x;
  float y;
  float score;
  KeyPt(float _x, float _y, float _score){
    x = _x; y = _y; score = _score; 
  }
}

class PtsDetection{
  float score;
  KeyPt[] points;
  PtsDetection(int n){
    points = new KeyPt[n];
  }
}

class RectDetection{
  public float x;
  public float y;
  public float w;
  public float h;
  public float score;
  public String label;
}

PtsDetection[] poses;
PtsDetection[] hands;
PtsDetection[] faces;
RectDetection[] texts;
RectDetection[] animals;

int nPose = 0;
int nHand = 0;
int nFace = 0;
int nText = 0;
int nAnimal = 0;

int vidW;
int vidH;

//----------------------------------
void setup() {
  size(640,480);
  OscProperties prop = new OscProperties();
  // increase the datagram size
  // by default it is set to 1536 bytes
  // https://sojamo.de/libraries/oscP5/reference/index.html
  prop.setDatagramSize(10000); 
  prop.setListeningPort(9527);
  
  oscP5 = new OscP5(this, prop);
  
  poses = new PtsDetection[MAX_DET];
  hands = new PtsDetection[MAX_DET];
  faces = new PtsDetection[MAX_DET];
  texts = new RectDetection[MAX_DET];
  animals = new RectDetection[MAX_DET];
  
}

//----------------------------------
void draw() {
  background(0);
  
  
  fill(255,255,0);
  drawPtsDetection(poses,nPose,10);
  fill(255,0,255);
  drawPtsDetection(faces,nFace,5);
  fill(0,255,255);
  drawPtsDetection(hands,nHand,5);
  
  fill(255);
  
  stroke(0,255,0);
  drawRectDetection(texts,nText);
  
  stroke(255,0,0);
  drawRectDetection(animals,nAnimal);
}


void drawPtsDetection(PtsDetection[] dets, int nDet, int rad){
  pushStyle();
  noStroke();
  for (int i = 0; i < nDet; i++){
    for (int j = 0; j < dets[i].points.length; j++){
      if (dets[i].points[j]!= null){
        circle(dets[i].points[j].x, dets[i].points[j].y, rad);
      }
    }
  }
  popStyle();
}

void drawRectDetection(RectDetection[] dets, int nDet){
  pushStyle();
  for (int i = 0; i < nDet; i++){
    noFill();
    rect(dets[i].x,dets[i].y,dets[i].w,dets[i].h);
    text(dets[i].label,dets[i].x,dets[i].y);
  }
  popStyle();
}
 
int readPtsDetection(OscMessage msg, int nParts, PtsDetection[] out){
  vidW = msg.get(0).intValue();
  vidH = msg.get(1).intValue();
  int nDet = msg.get(2).intValue();
  int n = nParts*3+1;
  for (int i = 0; i < nDet; i++){
    PtsDetection det = new PtsDetection(nParts);
    det.score = msg.get(3+i*n).floatValue();
    for (int j = 0; j < nParts; j++){
      float x = msg.get(3+i*n+1+j*3).floatValue();
      float y = msg.get(3+i*n+1+j*3+1).floatValue();
      float score = msg.get(3+i*n+1+j*3+2).floatValue();
      det.points[j] = new KeyPt(x,y,score);
    }
    out[i] = det;
  }
  return nDet;
}

int readRectDetection(OscMessage msg, RectDetection[] out){
  vidW = msg.get(0).intValue();
  vidH = msg.get(1).intValue();
  int nDet = msg.get(2).intValue();
  for (int i = 0; i < nDet; i++){
    RectDetection det = new RectDetection();
    det.score = msg.get(3+i*6).floatValue();
    det.x = msg.get(3+i*6+1).floatValue();
    det.y = msg.get(3+i*6+2).floatValue();
    det.w = msg.get(3+i*6+3).floatValue();
    det.h = msg.get(3+i*6+4).floatValue();
    det.label = msg.get(3+i*6+5).stringValue();
    out[i] = det;
  }
  return nDet;
}
 
 
//----------------------------------
/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage msg) {
  if (msg.addrPattern().equals("/poses/arr")){
    nPose = readPtsDetection(msg,BODY_N_PART,poses);
  }else if (msg.addrPattern().equals("/hands/arr")){
    nHand = readPtsDetection(msg,HAND_N_PART,hands);
  }else if (msg.addrPattern().equals("/faces/arr")){
    nFace = readPtsDetection(msg,FACE_N_PART,faces);
  }else if (msg.addrPattern().equals("/texts/arr")){
    nText = readRectDetection(msg,texts);
  }else if (msg.addrPattern().equals("/animals/arr")){
    nAnimal = readRectDetection(msg,animals);
  }
}
