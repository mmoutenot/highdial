//
//  HDCallFlowNoteCardViewController.h
//  HighDial
//
//  Created by Marshall Moutenot on 5/23/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//

#import "HDOptionsCardViewController.h"

FOUNDATION_EXPORT const CGFloat kNotesCardMarginBotton;

@interface HDCallFlowNoteCardViewController : HDCardViewController

@property (nonatomic) UITextView* textView;
@property (nonatomic) UIButton* submitButton;

- (instancetype)initWithFrame:(CGRect)frame key:(NSString *)key title:(NSString *)title delegate:(NSObject<HDCardHandlerDelegate> *)delegate;

@end
