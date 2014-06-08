//
//  AEInstagramPhoto.h
//  InstaPix
//
//  Created by Ahmed Eid Air on 5/22/14.
//  Copyright (c) 2014 Ahmed_Eid_Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AEInstagramPhoto : NSObject

@property (readwrite, assign) CGFloat photoLatitude;
@property (readwrite, assign) CGFloat photoLongitude;
@property (nonatomic, assign) CLLocationDistance distanceFromCurrentPoint;
@property (nonatomic,retain) NSString *photoThumbnailImageUrl;
@property (nonatomic,retain) NSString *photoLowQualityImageURL;
@property (nonatomic,retain) NSString *photoStandardQualityImageURL;
@property (nonatomic,retain) NSString *photoFilterName;
@property (nonatomic,retain) NSString *photoUserName;
@property (nonatomic,retain) NSString *photoAssetType;
@property (nonatomic,retain) NSString *photoCaption;

@end
