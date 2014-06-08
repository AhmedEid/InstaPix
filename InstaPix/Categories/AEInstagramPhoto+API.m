//
//  AEInstagramPhoto+API.m
//  InstaPix
//
//  Created by Ahmed Eid Air on 5/22/14.
//  Copyright (c) 2014 Ahmed_Eid_Inc. All rights reserved.
//

#import "AEInstagramPhoto+API.h"
#import "NSObject+Nil.h"
@implementation AEInstagramPhoto (API)

+(AEInstagramPhoto *)instagramPhotoFromJSONDictionary:(NSDictionary *)dict {
    AEInstagramPhoto *photo = [AEInstagramPhoto new];
    photo.photoAssetType = [dict[@"type"] valueOrNil];
    photo.photoLowQualityImageURL = [dict[@"images"][@"low_resolution"][@"url"] valueOrNil];
    photo.photoThumbnailImageUrl = [dict[@"images"][@"thumbnail"][@"url"] valueOrNil];
    photo.photoStandardQualityImageURL = [dict[@"images"][@"standard_resolution"][@"url"] valueOrNil];
    photo.photoUserName = [dict[@"user"][@"username"] valueOrNil];
    photo.photoFilterName = [dict[@"filter"] valueOrNil];

    NSNumber *photoLat = [dict[@"location"][@"latitude"] valueOrNil];
    photo.photoLatitude = photoLat.floatValue;
    
    NSNumber *photoLong = [dict[@"location"][@"longitude"] valueOrNil];
    photo.photoLongitude = photoLong.floatValue;
    
    return photo;
}

@end
