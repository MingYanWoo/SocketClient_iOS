//
//  MYMessageReceiveCell.h
//  Socket客户端
//
//  Created by MingYanWoo on 2016/10/14.
//  Copyright © 2016年 MingYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYMessageViewModel.h"

@interface MYMessageCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) MYMessageViewModel *viewModel;

@end
