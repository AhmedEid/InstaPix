//
//  NSObject+HuffPost.h
//  InstaPix
//
//  Created by Ahmed Eid Air on 5/22/14.
//  Copyright (c) 2014 Ahmed_Eid_Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSObject (HuffPost)

/*! If NSNull, return nil */
- (id)valueOrNil;

/*! If nil, return NSNull */
+ (id)valueOrNSNull:(id)object;

@end
