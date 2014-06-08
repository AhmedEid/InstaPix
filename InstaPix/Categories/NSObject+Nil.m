//
//  NSObject+HuffPost.m
//  InstaPix
//
//  Created by Ahmed Eid Air on 5/22/14.
//  Copyright (c) 2014 Ahmed_Eid_Inc. All rights reserved.
//

#import "NSObject+Nil.h"

@implementation NSObject (HuffPost)

- (id)valueOrNil {
    if ([self isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return self;
}

+ (id)valueOrNSNull:(id)object {
    if (!object) {
        return [NSNull null];
    }
    else {
        return object;
    }
}

@end
