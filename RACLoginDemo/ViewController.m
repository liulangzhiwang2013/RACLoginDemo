//
//  ViewController.m
//  RACLoginDemo
//
//  Created by pxx on 2018/4/13.
//  Copyright © 2018年 平晓行. All rights reserved.
//

#import "ViewController.h"
/*
 用RAC写，当用户名不为空和密码长度大于6的时候，登录按钮才可点击
 */
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *psdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic,assign) BOOL is;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     将TextField的输入转化为信号量
     */
    RACSignal *userNameSignal = self.userNameTF.rac_textSignal;
    RACSignal *psdSignal = self.psdTF.rac_textSignal;
    /*
     合并两个输入框的信号量，并使用map对信号量返回值进行映射使其返回bool值，
     */
    RACSignal *bigSignal = [[RACSignal combineLatest:@[userNameSignal,psdSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        RACTupleUnpack(NSString *username , NSString *psd) = value;
        //@()将值变量装箱成对象
        return @([username length]>0 && [psd length]>6);
    }];
    /*
     使用RAC将一个信号量绑定在一个属性上
     */
    RAC(self.loginBtn, enabled) = bigSignal;
}


@end
