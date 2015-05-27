//
//  HDCardViewController.h
//  
//
//  Created by Marshall Moutenot on 5/23/15.
//
//

@class HDOption;

@protocol HDCardHandlerDelegate <NSObject>

- (void)optionSelected:(HDOption*)option forKey:(NSString*)key;
- (void)notesAdded:(NSString*)notes;

@end


@interface HDCardViewController : UIViewController

@property (nonatomic) NSString* key;
@property (nonatomic) UILabel* titleLabel;
@property (nonatomic) NSObject<HDCardHandlerDelegate>* delegate;

- (instancetype)initWithFrame:(CGRect)frame key:(NSString*)key title:(NSString*)title delegate:(NSObject<HDCardHandlerDelegate>*)delegate;
- (void)blur;

@end
