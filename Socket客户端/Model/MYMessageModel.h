//
//  MYMessageModel.h
//  Socket客户端
//
//  Created by MingYanWoo on 2016/10/14.
//  Copyright © 2016年 MingYan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYMessageModel : NSObject

//昵称
@property (nonatomic, copy) NSString *name;
//文本
@property (nonatomic, copy) NSString *text;
//类型：1为收到，0为发送
@property (nonatomic, assign) int type;

@end
