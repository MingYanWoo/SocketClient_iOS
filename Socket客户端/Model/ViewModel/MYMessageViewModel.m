//
//  MYMessageReceiveViewModel.m
//  Socket客户端
//
//  Created by MingYanWoo on 2016/10/14.
//  Copyright © 2016年 MingYan. All rights reserved.
//

#import "MYMessageViewModel.h"

@implementation MYMessageViewModel

- (void)setModel:(MYMessageModel *)model
{
    _model = model;
    [self setUpFrame];
}

- (void)setUpFrame
{
    if (_model.type == 1) {
        CGFloat margin = 15;
        CGFloat popMargin = 10;
        //头像
        CGFloat iconX = margin;
        CGFloat iconY = margin;
        CGFloat iconSize = 30;
        _iconViewFrame = CGRectMake(iconX, iconY, iconSize, iconSize);
        
        //昵称
        CGFloat nameX = CGRectGetMaxX(_iconViewFrame) + margin;
        CGFloat nameY = iconY;
        CGSize nameSize = [_model.name sizeWithFont:[UIFont systemFontOfSize:12]];
        _nameLabelFrame = (CGRect){{nameX,nameY},nameSize};
        
        //消息
        CGFloat messageX = nameX + popMargin;
        CGFloat messageY = CGRectGetMaxY(_nameLabelFrame) + 5 + popMargin;
        CGFloat messageW = [UIScreen mainScreen].bounds.size.width * 0.5;
        CGSize messageSize = [_model.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(messageW, MAXFLOAT)];
        _messageLabelFrame = (CGRect){{messageX,messageY},messageSize};
        
        //气泡
        CGFloat popX = messageX - popMargin - 8;
        CGFloat popY = messageY - popMargin;
        CGSize popSize = CGSizeMake(messageSize.width + 2 * popMargin + 8, messageSize.height + 2 * popMargin);
        _popImageFrame = (CGRect){{popX, popY}, popSize};
        
        _cellHeight = CGRectGetMaxY(_iconViewFrame) > CGRectGetMaxY(_popImageFrame) ? CGRectGetMaxY(_iconViewFrame) : CGRectGetMaxY(_popImageFrame);
        _cellHeight += margin;
    }else {
        CGFloat margin = 15;
        CGFloat popMargin = 10;
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        //头像
        CGFloat iconSize = 30;
        CGFloat iconX = screenW - iconSize - margin;
        CGFloat iconY = margin;
        _iconViewFrame = CGRectMake(iconX, iconY, iconSize, iconSize);
        
        //昵称
        CGSize nameSize = [_model.name sizeWithFont:[UIFont systemFontOfSize:12]];
        CGFloat nameX = screenW - iconSize - nameSize.width - 2 * margin;
        CGFloat nameY = iconY;
        _nameLabelFrame = (CGRect){{nameX, nameY}, nameSize};
        
        //消息
        CGFloat messageW = screenW * 0.5;
        CGSize messageSize = [_model.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(messageW, MAXFLOAT)];
        CGFloat messageX = screenW - messageSize.width - (screenW - CGRectGetMaxX(_nameLabelFrame)) - popMargin;
        CGFloat messageY = CGRectGetMaxY(_nameLabelFrame) + 5 + popMargin;
        _messageLabelFrame = (CGRect){{messageX,messageY},messageSize};
        
        //气泡
        CGFloat popX = messageX - popMargin;
        CGFloat popY = messageY - popMargin;
        CGSize popSize = CGSizeMake(messageSize.width + 2 * popMargin + 8, messageSize.height + 2 * popMargin);
        _popImageFrame = (CGRect){{popX, popY}, popSize};
        
        _cellHeight = CGRectGetMaxY(_iconViewFrame) > CGRectGetMaxY(_popImageFrame) ? CGRectGetMaxY(_iconViewFrame) : CGRectGetMaxY(_popImageFrame);
        _cellHeight += margin;
    }
}

@end
