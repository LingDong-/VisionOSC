#pragma once

#include "ofMain.h"

#include "ofxGui.h"
#include "ofxOsc.h"

#include "constants.h"

#include "hand.h"
#include "body.h"
#include "face.h"
#include "text.h"
#include "animal.h"

class ofApp : public ofBaseApp{

	public:
		void setup();
		void update();
		void draw();

		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void mouseEntered(int x, int y);
		void mouseExited(int x, int y);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);
  
  void resetCamOsc();
  
  ofVideoGrabber cam;
  HAND hand;
  BODY body;
  FACE face;
  TEXT text;
  ANIMAL animal;
  
  ofxOscSender sender;
  ofxPanel gui;
		
  ofParameter<string> osc_host = {"OSC Host", "localhost"};
  ofParameter<int> osc_port = {"OSC Port", 9527, 0, 99999};
  ofParameterGroup osc_group = {"OSC", osc_host, osc_port};
  
  ofParameter<int> cam_id = {"Camera ID",0,0,8};
  ofParameter<int> cam_w = {"Camera Width", 640,128,4096};
  ofParameter<int> cam_h = {"Camera Height",480,96, 2160};
  ofParameterGroup cam_group = {"Camera", cam_id, cam_w, cam_h};
  
  ofParameter<bool> do_body = {"Detect Body", true};
  ofParameter<bool> do_hand = {"Detect Hand", true};
  ofParameter<bool> do_face = {"Detect Face", true};
  ofParameter<bool> do_text = {"Detect Text", true};
  ofParameter<bool> do_anml = {"Detect Animal", true};
  ofParameterGroup do_group = {"Vision", do_body, do_hand, do_face, do_text, do_anml};

  ofxButton btn_reset;
};
