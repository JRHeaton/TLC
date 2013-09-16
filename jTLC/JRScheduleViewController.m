//
//  JRScheduleViewController.m
//  jTLC
//
//  Created by John Heaton on 9/16/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRScheduleViewController.h"

@interface JRScheduleViewController () {
    UICollectionViewFlowLayout *layout;
}

@end

@implementation JRScheduleViewController

- (id)init {
    if(self = [super initWithCollectionViewLayout:[UICollectionViewFlowLayout new]]) {
        [self.collectionView registerNib:[UINib nibWithNibName:@"DayView" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
        self.title = @"Schedule";
        layout = self.collectionViewLayout;
        
        layout.sectionInset = UIEdgeInsetsMake(20, 10, 10, 20);
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSLog(@"%@", cell);
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(140, 140);
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

@end
