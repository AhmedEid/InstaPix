//
//  AEInstagramPhotosManager.h
//  InstaPix
//
//  Created by Ahmed Eid Air on 5/22/14.
//  Copyright (c) 2014 Ahmed_Eid_Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AEInstagramPhotosManager : NSObject

- (void)fetchPhotosWithinCurrentLocationWithSuccessBlock:(void (^)(NSArray *photos))successBlock failureBlock:(void (^)(NSError *error))failureBlock;

// The users current location
@property (nonatomic, assign) CLLocation *searchOriginLocation;

// The radius of search area
@property (nonatomic, assign) CGFloat preferredSearchRadius;

@end
