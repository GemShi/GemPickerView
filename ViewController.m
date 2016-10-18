//
//  ViewController.m
//  GemPickerView
//
//  Created by GemShi on 16/10/14.
//  Copyright © 2016年 GemShi. All rights reserved.
//

#import "ViewController.h"
#import "GemPickerViewController.h"

@interface ViewController ()<UITextFieldDelegate,GemPickerViewControllerDelegate>

@end

@implementation ViewController
{
    UITextField *_textField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createLayout
{
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 30)];
    _textField.delegate = self;
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.placeholder = @"点选";
    [self.view addSubview:_textField];
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 200, 100, 100)];
//    view.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:view];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    /** 需要将gpvc中控件的动态弹出效果写在viewDidAppear中
     *  1.避免写在completion中选中框的线颜色为nil
     *  2.如果写在之前，animationWithDuration方法没有效果，[UIView animationWithDuration]在viewDidLoad之后出现效果
     */
    GemPickerViewController *gpvc = [[GemPickerViewController alloc]init];
    gpvc.delegate = self;
    [self presentViewController:gpvc animated:YES completion:nil];
//    gpvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;//设置弹出的controller为透明
    return NO;
}

#pragma mark - 代理方法
-(void)addressPickerViewControllerChooseProvince:(NSString *)province City:(NSString *)city District:(NSString *)district
{
    _textField.text = [NSString stringWithFormat:@"%@-%@-%@",province,city,district];
}

@end
