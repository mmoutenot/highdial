//
//  HDRegisterNode.h
//  HighDial
//
//  Created by Marshall Moutenot on 7/22/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "HDButton.h"

@interface HDRegisterNode : ASDisplayNode

@property HDButton* continueButton;

@property UITextField* fullNameField;
@property UITextField* emailField;
@property UITextField* passwordField;

@end
