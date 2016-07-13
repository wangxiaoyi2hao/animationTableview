//
//  MineViewController.h
//  JiuDemo
//
//  Created by lsp's mac pro on 16/7/4.
//  Copyright © 2016年 lsp's mac pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
IBOutlet UIView*_headerView;


 UIImageView *_zoomImageView;//变焦图片做底层
   
    
    UIImageView *_circleView;//类似头像的UIImageView
    UILabel *_textLabel;//类似昵称UILabel
}
@property(nonatomic,strong)   UITableView *tableView;

@end
