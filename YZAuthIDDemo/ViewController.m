//
//  ViewController.m
//  YZAuthID
//
//  Created by Apple on 2017/12/22.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "ViewController.h"
#import "YZAuthID.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"auth_bg"]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, 40)];
    titleLabel.text = @"YZAuthID";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton *touchIDButton = [[UIButton alloc] init];
    [touchIDButton setBackgroundImage:[UIImage imageNamed:@"auth_touch_locked"] forState:UIControlStateNormal];
    [touchIDButton setBackgroundImage:[UIImage imageNamed:@"auth_touch_lockedHL"] forState:UIControlStateHighlighted];
    [touchIDButton addTarget:self action:@selector(authVerification) forControlEvents:UIControlEventTouchDown];
    touchIDButton.frame = CGRectMake((self.view.frame.size.width / 2) - 35, (self.view.frame.size.height / 2) + 60, 70, 70);
    [self.view addSubview:touchIDButton];
    
    UILabel *touchIDLabel = [[UILabel alloc] init];
    touchIDLabel.frame = CGRectMake(0, (self.view.frame.size.height / 2) + 140, self.view.frame.size.width, 30);
    touchIDLabel.textAlignment = NSTextAlignmentCenter;
    touchIDLabel.text = @"点击唤醒指纹验证";
    touchIDLabel.font = [UIFont systemFontOfSize:15.0f];
    touchIDLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:touchIDLabel];
    
}

#pragma mark - 验证TouchID/FaceID
- (void)authVerification {
    
    YZAuthID *authID = [[YZAuthID alloc] init];
    
    [authID yz_showAuthIDWithDescribe:nil BlockState:^(YZAuthIDState state, NSError *error) {
        
        if (state == YZAuthIDStateNotSupport) { // 不支持TouchID/FaceID
            NSLog(@"对不起，当前设备不支持指纹/面部ID");
        } else if(state == YZAuthIDStateFail) { // 认证失败
            NSLog(@"指纹/面部ID不正确，认证失败");
        } else if(state == YZAuthIDStateTouchIDLockout) {   // 多次错误，已被锁定
            NSLog(@"多次错误，指纹/面部ID已被锁定，请到手机解锁界面输入密码");
        } else if (state == YZAuthIDStateSuccess) { // TouchID/FaceID验证成功
            NSLog(@"认证成功！");
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
