//
//  SendInternet.h
//  sportXProject
//
//  Created by lsp's mac pro on 16/6/1.
//  Copyright © 2016年 lsp's mac pro. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^FinishBlock)(NSData *dataString);

@interface SendInternet : NSObject<NSURLConnectionDataDelegate>
//定义需要的成员变量
@property (strong, nonatomic) NSMutableData *resultData;//保存HTTP结果对象
@property (strong, nonatomic) FinishBlock finishBlock;//回调方法
//该函数相当于是静态方法 不需要实例即可访问
+(void) httpNsynchronousRequestUrl:(NSString*) postUrl postStr:(NSData*)sData finshedBlock:(FinishBlock)block;
@end
