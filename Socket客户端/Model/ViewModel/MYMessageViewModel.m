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
        //头像
        CGFloat iconX = margin;
        CGFloat iconY = margin;
        CGFloat iconSize = 25;
        _iconViewFrame = CGRectMake(iconX, iconY, iconSize, iconSize);
        
        //昵称
        CGFloat nameX = CGRectGetMaxX(_iconViewFrame) + margin;
        CGFloat nameY = iconY;
        CGSize nameSize = [_model.name sizeWithFont:[UIFont systemFontOfSize:12]];
        _nameLabelFrame = (CGRect){{nameX,nameY},nameSize};
        
        //消息
        CGFloat messageX = nameX;
        CGFloat messageY = CGRectGetMaxY(_nameLabelFrame) + 5;
        CGFloat messageW = [UIScreen mainScreen].bounds.size.width - iconSize - 3 * margin;
        CGSize messageSize = [_model.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(messageW, MAXFLOAT)];
        _messageLabelFrame = (CGRect){{messageX,messageY},messageSize};
        
        _cellHeight = CGRectGetMaxY(_iconViewFrame) > CGRectGetMaxY(_messageLabelFrame) ? CGRectGetMaxY(_iconViewFrame) : CGRectGetMaxY(_messageLabelFrame);
        _cellHeight += margin;
    }else {
        CGFloat margin = 15;
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        //头像
        CGFloat iconSize = 25;
        CGFloat iconX = screenW - iconSize - margin;
        CGFloat iconY = margin;
        _iconViewFrame = CGRectMake(iconX, iconY, iconSize, iconSize);
        
        //昵称
        CGSize nameSize = [_model.name sizeWithFont:[UIFont systemFontOfSize:12]];
        CGFloat nameX = screenW - iconSize - nameSize.width - 2 * margin;
        CGFloat nameY = iconY;
        _nameLabelFrame = (CGRect){{nameX, nameY}, nameSize};
        
        //消息
        CGFloat messageW = screenW - iconSize - 3 * margin;
        CGSize messageSize = [_model.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(messageW, MAXFLOAT)];
        CGFloat messageX = screenW - iconSize - messageSize.width - 2 * margin;
        CGFloat messageY = CGRectGetMaxY(_nameLabelFrame) + 5;
        _messageLabelFrame = (CGRect){{messageX,messageY},messageSize};
        
        _cellHeight = CGRectGetMaxY(_iconViewFrame) > CGRectGetMaxY(_messageLabelFrame) ? CGRectGetMaxY(_iconViewFrame) : CGRectGetMaxY(_messageLabelFrame);
        _cellHeight += 15;
    }
}

@end
