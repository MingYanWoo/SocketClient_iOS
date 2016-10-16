//
//  MYMessageReceiveCell.m
//  Socket客户端
//
//  Created by MingYanWoo on 2016/10/14.
//  Copyright © 2016年 MingYan. All rights reserved.
//

#import "MYMessageCell.h"

@interface MYMessageCell ()

@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *messageLabel;

@end

@implementation MYMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"MYMessageCell";
    MYMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MYMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setUpUI
{
    UIImageView *iconView = [[UIImageView alloc] init];
    [self addSubview:iconView];
    _iconView = iconView;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:[UIFont systemFontOfSize:12]];
    [nameLabel setTextColor:[UIColor grayColor]];
    [self addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.numberOfLines = 0;
    [messageLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:messageLabel];
    _messageLabel = messageLabel;
}

- (void)setViewModel:(MYMessageViewModel *)viewModel
{
    _viewModel = viewModel;
    self.iconView.frame = viewModel.iconViewFrame;
    self.nameLabel.frame = viewModel.nameLabelFrame;
    self.messageLabel.frame = viewModel.messageLabelFrame;
    
    if (viewModel.model.type == 1) {
        self.iconView.image = [UIImage imageNamed:@"head_icon_receive"];
    }else {
        self.iconView.image = [UIImage imageNamed:@"head_icon_send"];
    }
    self.nameLabel.text = viewModel.model.name;
    self.messageLabel.text = viewModel.model.text;
}

@end
