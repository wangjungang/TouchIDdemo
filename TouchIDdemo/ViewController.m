//
//  ViewController.m
//  TouchIDdemo
//
//  Created by 王俊钢 on 2017/8/2.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()
@property (nonatomic,strong) UIButton *setBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"首页";
    
    [self.view addSubview:self.setBtn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIButton *)setBtn
{
    if(!_setBtn)
    {
        _setBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 80, 100, 60)];
        [_setBtn setTitle:@"Touch ID" forState:normal];
        [_setBtn setTitleColor:[UIColor blackColor] forState:normal];
        _setBtn.backgroundColor = [UIColor orangeColor];
        [_setBtn addTarget:self action:@selector(setbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setBtn;
}


-(void)setbtnclick
{
    dispatch_async(dispatch_get_main_queue(), ^{
        LAContext *touchID = [LAContext new];
        NSError *error = nil;
        NSString *touchIDSuccess = @"XXOO正在申请通过指纹验证！";
        if ([touchID canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                 error:&error])
        {//支持touchID
            [touchID evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:touchIDSuccess reply:^(BOOL success, NSError * _Nullable error)
             {
                 
                 NSLog(@"ErrorCode:%ld",error.code);
                 
                 switch (error.code)
                 {
                     case LAErrorAuthenticationFailed:
                     {
                         [self alertWithMessage:@"指纹验证失败"];
                     }
                         break;
                     case LAErrorUserCancel:
                     {
                         [self alertWithMessage:@"用户取消验证"];
                     }
                         break;
                     case LAErrorUserFallback:
                     {
                         [self alertWithMessage:@"用户进行了后退操作"];
                     }
                         break;
                     case LAErrorSystemCancel:
                     {
                         [self alertWithMessage:@"系统取消操作"];
                     }
                         break;
                     case LAErrorPasscodeNotSet:
                     {
                         [self alertWithMessage:@"用户尚未设置密码"];
                     }
                         break;
                     case LAErrorTouchIDNotEnrolled:
                     {
                         [self alertWithMessage:@"用户尚未设置 TouchID"];
                     }
                         break;
                     case LAErrorTouchIDLockout:
                     {
                         [self alertWithMessage:@"TouchID已停止运行"];
                     }
                         break;
                     case LAErrorAppCancel:
                     {
                         [self alertWithMessage:@"APP取消操作"];
                     }
                         break;
                     case LAErrorInvalidContext:
                     {
                         [self alertWithMessage:@"TouchID不可用"];
                     }
                         break;
                     case 0:
                     {
                         [self alertWithMessage:@"TouchID验证成功"];
                     }
                         break;
                     default:
                         break;
                 }
             }];
        }
        else
        {//不支持touchID，或者错误次数太多，造成touchID不可用
            [self alertWithMessage:@"TouchID不可用"];
        }
    });
    
}

- (void)alertWithMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tips"
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                       }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    });
}


@end
