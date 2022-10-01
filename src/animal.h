//
//  hand.h
//  CoreMLHand
//
//  Created by lingdong on 10/19/21.
//  based on https://github.com/pierdr/ofxiosfacetracking
//       and https://github.com/pambudi02/objc_handgesture

#ifndef animal_h
#define animal_h

#include "ofMain.h"
#import <Foundation/Foundation.h>
#import <Vision/Vision.h>
#import <AVKit/AVKit.h>

#include "constants.h"

class ANIMAL;

@interface Animal:NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>{
  AVCaptureSession*           session;
  AVCaptureVideoDataOutput*   videoDataOutput;
  AVCaptureDevice*            captureDevice;
}
-(NSArray*)detect:(CGImageRef)image;
@end

class ANIMAL{
public:
  ANIMAL();
  void detect(ofPixels image);
  CGImageRef CGImageRefFromOfPixels( ofPixels & img, int width, int height, int numberOfComponents );

  ofRectangle detections[MAX_DET];
  char strings          [MAX_DET][TEXT_MAX_LEN];
  float scores          [MAX_DET];
  int n_det = 0;
    
protected:
  
 Animal* tracker;

};

#endif /* animal_h */
