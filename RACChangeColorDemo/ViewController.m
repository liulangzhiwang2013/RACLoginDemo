//
//  ViewController.m
//  RACChangeColorDemo
//
//  Created by pxx on 2018/4/13.
//  Copyright © 2018年 平晓行. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
/*
 效果：滑动slider时，输入框值改变，同时view的颜色变化，输入框值改变时slider滑动同时view颜色变化
 */
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;

@property (weak, nonatomic) IBOutlet UITextField *redTF;
@property (weak, nonatomic) IBOutlet UITextField *greenTF;
@property (weak, nonatomic) IBOutlet UITextField *blueTF;

@property (weak, nonatomic) IBOutlet UIView *showView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RACSignal *redSignal =  [self bindSlider:_redSlider withTF:_redTF];
    RACSignal *greenSignal =  [self bindSlider:_greenSlider withTF:_greenTF];
    RACSignal *blueSignal =  [self bindSlider:_blueSlider withTF:_blueTF];
    
    RAC(self.showView,backgroundColor) = [[RACSignal combineLatest:@[redSignal , greenSignal , blueSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        return [UIColor colorWithRed:[value[0] floatValue] green:[value[1] floatValue] blue:[value[2] floatValue] alpha:1];
    }];
    
}

/*
 绑定slider和输入框
 */
- (RACSignal *)bindSlider:(UISlider *)slider withTF:(UITextField *)TF
{
    RACChannelTerminal *sliderChannel = [slider rac_newValueChannelWithNilValue:nil];
    RACChannelTerminal *tfChannel = TF.rac_newTextChannel;
    //执行一次,因为combineLatest需要合并的信号中每个至少sdnNext一次才会触发订阅
    RACSignal *oneSignal = [TF.rac_textSignal take:1];
    
    [tfChannel subscribe:sliderChannel];
    [[sliderChannel map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%.2f" , [value floatValue]];
    }] subscribe:tfChannel];
    
    //merge将多个信号合并成一个，订阅的话只有一个返回值
    return [[sliderChannel merge:tfChannel]merge:oneSignal];;
}


@end
