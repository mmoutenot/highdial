//
//  HDCardFlowHeaderView.h
//  HighDial
//
//  Created by Marshall Moutenot on 4/24/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDCallFlowHeaderView : UIView

@property (nonatomic, readonly) UIButton* cancelButton;
@property (nonatomic, readonly) UIButton* doneButton;

- (instancetype)initWithFrame:(CGRect)frame callDuration:(NSString*)callDuration;

@end
