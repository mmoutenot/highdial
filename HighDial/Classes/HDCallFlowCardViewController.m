//
//  HDCallFlowCardNode.m
//  HighDial
//
//  Created by Marshall Moutenot on 4/19/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//
#import "HDCallFlowCardViewController.h"
#import "HDCallFlowOptionCell.h"
#import "HDOption.h"

static CGFloat kCardViewTitleMarginVertical = 25.0;
static CGFloat kCardViewTitleMarginHorizontal = 40.0;
static CGFloat kCardViewOptionMaxPerRow = 5.0;
static NSString* kCardViewOptionCellIdentifier = @"HDCallFlowOptionCell";

@interface HDCallFlowCardViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) NSString* key;
@property (nonatomic) NSArray* options;
@property (nonatomic) UILabel* titleLabel;
@property (nonatomic) UICollectionView* optionCollectionView;
@property (nonatomic) NSObject<HDCardHandlerDelegate>* delegate;

@end

@implementation HDCallFlowCardViewController

- (instancetype)initWithFrame:(CGRect)frame key:(NSString*)key title:(NSString*)title options:(NSArray*)options delegate:(NSObject<HDCardHandlerDelegate>*)delegate {
  self = [super init];
  if (self) {
    _key = key;
    _options = options;
    _delegate = delegate;
    
    self.view.frame = frame;
    CGSize viewSize = self.view.frame.size;
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect titleLabelFrame = {kCardViewTitleMarginHorizontal, kCardViewTitleMarginVertical, viewSize.width - kCardViewTitleMarginHorizontal * 2, 50.0};
    self.titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
    self.titleLabel.text = title;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self.view addSubview:self.titleLabel];
    
    UICollectionViewFlowLayout* optionCollectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat optionItemWidth = viewSize.width;
    CGFloat optionItemHeight = 80;
    CGSize optionItemSize = { optionItemWidth, optionItemHeight };
    optionCollectionFlowLayout.itemSize = optionItemSize;
    optionCollectionFlowLayout.minimumInteritemSpacing = 0.0;
    optionCollectionFlowLayout.minimumLineSpacing = 20.0;
    
    CGFloat optionCollectionY = titleLabelFrame.origin.y + titleLabelFrame.size.height;
    CGRect optionCollectionFrame = { 0, optionCollectionY, viewSize.width, viewSize.height - optionCollectionY - 20.0 };
    self.optionCollectionView = [[UICollectionView alloc] initWithFrame:optionCollectionFrame collectionViewLayout:optionCollectionFlowLayout];
    self.optionCollectionView.delegate = self;
    self.optionCollectionView.dataSource = self;
    self.optionCollectionView.backgroundColor = [UIColor clearColor];
    [self.optionCollectionView registerClass:[HDCallFlowOptionCell class] forCellWithReuseIdentifier:kCardViewOptionCellIdentifier];
    [self.view addSubview:self.optionCollectionView];
  }
  return self;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.options.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
  HDCallFlowOptionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCardViewOptionCellIdentifier forIndexPath:indexPath];
  cell.option = self.options[indexPath.item];
  return cell;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath {
  HDOption* option = self.options[indexPath.item];
  [self.delegate optionSelected:option forKey:self.key];
}

#pragma mark - Actions

- (void)cellOptionPressed {
}

@end
