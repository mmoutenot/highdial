//
//  Created by Marshall Moutenot on 6/14/14.
//  Copyright (c) 2014 futurephone. All rights reserved.
//

#import "HDDismissingAnimator.h"
#import <POP/POP.h>

@implementation HDDismissingAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
  return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
  UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  toVC.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
  toVC.view.userInteractionEnabled = YES;

  UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

  __block UIView *dimmingView;
  [toVC.view.subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL* stop) {
      if (view.layer.opacity < 1.f) {
          dimmingView = view;
          *stop = YES;
      }
  }];
  POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
  opacityAnimation.toValue = @(0.0);
  [opacityAnimation setCompletionBlock:^(POPAnimation* anim, BOOL finished) {
    [dimmingView removeFromSuperview];
  }];
  [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];

  POPBasicAnimation *offscreenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
  offscreenAnimation.toValue = @(-fromVC.view.layer.position.y);
  [offscreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
      [transitionContext completeTransition:YES];
  }];
  [fromVC.view.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];
}

@end
