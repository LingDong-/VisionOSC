//
//  hand.h
//  CoreMLHand
//
//  Created by lingdong on 10/19/21.
//  based on https://github.com/pierdr/ofxiosfacetracking
//       and https://github.com/pambudi02/objc_handgesture

#ifndef text_h
#define text_h

#include "ofMain.h"
#import <Foundation/Foundation.h>
#import <Vision/Vision.h>
#import <AVKit/AVKit.h>

#include "constants.h"

class TEXT;

@interface Text:NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>{
  AVCaptureSession*           session;
  AVCaptureVideoDataOutput*   videoDataOutput;
  AVCaptureDevice*            captureDevice;
}
-(NSArray*)detect:(CGImageRef)image;
@end

class TEXT{
public:
  TEXT();
  void detect(ofPixels image);
  CGImageRef CGImageRefFromOfPixels( ofPixels & img, int width, int height, int numberOfComponents );

  ofRectangle detections[TEXT_MAX_DET];
  char strings          [TEXT_MAX_DET][TEXT_MAX_LEN];
  float scores          [TEXT_MAX_DET];
  int n_det = 0;
    
protected:
  
 Text* tracker;

};

#endif /* text_h */
