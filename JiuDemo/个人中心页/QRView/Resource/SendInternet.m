//
//  SendInternet.m
//  sportXProject
//
//  Created by lsp's mac pro on 16/6/1.
//  Copyright © 2016年 lsp's mac pro. All rights reserved.
//

#import "SendInternet.h"

@implementation SendInternet
//该方法为异步请求服务器，不用在主线程创建其它线程
+(void) httpNsynchronousRequestUrl:(NSString*) postUrl postStr:(NSData*)sData finshedBlock:(FinishBlock)block
{

    SendInternet *http = [[SendInternet alloc]init];
    http.finishBlock = block;
    //初始HTTP
    NSURL *url = [NSURL URLWithString:postUrl];
    NSMutableURLRequest *requst = [NSMutableURLRequest requestWithURL:url];
    [requst setHTTPMethod:@"POST"];
    
    
    [requst setHTTPBody:sData];
    NSLog(@"%@",sData);
    [requst setTimeoutInterval:15.0];

    //连接
    NSURLConnection *con = [[NSURLConnection alloc]initWithRequest:requst delegate:http];
    NSLog(con ? @"连接创建成功" : @"连接创建失败");
   

}

//收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
    [self.resultData appendData:data];
}

//接收到服务器回应的时回调
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
    if (self.resultData == nil) {
        self.resultData = [[NSMutableData alloc]init];
    }else{
        [self.resultData setLength:0];
    }
}

//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(self.finishBlock != nil)
 
        self.finishBlock(self.resultData);
    
}

//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
   
    NSLog(@"didFailWithError");
    if(self.finishBlock != nil)
        self.finishBlock(nil);
}

@end
