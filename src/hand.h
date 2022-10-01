//
//  hand.h
//  CoreMLHand
//
//  Created by lingdong on 10/19/21.
//  based on https://github.com/pierdr/ofxiosfacetracking
//       and https://github.com/pambudi02/objc_handgesture

#ifndef hand_h
#define hand_h

#include "ofMain.h"
#import <Foundation/Foundation.h>
#import <Vision/Vision.h>
#import <AVKit/AVKit.h>

#include "constants.h"

class HAND;

@interface Hand:NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>{
  AVCaptureSession*           session;
  AVCaptureVideoDataOutput*   videoDataOutput;
  AVCaptureDevice*            captureDevice;
}
-(NSArray*)detect:(CGImageRef)image;
@end

class HAND{
public:
  HAND();
  void detect(ofPixels image);
  CGImageRef CGImageRefFromOfPixels( ofPixels & img, int width, int height, int numberOfComponents );

  ofVec3f detections[MAX_DET][HAND_N_PART];
  float scores      [MAX_DET];
  int n_det = 0;
    
protected:
  
 Hand* tracker;

};

#endif /* hand_h */
