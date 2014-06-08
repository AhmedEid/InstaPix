//
//  AEInstagramPhotoAnnotation.m
//  InstaPix
//
//  Created by Ahmed Eid Air on 5/22/14.
//  Copyright (c) 2014 Ahmed_Eid_Inc. All rights reserved.
//

#import "AEInstagramPhotoAnnotation.h"

@implementation AEInstagramPhotoAnnotation

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    
    self = [super init];
    if (self) {
        _coordinate = coord;
    }
    return self;
}
@end
