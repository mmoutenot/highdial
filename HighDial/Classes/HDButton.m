//
//  HDButton.m
//  HighDial
//
//  Created by Marshall Moutenot on 7/22/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//
#import <Pop/Pop.h>

#import "HDButton.h"

@implementation HDButton

- (instancetype)init {
  self = [super init];
  if (self) {
    [self addTarget:self action:@selector(scaleToSmall) forControlEvents:ASControlNodeEventTouchDown | ASControlNodeEventTouchDragInside];
    [self addTarget:self action:@selector(scaleAnimation) forControlEvents:ASControlNodeEventTouchUpInside];
    [self addTarget:self action:@selector(scaleToDefault) forControlEvents:ASControlNodeEventTouchDragOutside];
    self.cornerRadius = 5.0;
  }
  return self;
}

- (void)scaleToSmall {
	POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
	scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.95f, 0.95f)];
	[self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
}

- (void)scaleAnimation {
	POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
	scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
	scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
	scaleAnimation.springBounciness = 18.0f;
	[self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}

- (void)scaleToDefault {
	POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
	scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
	[self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleDefaultAnimation"];
}

@end
