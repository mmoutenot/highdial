//
//  Created by Marshall Moutenot on 6/14/14.
//  Copyright (c) 2014 futurephone. All rights reserved.
//

#import "HDPresentingAnimator.h"
#import <POP/POP.h>

@implementation HDPresentingAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
  return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
  UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
  fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
  fromView.userInteractionEnabled = NO;

  UIView *dimmingView = [[UIView alloc] initWithFrame:fromView.bounds];
  dimmingView.backgroundColor = [UIColor blackColor];
  dimmingView.layer.opacity = 0.0;

  UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;

  [fromView addSubview:dimmingView];
  [transitionContext.containerView addSubview:toView];

  POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
  positionAnimation.fromValue = @(toView.center.y + toView.frame.size.height / 2.0);
  positionAnimation.springBounciness = 12;
  [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
      [transitionContext completeTransition:YES];
  }];

  POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
  scaleAnimation.springBounciness = 20;
  scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.2, 1.4)];

  POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
  opacityAnimation.toValue = @(0.4);

  [toView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
  [toView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
  [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

@end
