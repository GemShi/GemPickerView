//
//  GemPickerViewController.m
//  GemPickerView
//
//  Created by GemShi on 16/10/14.
//  Copyright © 2016年 GemShi. All rights reserved.
//

#import "GemPickerViewController.h"
#import "GemPresentTransition.h"

@interface GemPickerViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UIViewControllerTransitioningDelegate>
@property(nonatomic)GemPresentTransition *presentTransition;
@property(nonatomic,strong)NSMutableArray *dataArray;//plist文件读取的数据
@property(nonatomic,strong)UIPickerView *addressPicker;//地址选择器
@property(nonatomic,strong)NSMutableArray *provinceArray;//省数组
@property(nonatomic,strong)NSMutableDictionary *cityDict;//市字典
@property(nonatomic,strong)NSMutableDictionary *districtDict;//区字典
@property(nonatomic,copy)NSString *keyProvince;//通过省选择市的键
@property(nonatomic,copy)NSString *keyCity;//通过市选择区的键
@property(nonatomic,copy)NSString *provinceStr;//待传参数省
@property(nonatomic,copy)NSString *cityStr;//待传参数市
@property(nonatomic,copy)NSString *districtStr;//待传参数区
@end

@implementation GemPickerViewController
{
    UIView *_animView;
}

#pragma mark - 懒加载
-(UIPickerView *)addressPicker
{
    if (!_addressPicker) {
        _addressPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 160)];
        _addressPicker.delegate = self;
        _addressPicker.dataSource = self;
        _addressPicker.backgroundColor = [UIColor whiteColor];
        [_animView addSubview:_addressPicker];
        [_addressPicker reloadAllComponents];
    }
    return _addressPicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self createLayout];
    [self addressPicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        _animView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 200, [UIScreen mainScreen].bounds.size.width, 200);
    }];
}

-(void)initData
{
    self.provinceArray = [[NSMutableArray alloc]init];
    self.cityDict = [[NSMutableDictionary alloc]init];
    self.districtDict = [[NSMutableDictionary alloc]init];
    self.keyProvince = @"";
    self.keyCity = @"";
    self.provinceStr = @"北京";
    self.cityStr = @"北京市";
    self.districtStr = @"东城区";
    
    NSString *projectPath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:projectPath];
    self.dataArray = [[NSMutableArray alloc]initWithArray:dict[@"address"]];
    //数据解析
    for (NSDictionary *dict in _dataArray) {
        [self.provinceArray addObject:dict[@"name"]];
        NSMutableArray *cityArray = [[NSMutableArray alloc]init];
        for (NSDictionary *subDict in dict[@"sub"]) {
            [cityArray addObject:subDict[@"name"]];
            NSArray *array = [NSArray arrayWithArray:subDict[@"sub"]];
            if (array.count == 0) {
                [self.districtDict setObject:@[@""] forKey:subDict[@"name"]];
            }else{
                [self.districtDict setObject:subDict[@"sub"] forKey:subDict[@"name"]];
            }
        }
        [self.cityDict setObject:cityArray forKey:dict[@"name"]];
    }
    _presentTransition = [[GemPresentTransition alloc]init];
    _presentTransition.animationDuration = 0;
    self.transitioningDelegate = self;
}

-(void)createLayout
{
    self.view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapGR];
    _animView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200)];
    _animView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    [self.view addSubview:_animView];
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(8, 0, 70, 40)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:0.17 green:0.74 blue:0.61 alpha:1.00] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [_animView addSubview:cancelButton];
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 78, 0, 70, 40)];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor colorWithRed:0.17 green:0.74 blue:0.61 alpha:1.00] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [_animView addSubview:confirmButton];
}

//单击手势
-(void)tap:(UITapGestureRecognizer *)tapGR
{
    [self cancelClick];
}

//确定
-(void)confirmClick
{
    [self.delegate addressPickerViewControllerChooseProvince:_provinceStr City:_cityStr District:_districtStr];
    [self cancelClick];
}

//取消
-(void)cancelClick
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return _presentTransition;
}

#pragma mark - 代理方法
//返回列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
//返回行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return _provinceArray.count;
            break;
        case 1:
            if ([_keyProvince isEqualToString:@""]) {
                _keyProvince = @"北京";
            }
            return [_cityDict[_keyProvince] count];
            break;
        case 2:
            if ([_keyCity isEqualToString:@""]) {
                _keyCity = @"北京市";
            }
            return [_districtDict[_keyCity] count];
            break;
        default:
            return 0;
            break;
    }
}
//行高
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}
//列宽
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [UIScreen mainScreen].bounds.size.width / 3;
}
//内容显示代理方法
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (!view) {
        view = [[UIView alloc]init];
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 3, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    [view addSubview:label];
    switch (component) {
        case 0:
            label.text = [NSString stringWithFormat:@"%@",[_provinceArray objectAtIndex:row]];
            break;
        case 1:
            label.text = [NSString stringWithFormat:@"%@",[_cityDict[_keyProvince] objectAtIndex:row]];
            break;
        case 2:
            label.text = [NSString stringWithFormat:@"%@",[_districtDict[_keyCity] objectAtIndex:row]];
            break;
        default:
            break;
    }
    return view;
}
//滚动选择方法
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            self.keyProvince = [_provinceArray objectAtIndex:row];
            [_addressPicker reloadComponent:1];
            [_addressPicker selectRow:0 inComponent:1 animated:YES];
            self.keyCity = [_cityDict[_keyProvince] objectAtIndex:0];
            [_addressPicker reloadComponent:2];
            [_addressPicker selectRow:0 inComponent:2 animated:YES];
            _provinceStr = [_provinceArray objectAtIndex:row];
            _cityStr = [_cityDict[_keyProvince] objectAtIndex:0];
            _districtStr = [_districtDict[_keyCity] objectAtIndex:0];
            break;
        case 1:
            self.keyCity = [_cityDict[_keyProvince] objectAtIndex:row];
            [_addressPicker reloadComponent:2];
            [_addressPicker selectRow:0 inComponent:2 animated:YES];
            _cityStr = [_cityDict[_keyProvince] objectAtIndex:row];
            _districtStr = [_districtDict[_keyCity] objectAtIndex:0];
            break;
        case 2:
            _districtStr = [_districtDict[_keyCity] objectAtIndex:row];
            break;
        default:
            break;
    }
}

@end
