//
//  HDCardFlowHeaderView.m
//  HighDial
//
//  Created by Marshall Moutenot on 4/24/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//

#import "HDCallFlowHeaderView.h"

@interface HDCallFlowHeaderView ()

@property (nonatomic) UILabel* titleLabel;
@property (nonatomic) UILabel* callDurationLabel;

@end

@implementation HDCallFlowHeaderView

- (instancetype)initWithFrame:(CGRect)frame callDuration:(NSString*)callDuration {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor blueColor];
    
    CGFloat titleSize = 18.0;
    CGRect titleLabelBounds = { 0, 0, frame.size.width, titleSize * 1.25 };
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.bounds = titleLabelBounds;
    self.titleLabel.center = self.center;
    self.titleLabel.text = @"Log Call";
    self.titleLabel.font = [UIFont fontWithName:@"Avenir" size:titleSize];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    CGFloat durationLabelSize = 10.0;
    CGRect durationLabelBounds = { 0, 0, frame.size.width, durationLabelSize * 1.25 };
    self.callDurationLabel = [[UILabel alloc] init];
    self.callDurationLabel.bounds = durationLabelBounds;
    self.callDurationLabel.center = CGPointMake(self.titleLabel.center.x, self.titleLabel.center.y + titleLabelBounds.size.height);
    self.callDurationLabel.text = callDuration;
    self.callDurationLabel.font = [UIFont fontWithName:@"Avenir" size:durationLabelSize];
    self.callDurationLabel.textColor = [UIColor whiteColor];
    self.callDurationLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.callDurationLabel];
    
  }
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
