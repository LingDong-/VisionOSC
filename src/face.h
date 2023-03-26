//
//  hand.h
//  CoreMLHand
//
//  Created by lingdong on 10/19/21.
//  based on https://github.com/pierdr/ofxiosfacetracking
//       and https://github.com/pambudi02/objc_handgesture

#ifndef face_h
#define face_h

#include "ofMain.h"
#import <Foundation/Foundation.h>
#import <Vision/Vision.h>
#import <AVKit/AVKit.h>

#include "constants.h"

class FACE;

@interface Face:NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>{
  AVCaptureSession*           session;
  AVCaptureVideoDataOutput*   videoDataOutput;
  AVCaptureDevice*            captureDevice;
}
-(NSArray*)detect:(CGImageRef)image;
@end

class FACE{
public:
    enum Feature {
        RIGHT_EYEBROW,
        LEFT_EYEBROW,
        RIGHT_EYECONTOUR,
        LEFT_EYECONTOUR,
        OUTER_LIPS,
        INNER_LIPS,
        FACE_CONTOUR,
        NOSE_CREST,
        MEIDAN_LINE,
        RIGHT_PUPIL,
        LEFT_PUPIL,
        ALL_FEATURES
    };
    
  FACE();
  void detect(ofPixels image);
  CGImageRef CGImageRefFromOfPixels( ofPixels & img, int width, int height, int numberOfComponents );

  ofVec3f detections[MAX_DET][FACE_N_PART];
  float scores      [MAX_DET];
  int n_det = 0;
    
  ofVec3f orientations[MAX_DET];
  
    void draw();
    void drawFeatures();
    void drawInfo(int _x, int _y);
    
    vector<ofRectangle> boundingRects;
    ofPolyline getFeature(int _n_det, Feature feature);
protected:
  
 Face* tracker;

    static std::vector<int> consecutive(int start, int end);
    static  std::vector<int> getFeatureIndices(Feature feature);

};

#endif /* face_h */
