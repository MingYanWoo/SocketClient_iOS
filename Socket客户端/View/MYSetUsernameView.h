//
//  MYSetUsernameView.h
//  Socket客户端
//
//  Created by MingYanWoo on 2016/10/15.
//  Copyright © 2016年 MingYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYSetUsernameView;
@protocol MYSetUsernameViewDelegate <NSObject>

- (void)btnClicked:(MYSetUsernameView *)view withName:(NSString *)name;

@end
@interface MYSetUsernameView : UIView

@property (nonatomic, weak) id<MYSetUsernameViewDelegate> delegate;

@end
