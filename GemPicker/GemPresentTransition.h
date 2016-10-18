//
//  GemPresentTransition.h
//  GemPickerView
//
//  Created by GemShi on 16/10/17.
//  Copyright © 2016年 GemShi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GemPresentTransition : NSObject<UIViewControllerAnimatedTransitioning>

//从底部呈现动画的时间，如果为0则不呈现动画
@property(nonatomic,assign)NSTimeInterval animationDuration;

@end
