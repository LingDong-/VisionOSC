//
//  hand.m
//  CoreMLHand
//
//  Created by lingdong on 10/19/21.
//  based on https://github.com/pierdr/ofxiosfacetracking
//       and https://github.com/pambudi02/objc_handgesture

#include "text.h"

#pragma clang diagnostic ignored "-Wunguarded-availability"

@implementation Text

-(NSArray*)detect:(CGImageRef)image{

  VNRecognizeTextRequest *req = [VNRecognizeTextRequest new];
  NSDictionary *d = [[NSDictionary alloc] init];
  VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:image options:d];

  [handler performRequests:@[req] error:nil];

  return req.results;
}
@end

TEXT::TEXT(){
  tracker = [[Text alloc] init];
}

void TEXT::detect(ofPixels pix)
{
  CGImageRef image = CGImageRefFromOfPixels(pix,(int)pix.getWidth(),(int)pix.getHeight(),(int)pix.getNumChannels());
  NSArray* arr = [tracker detect:image];
  NSError *err;

  n_det = 0;

  for(VNRecognizedTextObservation *observation in arr){
    CGFloat x = pix.getWidth()*observation.boundingBox.origin.x;
    CGFloat y = pix.getHeight()*(1-observation.boundingBox.origin.y-observation.boundingBox.size.height);
    CGFloat w = pix.getWidth()*observation.boundingBox.size.width;
    CGFloat h = pix.getHeight()*observation.boundingBox.size.height;
    VNRecognizedText* recognizedText = [observation topCandidates: 1] [0];
    
    
    
    const char* text = [recognizedText.string UTF8String];
    int n = strlen(text);
    detections[n_det] = ofRectangle(x,y,w,h);
    scores[n_det] = recognizedText.confidence;
    memcpy(strings[n_det],text,n);
    strings[n_det][n] = 0;

    n_det++;
  }
  
  CGImageRelease(image);
}

CGImageRef TEXT::CGImageRefFromOfPixels( ofPixels & img, int width, int height, int numberOfComponents ){
  
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
