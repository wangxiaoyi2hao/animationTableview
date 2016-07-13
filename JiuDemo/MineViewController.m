//
//  MineViewController.m
//  JiuDemo
//
//  Created by lsp's mac pro on 16/7/4.
//  Copyright © 2016年 lsp's mac pro. All rights reserved.
//

#import "MineViewController.h"
#import "UIImage+ImageEffects.h"
#import "UIImageView+LBBlurredImage.h"
#import <CoreImage/CoreImage.h>
#import "UIImage+FEBoxBlur.h"
#import "CtrlCodeScan.h"
#import "QRViewController.h"
#import "CIFilterTools.h"


#define NavigationBarHight 64.0f
#define HEADER_HEIGHT 200.0f
#define ImageHight 146.0f
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface MineViewController ()
{

    UIImageView*_backgroundView;
    UIView*okView;
    UIImageView*_imageSuccess;
}
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   #pragma mark test方法测试2
    //2.初始化_tableView
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //3.设置代理，头文件也要包含 UITableViewDelegate,UITableViewDataSource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //4.设置contentInset属性（上左下右 的值）
    self.tableView.contentInset = UIEdgeInsetsMake(ImageHight, 0, 0, 0);
    //5.添加_tableView
    self.tableView.tableHeaderView=_headerView;
    UIView*footView=[[UIView alloc]init];
    self.tableView.tableFooterView=footView;
    [self.view addSubview:self.tableView];
//上面的图片的方法
 
    
    _zoomImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_1.png"]];
    _zoomImageView.frame = CGRectMake(0, -ImageHight, self.view.frame.size.width, 146);
    _zoomImageView.contentMode = UIViewContentModeScaleAspectFill;//重点（不设置那将只会被纵向拉伸）
    [self.tableView addSubview:_zoomImageView];

    //设置autoresizesSubviews让子类自动布局
    _zoomImageView.autoresizesSubviews = YES;
    //设置autoresizesSubviews让子类自动布局
    _zoomImageView.autoresizesSubviews = YES;
    okView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_2.png"]];
    okView.frame = CGRectMake(0, -ImageHight, self.view.frame.size.width, 146);
    okView.contentMode = UIViewContentModeScaleAspectFill;//重点（不设置那将只会被纵向拉伸）
    [self.tableView addSubview:okView];
    //模糊图片
    //设置autoresizesSubviews让子类自动布局
    okView.autoresizesSubviews = YES;
    //设置autoresizesSubviews让子类自动布局
    okView.autoresizesSubviews = YES;
    _imageSuccess=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    _imageSuccess.frame = CGRectMake(0, -ImageHight, self.view.frame.size.width, 146);
    _imageSuccess.backgroundColor=[UIColor clearColor];
    _imageSuccess.contentMode = UIViewContentModeScaleAspectFill;//重点（不设置那将只会被纵向拉伸）
    [self.tableView addSubview:_imageSuccess];
    //模糊图片
    //设置autoresizesSubviews让子类自动布局
    _imageSuccess.autoresizesSubviews = YES;
    //设置autoresizesSubviews让子类自动布局
    _imageSuccess.autoresizesSubviews = YES;
    _imageSuccess.userInteractionEnabled = YES;
    //地下白色底块
    _backgroundView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 146,SCREEN_WIDTH , 66)];
    _backgroundView.backgroundColor=[UIColor whiteColor];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;

    [_imageSuccess addSubview:_backgroundView];
  /*这个上面都是写那个效果的*/
 

    //订阅  发布 粉丝
    UIImageView*imageViewDing=[[UIImageView alloc]initWithFrame:CGRectMake(154, 10, 19, 31)];
    [imageViewDing setImage:[UIImage imageNamed:@"icon_dingyue.png"]];
    imageViewDing.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
  
    [_backgroundView addSubview:imageViewDing];
  
    UIButton*button1=[[UIButton alloc]initWithFrame:CGRectMake(154, -30, 19, 20)];
    [button1 setTitle:@"dasdafdsfsf"forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor redColor]];
    [button1 addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:button1];
//发布图片
    UIImageView*imageViewSend=[[UIImageView alloc]initWithFrame:CGRectMake(0, -30, 19, 31)];
    [imageViewSend setImage:[UIImage imageNamed:@"icon_fabu.png"]];
    imageViewSend.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [_backgroundView addSubview:imageViewSend];
    UIImageView*imageViewFans=[[UIImageView alloc]initWithFrame:CGRectMake(315, 10, 19, 31)];
    [imageViewFans setImage:[UIImage imageNamed:@"icon_fensi.png"]];
    imageViewFans.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [_imageSuccess addSubview:imageViewFans];
    
    
    //头像
    _circleView = [[UIImageView alloc]initWithFrame:CGRectMake(44, 113, 56, 56)];
    _circleView.layer.masksToBounds=YES;
    _circleView.layer.cornerRadius = 28;
    _circleView.image = [UIImage imageNamed:@"head.png"];
    _circleView.clipsToBounds = YES;
    _circleView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_imageSuccess addSubview:_circleView];
    //姓名
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 176, 148, 17)];
    _textLabel.textColor = [UIColor grayColor];
    _textLabel.text = @"左手边";
    _textLabel.font=[UIFont systemFontOfSize:12];
    _textLabel.textAlignment=NSTextAlignmentCenter;
    _textLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
    [_imageSuccess addSubview:_textLabel];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)editClick{

   

}
-(IBAction)twoM:(UIButton*)sender{
    if ([[CIFilterTools shareInstance] validateCamera]) {//有摄像头并且可用
        
        QRViewController *qrVC = [[QRViewController alloc] init];
        [self.navigationController pushViewController:qrVC animated:YES];
        
    } else {
        //没摄像头或者摄像头不可用
        UIAlertController *alertview=[UIAlertController alertControllerWithTitle:@"提示" message:@"没有摄像头或摄像头不可用" preferredStyle:UIAlertControllerStyleAlert];
        // UIAlertControllerStyleActionSheet 是显示在屏幕底部
        // UIAlertControllerStyleAlert 是显示在中间
        
        // 设置按钮
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *defult = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        //UIAlertAction *destructive = [UIAlertAction actionWithTitle:@"destructive" style:UIAlertActionStyleDestructive handler:nil];
        [alertview addAction:cancel];
        [alertview addAction:defult];
        //[alertview addAction:destructive];
        
        //显示（AppDelegate.h里使用self.window.rootViewController代替self）
        
        [self presentViewController:alertview animated:YES completion:nil];
    }


}
//封装一个方法
- (UIImage*) blur:(UIImage*)theImage value:(float)valueBlur
{
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    CIFilter *affineClampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    CGAffineTransform xform = CGAffineTransformMakeScale(1.0, 1.0);
    [affineClampFilter setValue:inputImage forKey:kCIInputImageKey];
    [affineClampFilter setValue:[NSValue valueWithBytes:&xform
                                               objCType:@encode(CGAffineTransform)]
                         forKey:@"inputTransform"];
    
    CIImage *extendedImage = [affineClampFilter valueForKey:kCIOutputImageKey];
    
    // setting up Gaussian Blur (could use one of many filters offered by Core Image)
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setValue:extendedImage forKey:kCIInputImageKey];
    [blurFilter setValue:[NSNumber numberWithFloat:valueBlur] forKey:@"inputRadius"];
    CIImage *result = [blurFilter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    //create a UIImage for this function to "return" so that ARC can manage the memory of the blur...
    //ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    
    return returnImage;
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;

}
#pragma mark 代理方法不要忘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat y = scrollView.contentOffset.y;//根据实际选择加不加上NavigationBarHight（44、64 或者没有导航条）
   
    okView.alpha=((ImageHight-(-y))/10+3)+1;
    NSLog(@"%.f",(ImageHight-(-y))/10+3);
    if (y < -ImageHight) {
 
        CGRect frame = _zoomImageView.frame;
        frame.origin.y = y;
        frame.size.height =  -y;//contentMode = UIViewContentModeScaleAspectFill时，高度改变宽度也跟着改变
        _zoomImageView.frame = frame;
        CGRect frame1 = okView.frame;
        frame1.origin.y = y;
        frame1.size.height =  -y;//contentMode = UIViewContentModeScaleAspectFill时，高度改变宽度也跟着改变
        okView.frame = frame1;
        CGRect frame2 = _imageSuccess.frame;
        frame2.origin.y = y;
        frame2.size.height =  -y;//contentMode = UIViewContentModeScaleAspectFill时，高度改变宽度也跟着改变
        _imageSuccess.frame = frame1;
        
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"这个自己命名"];
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"这个自己命名"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset=UIEdgeInsetsZero;
        cell.clipsToBounds = YES;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 行",indexPath.row];
    
    return cell;
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

@end
