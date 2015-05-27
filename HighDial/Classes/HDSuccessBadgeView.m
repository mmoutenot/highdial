//
//  HDSuccessBadgeView.m
//  HighDial
//
//  Created by Marshall Moutenot on 5/23/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//

#import "HDSuccessBadgeView.h"

@interface HDSuccessBadgeView ()

@property UIImageView* imageView;
@property UILabel* label;

@end

@implementation HDSuccessBadgeView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    CGSize viewSize = self.frame.size;
    
    UIImage* doneImage = [UIImage imageNamed:@"DoneIcon"];
    self.imageView = [[UIImageView alloc] initWithImage:doneImage];
    self.imageView.bounds = CGRectMake(0, 0, doneImage.size.width * 1.5, doneImage.size.height * 1.5);
    self.imageView.center = CGPointMake(viewSize.width / 2.0, viewSize.height / 2.0);
    [self addSubview:self.imageView];
    
    self.label = [[UILabel alloc] init];
    self.label.bounds = CGRectMake(0, 0, viewSize.width, 30.0);
    self.label.center = CGPointMake(viewSize.width / 2.0, self.imageView.center.y + doneImage.size.width + 10.0);
    self.label.text = @"Call logged to Salesforce!";
    self.label.font = [UIFont openSansFontOfSize:24.0];
    self.label.textColor = [HDColor colorPrimary];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
    
  }
  return self;
}

@end
