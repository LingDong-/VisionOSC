//
//  hand.m
//  CoreMLHand
//
//  Created by lingdong on 10/19/21.
//  based on https://github.com/pierdr/ofxiosfacetracking
//       and https://github.com/pambudi02/objc_handgesture

#include "face.h"

#pragma clang diagnostic ignored "-Wunguarded-availability"

@implementation Face

-(NSArray*)detect:(CGImageRef)image{

  VNDetectFaceLandmarksRequest *req = [VNDetectFaceLandmarksRequest new];
  NSDictionary *d = [[NSDictionary alloc] init];
  VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:image options:d];

  [handler performRequests:@[req] error:nil];

  return req.results;
}
@end

FACE::FACE(){
  tracker = [[Face alloc] init];
}

void FACE::detect(ofPixels pix)
{
  CGImageRef image = CGImageRefFromOfPixels(pix,(int)pix.getWidth(),(int)pix.getHeight(),(int)pix.getNumChannels());
  NSArray* arr = [tracker detect:image];
  NSError *err;


  n_det = 0;
  
  for(VNFaceObservation *observation in arr){
    CGFloat x = pix.getWidth()*observation.boundingBox.origin.x;
    CGFloat y = pix.getHeight()*(1-observation.boundingBox.origin.y-observation.boundingBox.size.height);
    CGFloat w = pix.getWidth()*observation.boundingBox.size.width;
    CGFloat h = pix.getHeight()*observation.boundingBox.size.height;
    
    // apparently pitch is not supported, gives error:
    // -[VNFaceObservation pitch]: unrecognized selector sent to instance
//    orientations[n_det].x = [[observation pitch] floatValue];
    orientations[n_det].x = 0;
    orientations[n_det].y = [observation.yaw floatValue];
    orientations[n_det].z = [observation.roll floatValue];
    
    VNFaceLandmarkRegion2D* landmarks = observation.landmarks.allPoints;
    const CGPoint * points = landmarks.normalizedPoints;
    

    
    for (int i = 0; i < landmarks.pointCount; i++){
      detections[n_det][i].x = points[i].x * w + x;
      detections[n_det][i].y = (1-points[i].y) * h + y;
      detections[n_det][i].z = [landmarks.precisionEstimatesPerPoint[i] floatValue];
    }
    
    scores[n_det] = observation.confidence;
    
    n_det++;
  }
  
  CGImageRelease(image);
}

CGImageRef FACE::CGImageRefFromOfPixels( ofPixels & img, int width, int height, int numberOfComponents ){
  
  int bitsPerColorComponent = 8;
  int rawImageDataLength = width * height * numberOfComponents;
  BOOL interpolateAndSmoothPixels = NO;
  CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
  CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
  CGDataProviderRef dataProviderRef;
  CGColorSpaceRef colorSpaceRef;
  CGImageRef imageRef;
  
  GLubyte *rawImageDataBuffer =  (unsigned char*)(img.getData());
  dataProviderRef = CGDataProviderCreateWithData(NULL,  rawImageDataBuffer, rawImageDataLength, nil);
  if(numberOfComponents>1)
  {
    colorSpaceRef = CGColorSpaceCreateDeviceRGB();
  }
  else
  {
    colorSpaceRef = CGColorSpaceCreateDeviceGray();
  }
  imageRef = CGImageCreate(width, height, bitsPerColorComponent, bitsPerColorComponent * numberOfComponents, width * numberOfComponents, colorSpaceRef, bitmapInfo, dataProviderRef, NULL, interpolateAndSmoothPixels, renderingIntent);
  
  CGDataProviderRelease(dataProviderRef);
  
  return imageRef;
}
