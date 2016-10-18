//
//  GemPickerViewController.h
//  GemPickerView
//
//  Created by GemShi on 16/10/14.
//  Copyright © 2016年 GemShi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GemPickerViewControllerDelegate <NSObject>

@required
/**传参代理方法*/
-(void)addressPickerViewControllerChooseProvince:(NSString *)province City:(NSString *)city District:(NSString *)district;

@end

@interface GemPickerViewController : UIViewController
/**GemPickerViewController代理方法*/
@property(nonatomic,weak)id<GemPickerViewControllerDelegate>delegate;
@end
