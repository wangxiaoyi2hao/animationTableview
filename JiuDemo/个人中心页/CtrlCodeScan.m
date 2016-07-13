//
//  CtrlCodeScan.m
//  WisdomSchoolBadge
//
//  Created by zhangyilong on 15/7/16.
//  Copyright (c) 2015年 zhangyilong. All rights reserved.
//

#import "CtrlCodeScan.h"

@interface CtrlCodeScan ()

@end

@implementation CtrlCodeScan

@synthesize delegate;
@synthesize overlayer;
@synthesize device;
@synthesize input;
@synthesize output;
@synthesize session;
@synthesize preview;
@synthesize line;
@synthesize scanFrame;
@synthesize isLightOn;

- (void)dealloc
{
}

- (instancetype)init
{
    if ([super init])
    {
        delegate = nil;
        
        return self;
    }
    
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    isLightOn = NO;
    [self initScan];
    
    [session startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self scanLineAnimate];
}

- (void)initScan
{
    CGSize winsize = [UIScreen mainScreen].bounds.size;
    
    // Device
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    output = [[AVCaptureMetadataOutput alloc] init];
    
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    session = [[AVCaptureSession alloc] init];
    
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([session canAddInput:self.input])
    {
        [session addInput:self.input];
    }
    
    if ([session canAddOutput:self.output])
    {
        [session addOutput:self.output];
    }
    
    output.rectOfInterest = CGRectMake(((winsize.height - 300) / 2 - 5) / winsize.height, (winsize.width - 300) / 2 / winsize.width , 300 / winsize.height, 300 / winsize.width);
    
    // 条码类型 AVMetadataObjectTypeQRCode
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // Preview
    preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    preview.frame = CGRectMake(0, 0, winsize.width, winsize.height);//self.view.layer.bounds;
    
    [self.view.layer insertSublayer:preview atIndex:0];
    
    CGRect rect = output.rectOfInterest;
    CGRect frame = CGRectZero;
    
    frame.origin.x = (winsize.width - 230) / 2;//winsize.width * rect.origin.y;
    frame.origin.y = (winsize.height - 230) / 2;//winsize.height * rect.origin.x;
    frame.size.width = 230;
    frame.size.height= 230;
    
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor= [UIColor clearColor];
    view.layer.borderWidth = 1;
    view.layer.borderColor = [[UIColor grayColor] CGColor];
    self.scanFrame = view;
    [self.view addSubview:view];
    
    //top
    UIView* shadow = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.origin.y -64, winsize.width, view.frame.origin.y -64)];
    shadow.backgroundColor = [UIColor blackColor];
    shadow.alpha = 0.5;
    [self.view addSubview:shadow];
    
    //bottom
    shadow = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.origin.y + view.frame.size.height, winsize.width, winsize.height - (view.frame.origin.y + view.frame.size.height))];
    shadow.backgroundColor = [UIColor blackColor];
    shadow.alpha = 0.5;
    [self.view addSubview:shadow];
    
    //left
    shadow = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.origin.y, (winsize.width - view.frame.size.width) / 2, view.frame.size.height)];
    shadow.backgroundColor = [UIColor blackColor];
    shadow.alpha = 0.5;
    [self.view addSubview:shadow];
    
    //right
    shadow = [[UIView alloc] initWithFrame:CGRectMake(view.frame.origin.x + view.frame.size.width, view.frame.origin.y, (winsize.width - view.frame.size.width) / 2, view.frame.size.height)];
    shadow.backgroundColor = [UIColor blackColor];
    shadow.alpha = 0.5;
    [self.view addSubview:shadow];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(view.frame.origin.x + 1, view.frame.origin.y + 1, frame.size.width - 2, 10)];
    //line.center = view.center;
    line.backgroundColor = [UIColor clearColor];
    [self.view addSubview:line];
    
    CAGradientLayer* gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = line.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[[UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.1] CGColor],
                            (id)[[UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.35] CGColor],
                            (id)[[UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.8] CGColor],
                            (id)[[UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.35] CGColor],
                            (id)[[UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.1] CGColor],
                            nil];
    [line.layer insertSublayer:gradientLayer atIndex:0];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.origin.y - 18, line.frame.size.width, 15)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = CGPointMake(line.center.x, label.center.y);
    label.text = @"对准二维码/条形码到框内即可扫描";//@"二维码: 将二维码置于灰色方形区域内; 条形码: 将条形码置于灰色方形区域内并将红线置于条形码竖直中心位置";
    [self.view addSubview:label];
    
    //light
    UIButton* light = [UIButton buttonWithType:UIButtonTypeCustom];
    light.frame = CGRectMake(0, view.frame.origin.y + view.frame.size.height + 5, 35, 35);
    light.center = CGPointMake(winsize.width / 2, light.center.y);
    light.backgroundColor = [UIColor clearColor];
    [light setBackgroundImage:[UIImage imageNamed:@"light_off"] forState:UIControlStateNormal];
    [light setBackgroundImage:[UIImage imageNamed:@"light_on"] forState:UIControlStateSelected];
    [light addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:light];
    
    [self initConner];
}

- (void)initConner
{
    CGFloat w = 2;
    CGFloat h = 10;
    CGFloat d = 2;
    CGPoint point = CGPointZero;
    
    //left - top
    point = CGPointMake(scanFrame.frame.origin.x - w - d, scanFrame.frame.origin.y - w - d);
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, w, h)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, h, w)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    //left - down
    point = CGPointMake(scanFrame.frame.origin.x - w - d, scanFrame.frame.origin.y + scanFrame.frame.size.height + d + w - h);
    view = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, w, h)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    point = CGPointMake(point.x, scanFrame.frame.origin.y + scanFrame.frame.size.height + d);
    view = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, h, w)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    //right - top
    point = CGPointMake(scanFrame.frame.origin.x + scanFrame.frame.size.width + d, scanFrame.frame.origin.y - w - d);
    view = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, w, h)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    point = CGPointMake(scanFrame.frame.origin.x + scanFrame.frame.size.width + w + d - h, point.y);
    view = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, h, w)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    //right - down
    point = CGPointMake(scanFrame.frame.origin.x + scanFrame.frame.size.width + d, scanFrame.frame.origin.y + scanFrame.frame.size.height + w + d - h);
    view = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, w, h)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    point = CGPointMake(point.x + w - h, scanFrame.frame.origin.y + scanFrame.frame.size.height + d);
    view = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, h, w)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
}

- (void)openLight:(UIButton*)sender
{
    [device lockForConfiguration:nil];
    if (!sender.selected)
    {
        [device setTorchMode:AVCaptureTorchModeOn];
        [device setFlashMode:AVCaptureFlashModeOn];
        
        sender.selected = YES;
    }
    else
    {
        [device setTorchMode:AVCaptureTorchModeOff];
        [device setFlashMode:AVCaptureFlashModeOff];
        
        sender.selected = NO;
    }
    [device unlockForConfiguration];
}

- (void)scanLineAnimate
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //[UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(didScanLineFinished)];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:HUGE_VALF];
    line.center = CGPointMake(line.center.x, scanFrame.frame.origin.y + scanFrame.frame.size.height - 5);
    [UIView commitAnimations];
}

- (void)didScanLineFinished
{
    line.center = CGPointMake(line.center.x, scanFrame.frame.origin.y + 1);
    
    [self scanLineAnimate];
}

- (IBAction)OnTopBackDown:(UIButton*)sender
{
    [session stopRunning];
    
    [output setMetadataObjectsDelegate:nil queue:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [session stopRunning];
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        
        stringValue = metadataObject.stringValue;
    }
    
    [delegate didCodeScanOk:stringValue];
    
    [output setMetadataObjectsDelegate:nil queue:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
