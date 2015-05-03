//
//  HDCallFlowOptionCellCollectionViewCell.m
//  HighDial
//
//  Created by Marshall Moutenot on 4/24/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//
#import <pop/pop.h>

#import "HDCallFlowOptionCell.h"
#import "HDOption.h"

static CGFloat kCallFlowOptionCellTextLabelMarginTop = 10.0;
static CGFloat kCallFlowOptionCellTextSize = 14.0;

@interface HDCallFlowOptionCell ()

@property (nonatomic) UILabel* textLabel;
@property (nonatomic) UICollectionView* collectionView;

@end

@implementation HDCallFlowOptionCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    CGSize viewSize = self.contentView.bounds.size;
    CGPoint viewCenter = self.contentView.center;
    
    _iconView = [[UIImageView alloc] init];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.iconView];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.bounds = CGRectMake(0, 0, viewSize.width, kCallFlowOptionCellTextSize * 1.25);
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont systemFontOfSize:kCallFlowOptionCellTextSize];
    [self.contentView addSubview:self.textLabel];
  }
  return self;
}

- (void)setOption:(HDOption*)option {
  _option = option;
  
  CGSize viewSize = self.contentView.bounds.size;
  CGPoint viewCenter = self.contentView.center;
  
  UIImage* image = option.icon;
  self.iconView.image = image;
  self.iconView.frame = CGRectMake(0, 0, viewSize.width, viewSize.width);
  
  self.textLabel.text = option.text;
  self.textLabel.center = CGPointMake(viewCenter.x, viewSize.height - self.textLabel.bounds.size.height / 2.0);
}

@end
