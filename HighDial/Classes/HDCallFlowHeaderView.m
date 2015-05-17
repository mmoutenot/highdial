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
    self.backgroundColor = [HDColor colorPrimary];
    
    CGFloat titleSize = 18.0;
    CGRect titleLabelBounds = { 0, 0, frame.size.width, titleSize * 1.25 };
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.bounds = titleLabelBounds;
    self.titleLabel.center = self.center;
    self.titleLabel.text = @"Log Call";
    self.titleLabel.font = [UIFont openSansFontOfSize:titleSize];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    CGFloat durationLabelSize = 10.0;
    CGRect durationLabelBounds = { 0, 0, frame.size.width, durationLabelSize * 1.25 };
    self.callDurationLabel = [[UILabel alloc] init];
    self.callDurationLabel.bounds = durationLabelBounds;
    self.callDurationLabel.center = CGPointMake(self.titleLabel.center.x, self.titleLabel.center.y + titleLabelBounds.size.height);
    self.callDurationLabel.text = callDuration;
    self.callDurationLabel.font = [UIFont openSansFontOfSize:durationLabelSize];
    self.callDurationLabel.textColor = [UIColor whiteColor];
    self.callDurationLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.callDurationLabel];
    
    CGSize callButtonSize = CGSizeMake(30.0, 30.0);
    _cancelButton = [[UIButton alloc] init];
    self.cancelButton.bounds = CGRectMake(0, 0, callButtonSize.width, callButtonSize.height);
    self.cancelButton.center = CGPointMake(10.0 + callButtonSize.width / 2.0, 5.0 + self.center.y);
    [self.cancelButton setImage:[UIImage imageNamed:@"CancelIcon"] forState:UIControlStateNormal];
    [self addSubview:self.cancelButton];
    
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
