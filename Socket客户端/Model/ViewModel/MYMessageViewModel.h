//
//  MYMessageReceiveViewModel.h
//  Socket客户端
//
//  Created by MingYanWoo on 2016/10/14.
//  Copyright © 2016年 MingYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MYMessageModel.h"

@interface MYMessageViewModel : NSObject

//Model
@property (nonatomic, strong) MYMessageModel *model;

//frame
@property (nonatomic, assign) CGRect iconViewFrame;
@property (nonatomic, assign) CGRect nameLabelFrame;
@property (nonatomic, assign) CGRect messageLabelFrame;
@property (nonatomic, assign) CGRect popImageFrame;

//Cell高度
@property (nonatomic, assign) CGFloat cellHeight;

@end
