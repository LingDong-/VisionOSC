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
    // Force the revision to 2 (68-points) even on iOS 13 or greater
     // when VNDetectFaceLandmarksRequestRevision3 is available.
    /*
     Right eyebrow = 0 - 3
     Left eyebrow = 4 - 7
     Right eye contour = 8 - 15
     Left eye contour = 16 - 23
     Outer lips = 24 - 33
     Inner lips = 34 - 39
     Face Contour = 40 - 50
     Nose and Nose Crest = 51 - 59
     Meidan Line = 60 - 62
     Right Pupil = 63
     Left Pupil = 64
     */
    //https://stackoverflow.com/a/57913742
    req.revision = 2;

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

 
  
  n_det = 0;
    boundingRects.clear();
  for(VNFaceObservation *observation in arr){
    CGFloat x = pix.getWidth()*observation.boundingBox.origin.x;
    CGFloat y = pix.getHeight()*(1-observation.boundingBox.origin.y-observation.boundingBox.size.height);
    CGFloat w = pix.getWidth()*observation.boundingBox.size.width;
    CGFloat h = pix.getHeight()*observation.boundingBox.size.height;
    
      boundingRects.push_back(ofRectangle(x,y,w,h));
      
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


void FACE::draw(){
//    ofPushStyle();
    for (int i = 0; i < n_det; i++){
        
        ofColor faceColor = ofColor((i*23+311)%200, (i*41+431)%200, (i*33+197)%200);
        ofSetColor(faceColor);
        
        if(i < boundingRects.size()){
            ofLog()<<i<<" boundingRects "<<boundingRects[i];
            ofNoFill();
            ofDrawRectangle(boundingRects[i]);
        }
        
        ofFill();
        for (int j = 0; j < FACE_N_PART; j++){
            ofDrawCircle(detections[i][j].x, detections[i][j].y, 2);
        }
        // face orientation: extremely choppy
        // seems to only support 45deg increments, X-axis not supported
        //    ofSetColor(0,0,255);
        //    ofPushMatrix();
        //    ofTranslate(face.detections[i][34]);
        //    ofRotateZRad(face.orientations[i].z);
        //    ofRotateYRad(face.orientations[i].y);
        //    ofRotateXRad(face.orientations[i].x);
        //    ofNoFill();
        //    ofDrawBox(-50,-50,-50,100,100,100);
        //    ofPopMatrix();
        
        stringstream ss;
        ss<<"id "<<i<<" : score "<<scores[i];
        ofBitmapFont bitFont;
        ofRectangle bbox = bitFont.getBoundingBox(ss.str(), 0,0);
        bbox.setX(boundingRects[i].getCenter().x-bbox.getWidth()/2);
        bbox.setY(boundingRects[i].getTop()-bbox.getHeight());
        ofDrawBitmapStringHighlight(ss.str(),bbox.getPosition(),ofColor::black,ofColor::yellow);
        
    }
//    ofPopStyle();
}
void FACE::drawFeatures(){
    ofPushStyle();
    for (int i = 0; i < n_det; i++){
        ofSetColor(255);
        getFeature(i,RIGHT_EYEBROW).draw();
        getFeature(i,LEFT_EYEBROW).draw();
        getFeature(i,RIGHT_EYECONTOUR).draw();
        getFeature(i,LEFT_EYECONTOUR).draw();
        getFeature(i,OUTER_LIPS).draw();
        getFeature(i,INNER_LIPS).draw();
        getFeature(i,FACE_CONTOUR).draw();
        getFeature(i,NOSE_CREST).draw();
        getFeature(i,MEIDAN_LINE).draw();
        getFeature(i,RIGHT_PUPIL).draw();
        getFeature(i,LEFT_PUPIL).draw();
    }
    ofPopStyle();
}
void FACE::drawInfo(int _x, int _y){
    stringstream ss;
    ss<<"faces "<<n_det; //<<endl;
    ofDrawBitmapString(ss.str(),0,0);
}

vector<int> FACE::getFeatureIndices(Feature feature) {
    //https://stackoverflow.com/a/49343549
    /*
     Right eyebrow = 0 - 3
     Left eyebrow = 4 - 7
     Right eye contour = 8 - 15
     Left eye contour = 16 - 23
     Outer lips = 24 - 33
     Inner lips = 34 - 39
     Face Contour = 40 - 50
     Nose and Nose Crest = 51 - 59
     Meidan Line = 60 - 62
     Right Pupil = 63
     Left Pupil = 64
     */
    switch(feature) {
        
        case RIGHT_EYEBROW: return consecutive(0,3);
        case LEFT_EYEBROW: return consecutive(4,7);
        case RIGHT_EYECONTOUR: return consecutive(8,15);
        case LEFT_EYECONTOUR: return consecutive(16,23);
            
        case OUTER_LIPS: return consecutive(24,33);
        case INNER_LIPS: return consecutive(34,39);
        case FACE_CONTOUR: return consecutive(40,50);
          
        case NOSE_CREST: return consecutive(51,59);
        case MEIDAN_LINE: return consecutive(60,62);
        case RIGHT_PUPIL: return consecutive(63,63);
        case LEFT_PUPIL: return consecutive(64,64);
            
        case ALL_FEATURES: return consecutive(0, 68);
    }
}

vector<int> FACE::consecutive(int start, int end) {
    int n = (end+1) - start;
    vector<int> result(n);
    for(int i = 0; i < n; i++) {
        result[i] = start + i;
    }
    return result;
}

ofPolyline FACE::getFeature(int _n_det, Feature feature) {
    ofPolyline polyline;
    vector<int> indices = getFeatureIndices(feature);
    for(int i = 0; i < indices.size(); i++) {
        int cur = indices[i];
        polyline.addVertex({detections[_n_det][cur].x, detections[_n_det][cur].y, 0.f});
    }
    switch(feature) {
        case LEFT_EYECONTOUR:
        case RIGHT_EYECONTOUR:
        case OUTER_LIPS:
        case INNER_LIPS:
//        case FACE_CONTOUR:
            polyline.close();
            break;
        default:
            break;
    }
    
    return polyline;
}
