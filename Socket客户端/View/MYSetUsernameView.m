//
//  MYSetUsernameView.m
//  Socket客户端
//
//  Created by MingYanWoo on 2016/10/15.
//  Copyright © 2016年 MingYan. All rights reserved.
//

#import "MYSetUsernameView.h"
#import "MBProgressHUD.h"

@interface MYSetUsernameView ()

@property (nonatomic, weak) UITextField *usernameField;

@end

@implementation MYSetUsernameView

 - (instancetype)init
{
    if (self == [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 250) * 0.5, ([UIScreen mainScreen].bounds.size.height - 140) * 0.5, 250, 140);
        self.layer.cornerRadius = 10;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = @"请输入你的昵称";
    [hintLabel sizeToFit];
    hintLabel.center = CGPointMake(self.frame.size.width * 0.5, 25);
    [self addSubview:hintLabel];
    
    UITextField *usernameField = [[UITextField alloc] initWithFrame:CGRectMake((self.frame.size.width - 180) * 0.5, CGRectGetMaxY(hintLabel.frame) + 15, 180, 30)];
    usernameField.placeholder = @"长度不大于10个字";
    [usernameField setFont:[UIFont systemFontOfSize:15]];
    usernameField.textAlignment = NSTextAlignmentCenter;
    usernameField.layer.cornerRadius = 10;
    usernameField.layer.borderColor = [UIColor blackColor].CGColor;
    usernameField.layer.borderWidth = 2;
    [self addSubview:usernameField];
    _usernameField = usernameField;
    
    UIButton *comfirmBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 80) * 0.5, CGRectGetMaxY(usernameField.frame) + 15, 80, 30)];
    comfirmBtn.layer.cornerRadius = 10;
    comfirmBtn.layer.borderColor = [UIColor blackColor].CGColor;
    comfirmBtn.layer.borderWidth = 2;
    [comfirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [comfirmBtn setFont:[UIFont systemFontOfSize:15]];
    [comfirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [comfirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [comfirmBtn addTarget:self action:@selector(comfirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:comfirmBtn];
}

- (void)comfirmBtnClick
{
    if ([_delegate respondsToSelector:@selector(btnClicked:withName:)]) {
        if ([self.usernameField.text isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            [hud setMode:MBProgressHUDModeText];
            hud.label.text = @"昵称不能为空!";
            [hud hideAnimated:YES afterDelay:2.0];
            return;
        }else if (self.usernameField.text.length > 10) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            [hud setMode:MBProgressHUDModeText];
            hud.label.text = @"昵称太长!";
            [hud hideAnimated:YES afterDelay:2.0];
            return;
        }else {
            [_delegate btnClicked:self withName:self.usernameField.text];
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, - self.frame.origin.y - self.frame.size.height * 2);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
