//
//  MYMainViewController.h
//  Socket客户端
//
//  Created by MingYanWoo on 2016/10/8.
//  Copyright © 2016年 MingYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCDAsyncSocket;
@interface MYMainViewController : UIViewController

@property (nonatomic, strong) GCDAsyncSocket *socket;

@end
