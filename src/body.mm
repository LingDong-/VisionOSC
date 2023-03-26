//
//  hand.m
//  CoreMLBody
//
//  Created by lingdong on 10/19/21.
//  based on https://github.com/pierdr/ofxiosfacetracking
//       and https://github.com/pambudi02/objc_handgesture

#include "body.h"

#pragma clang diagnostic ignored "-Wunguarded-availability"


@implementation Body

-(NSArray*)detect:(CGImageRef)image{

//  VNDetectHumanBodyPoseRequest *req = [[VNDetectHumanBodyPoseRequest new] autorelease];
//  NSDictionary *d = [[[NSDictionary alloc] init] autorelease];
//  VNImageRequestHandler *handler = [[[VNImageRequestHandler alloc] initWithCGImage:image options:d] autorelease];
  
  VNDetectHumanBodyPoseRequest *req = [VNDetectHumanBodyPoseRequest new];
  NSDictionary *d = [[NSDictionary alloc] init];
  VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:image options:d];

  [handler performRequests:@[req] error:nil];

  return req.results;
}
@end

BODY::BODY(){
  tracker = [[Body alloc] init];
}

void BODY::detect(ofPixels pix)
{
  CGImageRef image = CGImageRefFromOfPixels(pix,(int)pix.getWidth(),(int)pix.getHeight(),(int)pix.getNumChannels());
  NSArray* arr = [tracker detect:image];
  NSError *err;

//    VNHumanBodyPoseObservation *observation =(VNHumanBodyPoseObservation*) arr.firstObject;
  n_det = 0;
  for(VNHumanBodyPoseObservation *observation in arr){
      NSDictionary <VNHumanBodyPoseObservationJointName, VNRecognizedPoint *> *allPts = [observation recognizedPointsForJointsGroupName:VNHumanBodyPoseObservationJointsGroupNameAll error:&err];
    
    VNRecognizedPoint *Nose         = [allPts objectForKey:VNHumanBodyPoseObservationJointNameNose];
    VNRecognizedPoint *LeftEye      = [allPts objectForKey:VNHumanBodyPoseObservationJointNameLeftEye];
    VNRecognizedPoint *RightEye     = [allPts objectForKey:VNHumanBodyPoseObservationJointNameRightEye];
    VNRecognizedPoint *LeftEar      = [allPts objectForKey:VNHumanBodyPoseObservationJointNameLeftEar];
    VNRecognizedPoint *RightEar     = [allPts objectForKey:VNHumanBodyPoseObservationJointNameRightEar];
    VNRecognizedPoint *LeftWrist    = [allPts objectForKey:VNHumanBodyPoseObservationJointNameLeftWrist];
    VNRecognizedPoint *RightWrist   = [allPts objectForKey:VNHumanBodyPoseObservationJointNameRightWrist];
    VNRecognizedPoint *LeftElbow    = [allPts objectForKey:VNHumanBodyPoseObservationJointNameLeftElbow];
    VNRecognizedPoint *RightElbow   = [allPts objectForKey:VNHumanBodyPoseObservationJointNameRightElbow];
    VNRecognizedPoint *LeftShoulder = [allPts objectForKey:VNHumanBodyPoseObservationJointNameLeftShoulder];
    VNRecognizedPoint *RightShoulder= [allPts objectForKey:VNHumanBodyPoseObservationJointNameRightShoulder];
    VNRecognizedPoint *LeftHip      = [allPts objectForKey:VNHumanBodyPoseObservationJointNameLeftHip];
    VNRecognizedPoint *RightHip     = [allPts objectForKey:VNHumanBodyPoseObservationJointNameRightHip];
    VNRecognizedPoint *LeftKnee     = [allPts objectForKey:VNHumanBodyPoseObservationJointNameLeftKnee];
    VNRecognizedPoint *RightKnee    = [allPts objectForKey:VNHumanBodyPoseObservationJointNameRightKnee];
    VNRecognizedPoint *LeftAnkle    = [allPts objectForKey:VNHumanBodyPoseObservationJointNameLeftAnkle];
    VNRecognizedPoint *RightAnkle   = [allPts objectForKey:VNHumanBodyPoseObservationJointNameRightAnkle];
    
    detections[n_det][BODY_NOSE          ].x = Nose         .location.x * pix.getWidth();
    detections[n_det][BODY_LEFTEYE       ].x = LeftEye      .location.x * pix.getWidth();
    detections[n_det][BODY_RIGHTEYE      ].x = RightEye     .location.x * pix.getWidth();
    detections[n_det][BODY_LEFTEAR       ].x = LeftEar      .location.x * pix.getWidth();
    detections[n_det][BODY_RIGHTEAR      ].x = RightEar     .location.x * pix.getWidth();
    detections[n_det][BODY_LEFTWRIST     ].x = LeftWrist    .location.x * pix.getWidth();
    detections[n_det][BODY_RIGHTWRIST    ].x = RightWrist   .location.x * pix.getWidth();
    detections[n_det][BODY_LEFTELBOW     ].x = LeftElbow    .location.x * pix.getWidth();
    detections[n_det][BODY_RIGHTELBOW    ].x = RightElbow   .location.x * pix.getWidth();
    detections[n_det][BODY_LEFTSHOULDER  ].x = LeftShoulder .location.x * pix.getWidth();
    detections[n_det][BODY_RIGHTSHOULDER ].x = RightShoulder.location.x * pix.getWidth();
    detections[n_det][BODY_LEFTHIP       ].x = LeftHip      .location.x * pix.getWidth();
    detections[n_det][BODY_RIGHTHIP      ].x = RightHip     .location.x * pix.getWidth();
    detections[n_det][BODY_LEFTKNEE      ].x = LeftKnee     .location.x * pix.getWidth();
    detections[n_det][BODY_RIGHTKNEE     ].x = RightKnee    .location.x * pix.getWidth();
    detections[n_det][BODY_LEFTANKLE     ].x = LeftAnkle    .location.x * pix.getWidth();
    detections[n_det][BODY_RIGHTANKLE    ].x = RightAnkle   .location.x * pix.getWidth();
    
    detections[n_det][BODY_NOSE          ].y = (1-Nose         .location.y) * pix.getHeight();
    detections[n_det][BODY_LEFTEYE       ].y = (1-LeftEye      .location.y) * pix.getHeight();
    detections[n_det][BODY_RIGHTEYE      ].y = (1-RightEye     .location.y) * pix.getHeight();
    detections[n_det][BODY_LEFTEAR       ].y = (1-LeftEar      .location.y) * pix.getHeight();
    detections[n_det][BODY_RIGHTEAR      ].y = (1-RightEar     .location.y) * pix.getHeight();
    detections[n_det][BODY_LEFTWRIST     ].y = (1-LeftWrist    .location.y) * pix.getHeight();
    detections[n_det][BODY_RIGHTWRIST    ].y = (1-RightWrist   .location.y) * pix.getHeight();
    detections[n_det][BODY_LEFTELBOW     ].y = (1-LeftElbow    .location.y) * pix.getHeight();
    detections[n_det][BODY_RIGHTELBOW    ].y = (1-RightElbow   .location.y) * pix.getHeight();
    detections[n_det][BODY_LEFTSHOULDER  ].y = (1-LeftShoulder .location.y) * pix.getHeight();
    detections[n_det][BODY_RIGHTSHOULDER ].y = (1-RightShoulder.location.y) * pix.getHeight();
    detections[n_det][BODY_LEFTHIP       ].y = (1-LeftHip      .location.y) * pix.getHeight();
    detections[n_det][BODY_RIGHTHIP      ].y = (1-RightHip     .location.y) * pix.getHeight();
    detections[n_det][BODY_LEFTKNEE      ].y = (1-LeftKnee     .location.y) * pix.getHeight();
    detections[n_det][BODY_RIGHTKNEE     ].y = (1-RightKnee    .location.y) * pix.getHeight();
    detections[n_det][BODY_LEFTANKLE     ].y = (1-LeftAnkle    .location.y) * pix.getHeight();
    detections[n_det][BODY_RIGHTANKLE    ].y = (1-RightAnkle   .location.y) * pix.getHeight();
    
    
    detections[n_det][BODY_NOSE          ].z = Nose         .confidence;
    detections[n_det][BODY_LEFTEYE       ].z = LeftEye      .confidence;
    detections[n_det][BODY_RIGHTEYE      ].z = RightEye     .confidence;
    detections[n_det][BODY_LEFTEAR       ].z = LeftEar      .confidence;
    detections[n_det][BODY_RIGHTEAR      ].z = RightEar     .confidence;
    detections[n_det][BODY_LEFTWRIST     ].z = LeftWrist    .confidence;
    detections[n_det][BODY_RIGHTWRIST    ].z = RightWrist   .confidence;
    detections[n_det][BODY_LEFTELBOW     ].z = LeftElbow    .confidence;
    detections[n_det][BODY_RIGHTELBOW    ].z = RightElbow   .confidence;
    detections[n_det][BODY_LEFTSHOULDER  ].z = LeftShoulder .confidence;
    detections[n_det][BODY_RIGHTSHOULDER ].z = RightShoulder.confidence;
    detections[n_det][BODY_LEFTHIP       ].z = LeftHip      .confidence;
    detections[n_det][BODY_RIGHTHIP      ].z = RightHip     .confidence;
    detections[n_det][BODY_LEFTKNEE      ].z = LeftKnee     .confidence;
    detections[n_det][BODY_RIGHTKNEE     ].z = RightKnee    .confidence;
    detections[n_det][BODY_LEFTANKLE     ].z = LeftAnkle    .confidence;
    detections[n_det][BODY_RIGHTANKLE    ].z = RightAnkle   .confidence;
    
    scores[n_det] = observation.confidence;
    n_det = (n_det + 1) % MAX_DET;
    
 
  }
  CGImageRelease(image);

}

CGImageRef BODY::CGImageRefFromOfPixels( ofPixels & img, int width, int height, int numberOfComponents ){
  
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
