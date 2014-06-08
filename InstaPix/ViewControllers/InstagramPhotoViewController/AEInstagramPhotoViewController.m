//
//  InstagramPhotoViewController.m
//  InstaPix
//
//  Created by Ahmed Eid Air on 5/27/14.
//  Copyright (c) 2014 Ahmed_Eid_Inc. All rights reserved.
//

#import "AEInstagramPhotoViewController.h"
#import "UIImageView+download.h"

@interface AEInstagramPhotoViewController ()

//Views
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *photoUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoFilterLabel;

//Data
@property (nonatomic, strong) AEInstagramPhoto *photo;
@end

@implementation AEInstagramPhotoViewController

- (id)initWithInstagramPhoto:(AEInstagramPhoto *)photo {
    self = [super init];
    if (self) {
        self.photo = photo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.photoImageView downloadImageFromUrl:self.photo.photoStandardQualityImageURL];
    self.photoUserNameLabel.text = self.photo.photoUserName;
    self.photoFilterLabel.text = [NSString stringWithFormat:@"Filter: %@", self.photo.photoFilterName];
}

@end
