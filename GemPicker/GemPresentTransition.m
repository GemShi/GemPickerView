//
//  GemPresentTransition.m
//  GemPickerView
//
//  Created by GemShi on 16/10/17.
//  Copyright © 2016年 GemShi. All rights reserved.
//

#import "GemPresentTransition.h"

@implementation GemPresentTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return _animationDuration;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [fromVC.view removeFromSuperview];
    fromView = [fromView snapshotViewAfterScreenUpdates:YES];
    UIView *contanierView = [transitionContext containerView];
    [contanierView addSubview:fromView];
    [contanierView addSubview:toView];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    toView.frame = CGRectOffset(finalFrame, 0, finalFrame.size.height);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toView.frame = finalFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
