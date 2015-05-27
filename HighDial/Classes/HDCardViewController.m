//
//  HDCardViewController.m
//  
//
//  Created by Marshall Moutenot on 5/23/15.
//
//
#import "HDCardViewController.h"

static CGFloat kCardViewTitleMarginVertical = 25.0;
static CGFloat kCardViewTitleMarginHorizontal = 40.0;

@interface HDCardViewController ()

@end

@implementation HDCardViewController

- (instancetype)initWithFrame:(CGRect)frame key:(NSString*)key title:(NSString*)title delegate:(NSObject<HDCardHandlerDelegate>*)delegate {
  self = [super init];
  if (self) {
    _key = key;
    _delegate = delegate;
    
    self.view.frame = frame;
    CGSize viewSize = self.view.frame.size;
    self.view.backgroundColor = [HDColor whiteColor];
    self.view.layer.cornerRadius = 4.0;
    self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.view.layer.borderWidth = 1.0;
    
    CGRect titleLabelFrame = {kCardViewTitleMarginHorizontal, kCardViewTitleMarginVertical, viewSize.width - kCardViewTitleMarginHorizontal * 2, 50.0};
    self.titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
    self.titleLabel.text = title;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self.view addSubview:self.titleLabel];
  }
  return self;
  
}

- (void)blur {
  
}

@end
