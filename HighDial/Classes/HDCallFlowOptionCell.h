//
//  HDCallFlowOptionCellCollectionViewCell.h
//  HighDial
//
//  Created by Marshall Moutenot on 4/24/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDOption;

@interface HDCallFlowOptionCell : UICollectionViewCell

@property (nonatomic) HDOption* option;
@property (nonatomic, readonly) UIImageView* iconView;

@end
