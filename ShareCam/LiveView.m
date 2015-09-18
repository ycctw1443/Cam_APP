//
//  LiveView.m
//  ShareCam
//
//  Created by ycctw1443 on 2015/09/14.
//  Copyright (c) 2015年 ycctw1443. All rights reserved.
//

#import "LiveView.h"

@implementation LiveView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session{
    AVCaptureVideoPreviewLayer *videoLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    
    return videoLayer.session;
}

- (void)setSession:(AVCaptureSession *)session{
    AVCaptureVideoPreviewLayer *videoLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    
    videoLayer.session = session;
}

@end
