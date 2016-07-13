//
//  CIFilter.h
//  原生二维码
//
//  Created by 高建强 on 15-9-2.
//  Copyright (c) 2015年 高建强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CIFilterTools : UIView

/**
 *  单例对象
 */
+ (instancetype)shareInstance;


/**
 *  1.二维码的生成
 *
 *  @param qrString 传入生成二维码的字符串
 *
 *  @return 二维码图片
 */
- (CIImage *)createQRForString:(NSString *)qrString;

/**
 *  2.返回需要大小的UIImage
 *
 *  @param image CIImage *
 *  @param size  需要的大小
 *
 *  @return 自定义大小的图片
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

/*
 3.对二维码进行颜色填充,并转换为透明背景，使用遍历图片像素来更改图片颜色
 */
- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;


/**
 *  判断设备是否有摄像头 摄像头是否可用
 */
- (BOOL)validateCamera;
@end
