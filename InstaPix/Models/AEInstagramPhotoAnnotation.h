//
//  AEInstagramPhotoAnnotation.h
//  InstaPix
//
//  Created by Ahmed Eid Air on 5/22/14.
//  Copyright (c) 2014 Ahmed_Eid_Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AEInstagramPhoto.h"

@interface AEInstagramPhotoAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) AEInstagramPhoto *instagramPhoto;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

-(id)initWithLocation:(CLLocationCoordinate2D)coord;

@end
