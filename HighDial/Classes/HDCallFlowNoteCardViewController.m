//
//  HDCallFlowNoteCardViewController.m
//  HighDial
//
//  Created by Marshall Moutenot on 5/23/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "HDCallFlowNoteCardViewController.h"

const CGFloat kNotesCardMarginBotton = 128.0;
static const CGFloat kNotesTextViewPadding = 17.0;


@interface HDCallFlowNoteCardViewController ()

@property CGSize originalSize;

@end

@implementation HDCallFlowNoteCardViewController

- (instancetype)initWithFrame:(CGRect)frame key:(NSString*)key title:(NSString*)title delegate:(NSObject<HDCardHandlerDelegate>*)delegate {
  self = [super initWithFrame:frame key:key title:title delegate:delegate];
  if (self) {
    CGSize viewSize = self.view.frame.size;
    self.originalSize = viewSize;
    
    CGRect titleLabelFrame = self.titleLabel.frame;
    
    CGPoint textViewOrigin = CGPointMake(0, titleLabelFrame.origin.y + titleLabelFrame.size.height);
    CGRect textViewFrame = CGRectMake(textViewOrigin.x, textViewOrigin.y, viewSize.width, viewSize.height - textViewOrigin.y);
    textViewFrame = CGRectInset(textViewFrame, kNotesTextViewPadding, 0);
    self.textView = [[UITextView alloc] initWithFrame:textViewFrame];
    self.textView.font = [UIFont openSansFontOfSize:16.0];
    [self.view addSubview:self.textView];
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]
    subscribeNext:^(NSNotification* notification) {
      [self keyboardDidChange:notification];
    }];
  [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil]
    subscribeNext:^(NSNotification* notification) {
      [self keyboardDidHide:notification];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:self.view.window];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:self.view.window];
}

- (void)blur{
  [self.delegate notesAdded:self.textView.text];
  [self.textView resignFirstResponder];
}

#pragma mark - Keyboard Appearance

- (void)keyboardDidChange:(NSNotification*)notification {
  CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  CGSize viewSize = self.view.frame.size;
  CGPoint viewOrigin = self.view.frame.origin;
  CGFloat height = CGRectGetHeight(keyboardFrame);
  self.view.frame = CGRectMake(viewOrigin.x, viewOrigin.y, viewSize.width, viewSize.height - height);
  
  viewSize = self.view.frame.size;
  CGRect titleLabelFrame = self.titleLabel.frame;
  CGPoint textViewOrigin = CGPointMake(0, titleLabelFrame.origin.y + titleLabelFrame.size.height);
  CGRect textViewFrame = CGRectMake(textViewOrigin.x, textViewOrigin.y, viewSize.width, viewSize.height - textViewOrigin.y);
  textViewFrame = CGRectInset(textViewFrame, kNotesTextViewPadding, 0);
  self.textView.frame = textViewFrame;
}

- (void)keyboardDidHide:(NSNotification*)notification {
  CGPoint viewOrigin = self.view.frame.origin;
  self.view.frame = CGRectMake(viewOrigin.x, viewOrigin.y + 25.0, self.originalSize.width, self.originalSize.height);
}


@end
