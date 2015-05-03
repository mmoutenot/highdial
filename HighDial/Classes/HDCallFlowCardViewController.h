//
//  HDCallFlowCardNode.h
//  HighDial
//
//  Created by Marshall Moutenot on 4/19/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//

@class HDOption;

@protocol HDCardHandlerDelegate <NSObject>

- (void)optionSelected:(HDOption*)option forKey:(NSString*)key;

@end

@interface HDCallFlowCardViewController : UIViewController

- (instancetype)initWithFrame:(CGRect)frame key:(NSString*)key title:(NSString*)title options:(NSArray*)options delegate:(NSObject<UIViewControllerTransitioningDelegate>*)delegate;
  
@end
