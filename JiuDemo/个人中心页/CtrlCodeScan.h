//
//  CtrlCodeScan.h
//  WisdomSchoolBadge
//
//  Created by zhangyilong on 15/7/16.
//  Copyright (c) 2015年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol CtrlCodeScanDelegate <NSObject>

@optional
- (void)didCodeScanOk:(id)info;

@end

@interface CtrlCodeScan : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property(nonatomic, weak) IBOutlet UIView*     overlayer;

@property(nonatomic, weak) id<CtrlCodeScanDelegate>      delegate;

@property(strong, nonatomic) AVCaptureDevice*            device;
@property(strong, nonatomic) AVCaptureDeviceInput*       input;
@property(strong, nonatomic) AVCaptureMetadataOutput*    output;
@property(strong, nonatomic) AVCaptureSession*           session;
@property(strong, nonatomic) AVCaptureVideoPreviewLayer* preview;

@property(nonatomic, strong) UIView*                     scanFrame;
@property(nonatomic, strong) UIView*                     line;
@property(nonatomic, assign) BOOL                        isLightOn;

- (IBAction)OnTopBackDown:(UIButton*)sender;

@end
