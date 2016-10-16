//
//  MYMainViewController.m
//  Socket客户端
//
//  Created by MingYanWoo on 2016/10/8.
//  Copyright © 2016年 MingYan. All rights reserved.
//

#import "MYMainViewController.h"
#import "GCDAsyncSocket.h"
#import "MBProgressHUD.h"
#import "MYMessageViewModel.h"
#import "MYMessageCell.h"
#import "MYSetUsernameView.h"

#define MYBackgroudColor [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1]

@interface MYMainViewController () <GCDAsyncSocketDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MYSetUsernameViewDelegate>

@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (weak, nonatomic) UITextField *textField;
@property (weak, nonatomic) UITableView *tableView;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, weak) UIView *coverView;
@property (nonatomic, weak) UIVisualEffectView *visualEfView;
@property (nonatomic, weak) MYSetUsernameView *setUsernameView;

@property (nonatomic, strong) NSMutableArray *messageFrameArray;

@end

@implementation MYMainViewController

- (NSMutableArray *)messageFrameArray
{
    if (_messageFrameArray == nil) {
        _messageFrameArray = [NSMutableArray array];
    }
    return _messageFrameArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = MYBackgroudColor;
    
    UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEfView.frame = self.view.frame;
    visualEfView.alpha = 0.01;
    [self.view addSubview:visualEfView];
    _visualEfView = visualEfView;
    
    MYSetUsernameView *setUsernameView = [[MYSetUsernameView alloc] init];
    setUsernameView.delegate = self;
    [self.view addSubview:setUsernameView];
    _setUsernameView = setUsernameView;
    
    [UIView animateWithDuration:0.5 animations:^{
        _visualEfView.alpha = 0.9;
    }];
    
    GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    _socket = socket;
    
    NSError *error = nil;
    [socket connectToHost:@"119.29.175.89" onPort:12345 error:&error];
    
    if (error) {
        NSLog(@"error:%@",error);
    }
    //监听键盘弹出或收回通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoradWillShow) name:UIKeyboardWillShowNotification object:nil];
}

//实现接收到通知时的操作
-(void) keyBoardChange:(NSNotification *)note
{
    //获取键盘弹出或收回时frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //获取键盘弹出所需时长
    float duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //添加弹出动画
    if (self.setUsernameView == nil) {
        [UIView animateWithDuration:duration animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, keyboardFrame.origin.y - self.view.frame.size.height);
        }];
    }else {
        [UIView animateWithDuration:duration animations:^{
            self.setUsernameView.transform = CGAffineTransformMakeTranslation(0, -50);
        }];
    }
}

//键盘弹出加蒙版
- (void)keyBoradWillShow
{
    UIView *coverView = [[UIView alloc] initWithFrame:self.tableView.frame];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCoverView)];
    [coverView addGestureRecognizer:tap];
    [self.tableView addSubview:coverView];
    _coverView = coverView;
}

- (void)hideCoverView
{
    [self.coverView removeFromSuperview];
    self.coverView = nil;
    [self.textField endEditing:YES];
}

- (void)btnClicked:(MYSetUsernameView *)view withName:(NSString *)name
{
    self.userName = name;
    [UIView animateWithDuration:0.5 animations:^{
        _visualEfView.alpha = 0.01;
    } completion:^(BOOL finished) {
        [self.visualEfView removeFromSuperview];
        self.visualEfView = nil;
        self.setUsernameView = nil;
    }];
}

- (void)setUpUI
{
    CGSize screenSize = self.view.frame.size;
    CGFloat margin = 8;
    //工具条背景
    UIView *toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, screenSize.height - 50, screenSize.width, 50)];
    toolBarView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
    [self.view addSubview:toolBarView];
    
    //发送按钮
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenSize.width - 50 - margin, margin, 50, toolBarView.bounds.size.height - 2 * margin)];
    [sendBtn setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
    [sendBtn setImage:[UIImage imageNamed:@"send_highlighted"] forState:UIControlStateHighlighted];
    sendBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    sendBtn.layer.cornerRadius = 15;
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [toolBarView addSubview:sendBtn];
    
    //输入框
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(margin, margin, screenSize.width - sendBtn.bounds.size.width - 3 * margin, toolBarView.bounds.size.height - 2 * margin)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.borderColor = [UIColor blackColor].CGColor;
    textField.layer.borderWidth = 2;
    textField.layer.cornerRadius = 10;
    [textField setReturnKeyType:UIReturnKeySend];
    textField.delegate = self;
    [toolBarView addSubview:textField];
    _textField = textField;
    
    //tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, screenSize.width, screenSize.height - toolBarView.bounds.size.height - 20)];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)sendBtnClick
{
    if ([self.textField.text isEqualToString:@""])
        return;
    NSString *str = [NSString stringWithFormat:@"from=%@&text=%@&\n",self.userName,self.textField.text];
    [self.socket writeData:[str dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    
    NSLog(@"%@",str);
    
    
    MYMessageModel *model = [[MYMessageModel alloc] init];
    model.name = self.userName;
    model.text = self.textField.text;
    model.type = 0;
    MYMessageViewModel *viewModel = [[MYMessageViewModel alloc] init];
    [viewModel setModel:model];
    [self.messageFrameArray addObject:viewModel];
    
    self.textField.text = @"";
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.messageFrameArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageFrameArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendBtnClick];
    return YES;
}

#pragma mark - socketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"连接成功!");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        hud.label.text = @"连接成功";
        [hud hideAnimated:YES afterDelay:2.0];
    });
    
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (err) {
        NSLog(@"连接失败!");
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [hud setMode:MBProgressHUDModeText];
            hud.label.text = @"连接失败，请检查网络";
            [hud hideAnimated:YES afterDelay:2.0];
        });
    }else {
        NSLog(@"正常断开!");
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [hud setMode:MBProgressHUDModeText];
            hud.label.text = @"已断开服务器";
            [hud hideAnimated:YES afterDelay:2.0];
        });
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    str = [str substringWithRange:NSMakeRange(0, str.length - 1)];
    NSLog(@"收到：%@",str);
    
    NSRange range = [str rangeOfString:@"from="];
    NSString *name = [str substringFromIndex:range.location + range.length];
    range = [name rangeOfString:@"&"];
    name = [name substringToIndex:range.location];
    NSLog(@"name:%@",name);
    
    range = [str rangeOfString:@"text="];
    NSString *text = [str substringFromIndex:range.location + range.length];
    range = [text rangeOfString:@"&"];
    text = [text substringToIndex:range.location];
    NSLog(@"text:%@",text);
    
    MYMessageModel *model = [[MYMessageModel alloc] init];
    model.name = name;
    model.text = text;
    model.type = 1;
    
    MYMessageViewModel *viewModel = [[MYMessageViewModel alloc] init];
    [viewModel setModel:model];
    [self.messageFrameArray addObject:viewModel];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.messageFrameArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageFrameArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
    [sock readDataWithTimeout:-1 tag:0];
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageFrameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYMessageViewModel *viewModel = self.messageFrameArray[indexPath.row];

    MYMessageCell *cell = [MYMessageCell cellWithTableView:tableView];
    cell.viewModel = viewModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYMessageViewModel *viewModel = self.messageFrameArray[indexPath.row];
    return viewModel.cellHeight;
}

@end
