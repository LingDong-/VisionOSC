//
//  hand.m
//  CoreMLHand
//
//  Created by lingdong on 10/19/21.
//  based on https://github.com/pierdr/ofxiosfacetracking
//       and https://github.com/pambudi02/objc_handgesture

#include "hand.h"

#pragma clang diagnostic ignored "-Wunguarded-availability"

@implementation Hand

-(NSArray*)detect:(CGImageRef)image{

  VNDetectHumanHandPoseRequest *req = [VNDetectHumanHandPoseRequest new];
  NSDictionary *d = [[NSDictionary alloc] init];
  VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:image options:d];

  [handler performRequests:@[req] error:nil];

  return req.results;
}
@end

HAND::HAND(){
  tracker = [[Hand alloc] init];
}

void HAND::detect(ofPixels pix)
{
  
  CGImageRef image = CGImageRefFromOfPixels(pix,(int)pix.getWidth(),(int)pix.getHeight(),(int)pix.getNumChannels());
  NSArray* arr = [tracker detect:image];
  NSError *err;


  n_det = 0;
  for(VNHumanHandPoseObservation *observation in arr){
      NSDictionary <VNHumanHandPoseObservationJointName, VNRecognizedPoint *> *allPts = [observation recognizedPointsForJointsGroupName:VNHumanHandPoseObservationJointsGroupNameAll error:&err];
    
    VNRecognizedPoint *Wrist    = [allPts objectForKey:VNHumanHandPoseObservationJointNameWrist    ];
    VNRecognizedPoint *ThumbCMC = [allPts objectForKey:VNHumanHandPoseObservationJointNameThumbCMC ];
    VNRecognizedPoint *ThumbMP  = [allPts objectForKey:VNHumanHandPoseObservationJointNameThumbMP  ];
    VNRecognizedPoint *ThumbIP  = [allPts objectForKey:VNHumanHandPoseObservationJointNameThumbIP  ];
    VNRecognizedPoint *ThumbTip = [allPts objectForKey:VNHumanHandPoseObservationJointNameThumbTip ];
    VNRecognizedPoint *IndexMCP = [allPts objectForKey:VNHumanHandPoseObservationJointNameIndexMCP ];
    VNRecognizedPoint *IndexPIP = [allPts objectForKey:VNHumanHandPoseObservationJointNameIndexPIP ];
    VNRecognizedPoint *IndexDIP = [allPts objectForKey:VNHumanHandPoseObservationJointNameIndexDIP ];
    VNRecognizedPoint *IndexTip = [allPts objectForKey:VNHumanHandPoseObservationJointNameIndexTip ];
    VNRecognizedPoint *MiddleMCP= [allPts objectForKey:VNHumanHandPoseObservationJointNameMiddleMCP];
    VNRecognizedPoint *MiddlePIP= [allPts objectForKey:VNHumanHandPoseObservationJointNameMiddlePIP];
    VNRecognizedPoint *MiddleDIP= [allPts objectForKey:VNHumanHandPoseObservationJointNameMiddleDIP];
    VNRecognizedPoint *MiddleTip= [allPts objectForKey:VNHumanHandPoseObservationJointNameMiddleTip];
    VNRecognizedPoint *RingMCP  = [allPts objectForKey:VNHumanHandPoseObservationJointNameRingMCP  ];
    VNRecognizedPoint *RingPIP  = [allPts objectForKey:VNHumanHandPoseObservationJointNameRingPIP  ];
    VNRecognizedPoint *RingDIP  = [allPts objectForKey:VNHumanHandPoseObservationJointNameRingDIP  ];
    VNRecognizedPoint *RingTip  = [allPts objectForKey:VNHumanHandPoseObservationJointNameRingTip  ];
    VNRecognizedPoint *LittleMCP= [allPts objectForKey:VNHumanHandPoseObservationJointNameLittleMCP];
    VNRecognizedPoint *LittlePIP= [allPts objectForKey:VNHumanHandPoseObservationJointNameLittlePIP];
    VNRecognizedPoint *LittleDIP= [allPts objectForKey:VNHumanHandPoseObservationJointNameLittleDIP];
    VNRecognizedPoint *LittleTip= [allPts objectForKey:VNHumanHandPoseObservationJointNameLittleTip];
    
    detections[n_det][HAND_WRIST   ].x = Wrist    .location.x * pix.getWidth();
    detections[n_det][HAND_THUMB0  ].x = ThumbCMC .location.x * pix.getWidth();
    detections[n_det][HAND_THUMB1  ].x = ThumbMP  .location.x * pix.getWidth();
    detections[n_det][HAND_THUMB2  ].x = ThumbIP  .location.x * pix.getWidth();
    detections[n_det][HAND_THUMB3  ].x = ThumbTip .location.x * pix.getWidth();
    detections[n_det][HAND_INDEX0  ].x = IndexMCP .location.x * pix.getWidth();
    detections[n_det][HAND_INDEX1  ].x = IndexPIP .location.x * pix.getWidth();
    detections[n_det][HAND_INDEX2  ].x = IndexDIP .location.x * pix.getWidth();
    detections[n_det][HAND_INDEX3  ].x = IndexTip .location.x * pix.getWidth();
    detections[n_det][HAND_MIDDLE0 ].x = MiddleMCP.location.x * pix.getWidth();
    detections[n_det][HAND_MIDDLE1 ].x = MiddlePIP.location.x * pix.getWidth();
    detections[n_det][HAND_MIDDLE2 ].x = MiddleDIP.location.x * pix.getWidth();
    detections[n_det][HAND_MIDDLE3 ].x = MiddleTip.location.x * pix.getWidth();
    detections[n_det][HAND_RING0   ].x = RingMCP  .location.x * pix.getWidth();
    detections[n_det][HAND_RING1   ].x = RingPIP  .location.x * pix.getWidth();
    detections[n_det][HAND_RING2   ].x = RingDIP  .location.x * pix.getWidth();
    detections[n_det][HAND_RING3   ].x = RingTip  .location.x * pix.getWidth();
    detections[n_det][HAND_PINKY0  ].x = LittleMCP.location.x * pix.getWidth();
    detections[n_det][HAND_PINKY1  ].x = LittlePIP.location.x * pix.getWidth();
    detections[n_det][HAND_PINKY2  ].x = LittleDIP.location.x * pix.getWidth();
    detections[n_det][HAND_PINKY3  ].x = LittleTip.location.x * pix.getWidth();
        
    detections[n_det][HAND_WRIST   ].y = (1-Wrist    .location.y) * pix.getHeight();
    detections[n_det][HAND_THUMB0  ].y = (1-ThumbCMC .location.y) * pix.getHeight();
    detections[n_det][HAND_THUMB1  ].y = (1-ThumbMP  .location.y) * pix.getHeight();
    detections[n_det][HAND_THUMB2  ].y = (1-ThumbIP  .location.y) * pix.getHeight();
    detections[n_det][HAND_THUMB3  ].y = (1-ThumbTip .location.y) * pix.getHeight();
    detections[n_det][HAND_INDEX0  ].y = (1-IndexMCP .location.y) * pix.getHeight();
    detections[n_det][HAND_INDEX1  ].y = (1-IndexPIP .location.y) * pix.getHeight();
    detections[n_det][HAND_INDEX2  ].y = (1-IndexDIP .location.y) * pix.getHeight();
    detections[n_det][HAND_INDEX3  ].y = (1-IndexTip .location.y) * pix.getHeight();
    detections[n_det][HAND_MIDDLE0 ].y = (1-MiddleMCP.location.y) * pix.getHeight();
    detections[n_det][HAND_MIDDLE1 ].y = (1-MiddlePIP.location.y) * pix.getHeight();
    detections[n_det][HAND_MIDDLE2 ].y = (1-MiddleDIP.location.y) * pix.getHeight();
    detections[n_det][HAND_MIDDLE3 ].y = (1-MiddleTip.location.y) * pix.getHeight();
    detections[n_det][HAND_RING0   ].y = (1-RingMCP  .location.y) * pix.getHeight();
    detections[n_det][HAND_RING1   ].y = (1-RingPIP  .location.y) * pix.getHeight();
    detections[n_det][HAND_RING2   ].y = (1-RingDIP  .location.y) * pix.getHeight();
    detections[n_det][HAND_RING3   ].y = (1-RingTip  .location.y) * pix.getHeight();
    detections[n_det][HAND_PINKY0  ].y = (1-LittleMCP.location.y) * pix.getHeight();
    detections[n_det][HAND_PINKY1  ].y = (1-LittlePIP.location.y) * pix.getHeight();
    detections[n_det][HAND_PINKY2  ].y = (1-LittleDIP.location.y) * pix.getHeight();
    detections[n_det][HAND_PINKY3  ].y = (1-LittleTip.location.y) * pix.getHeight();
    
    detections[n_det][HAND_WRIST   ].z = Wrist    .confidence;
    detections[n_det][HAND_THUMB0  ].z = ThumbCMC .confidence;
    detections[n_det][HAND_THUMB1  ].z = ThumbMP  .confidence;
    detections[n_det][HAND_THUMB2  ].z = ThumbIP  .confidence;
    detections[n_det][HAND_THUMB3  ].z = ThumbTip .confidence;
    detections[n_det][HAND_INDEX0  ].z = IndexMCP .confidence;
    detections[n_det][HAND_INDEX1  ].z = IndexPIP .confidence;
    detections[n_det][HAND_INDEX2  ].z = IndexDIP .confidence;
    detections[n_det][HAND_INDEX3  ].z = IndexTip .confidence;
    detections[n_det][HAND_MIDDLE0 ].z = MiddleMCP.confidence;
    detections[n_det][HAND_MIDDLE1 ].z = MiddlePIP.confidence;
    detections[n_det][HAND_MIDDLE2 ].z = MiddleDIP.confidence;
    detections[n_det][HAND_MIDDLE3 ].z = MiddleTip.confidence;
    detections[n_det][HAND_RING0   ].z = RingMCP  .confidence;
    detections[n_det][HAND_RING1   ].z = RingPIP  .confidence;
    detections[n_det][HAND_RING2   ].z = RingDIP  .confidence;
    detections[n_det][HAND_RING3   ].z = RingTip  .confidence;
    detections[n_det][HAND_PINKY0  ].z = LittleMCP.confidence;
    detections[n_det][HAND_PINKY1  ].z = LittlePIP.confidence;
    detections[n_det][HAND_PINKY2  ].z = LittleDIP.confidence;
    detections[n_det][HAND_PINKY3  ].z = LittleTip.confidence;
    
    scores[n_det] = observation.confidence;
    n_det = (n_det + 1) % MAX_DET;
    
 
  }
  CGImageRelease(image);
}

CGImageRef HAND::CGImageRefFromOfPixels( ofPixels & img, int width, int height, int numberOfComponents ){
  
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
