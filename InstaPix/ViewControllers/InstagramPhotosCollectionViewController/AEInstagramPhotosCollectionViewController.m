//
//  InstagramPhotosCollectionViewController.m
//  InstaPix
//
//  Created by Ahmed Eid Air on 5/22/14.
//  Copyright (c) 2014 Ahmed_Eid_Inc. All rights reserved.
//

#import "AEInstagramPhotosCollectionViewController.h"
#import "AEInstagramPhotoViewController.h"
#import "AEInstagramPhotoCollectionViewCell.h"
#import "UIImageView+download.h"
#import "AEInstagramPhoto.h"

#define collectionViewSidePadding   8

@interface AEInstagramPhotosCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

//Views
@property (nonatomic, strong) UICollectionView *collectionView;

//Data
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, assign) int tappedPhotoIndex;

@end

@implementation AEInstagramPhotosCollectionViewController

- (id)initWithPhotos:(NSArray *)photos tappedPhotoIndex:(int)index {
    self = [super init];
    if (self) {
        self.photos = photos;
        self.tappedPhotoIndex = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumInteritemSpacing = 8;
    flowLayout.itemSize = CGSizeMake(96, 156);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(collectionViewSidePadding, collectionViewSidePadding, self.view.bounds.size.width - 2*collectionViewSidePadding, self.view.bounds.size.height - 2*collectionViewSidePadding) collectionViewLayout:flowLayout];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"AEInstagramPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AEInstagramPhotoCollectionViewCell"];
}

#pragma mark - UICollectionView Datasource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(96, 156);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AEInstagramPhotoCollectionViewCell";
    
    AEInstagramPhotoCollectionViewCell *cell = (AEInstagramPhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    AEInstagramPhoto *photo = self.photos[indexPath.row];
    cell.usernameLabel.text = photo.photoUserName;
    
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.2f km",
                               photo.distanceFromCurrentPoint];
    [cell.imageView downloadImageFromUrl:photo.photoLowQualityImageURL];
    return cell;
}

#pragma mark = UICollectionViewDelegate 

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AEInstagramPhoto *photo = self.photos[indexPath.row];
    AEInstagramPhotoViewController *viewController = [[AEInstagramPhotoViewController alloc] initWithInstagramPhoto:photo];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
