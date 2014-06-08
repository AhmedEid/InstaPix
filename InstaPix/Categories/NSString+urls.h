//
//  NSString+urls.h
//  InstaPix
//
//  Created by Ahmed Eid Air on 5/22/14.
//  Copyright (c) 2014 Ahmed_Eid_Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (urls)

+(NSString*) queryStringWithParams:(NSDictionary*) params;

@end
