//
//  LiveView.h
//  ShareCam
//
//  Created by ycctw1443 on 2015/09/14.
//  Copyright (c) 2015年 ycctw1443. All rights reserved.
//

#import <UIKit/UIKit.h>

@import UIKit;
@import AVFoundation;

@interface LiveView : UIView
@property (nonatomic, strong)AVCaptureSession *session;
@end
