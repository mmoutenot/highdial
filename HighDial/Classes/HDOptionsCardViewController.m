//
//  HDCallFlowCardNode.m
//  HighDial
//
//  Created by Marshall Moutenot on 4/19/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//
#import "HDOptionsCardViewController.h"
#import "HDCallFlowOptionCell.h"
#import "HDOption.h"

static NSString* kCardViewOptionCellIdentifier = @"HDCallFlowOptionCell";

@interface HDOptionsCardViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) NSArray* options;
@property (nonatomic) UICollectionView* optionCollectionView;

@end

@implementation HDOptionsCardViewController

- (instancetype)initWithFrame:(CGRect)frame key:(NSString*)key title:(NSString*)title options:(NSArray*)options delegate:(NSObject<HDCardHandlerDelegate>*)delegate {
  self = [super initWithFrame:frame key:key title:title delegate:delegate];
  if (self) {
    _options = options;
    
    CGSize viewSize = self.view.bounds.size;
    
    UICollectionViewFlowLayout* optionCollectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat optionItemWidth = viewSize.width;
    CGFloat optionItemHeight = 80;
    CGSize optionItemSize = { optionItemWidth, optionItemHeight };
    optionCollectionFlowLayout.itemSize = optionItemSize;
    optionCollectionFlowLayout.minimumInteritemSpacing = 0.0;
    optionCollectionFlowLayout.minimumLineSpacing = 20.0;
    
    CGRect titleLabelFrame = self.titleLabel.frame;
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
  [self.view removeFromSuperview];
  [self removeFromParentViewController];
}

#pragma mark - Actions

- (void)cellOptionPressed {
}

@end
