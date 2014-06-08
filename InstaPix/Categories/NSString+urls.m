//
//  NSString+urls.m
//  InstaPix
//
//  Created by Ahmed Eid Air on 5/22/14.
//  Copyright (c) 2014 Ahmed_Eid_Inc. All rights reserved.
//


#import "NSString+urls.h"

@implementation NSString (urls)

+(NSString*) queryStringWithParams:(NSDictionary*) params {
    if(!params) {
        return nil;
    }
    
    if([params allKeys].count > 0) {
        NSMutableString *parameterstring=[NSMutableString stringWithString:@"?"];
        
        [[params allKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [parameterstring appendString:[NSString stringWithFormat:@"%@=%@",obj,params[obj]]];
            
            if( idx < [params allKeys].count - 1) {
                [parameterstring appendString:@"&"];
            }
        }];
        return [parameterstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end