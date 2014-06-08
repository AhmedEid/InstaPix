//
//  AEInstagramPhotosManager.m
//  InstaPix
//
//  Created by Ahmed Eid Air on 5/22/14.
//  Copyright (c) 2014 Ahmed_Eid_Inc. All rights reserved.
//

#import "AEInstagramPhotosManager.h"
#import "AEInstagramPhoto+API.h"
#import "AEInstagramPhoto.h"
#import "NSString+urls.h"

NSString* const kInstagramClientId              = @"e12e326a85174719bb4ace0e5f0a4234";
NSString* const kInstagramClientSecret          = @"ba5f46195be34617acf9dd910d15442c";
NSString* const kInstagramAPIServer             = @"https://api.instagram.com";
NSString* const kInstagramMediaSearchEndpoint   = @"/v1/media/search";
NSString* const kInstagramMediaInfoEndpoint     = @"/media/%@";

@implementation AEInstagramPhotosManager

#pragma public

-(NSString*) createServiceURLString {
    NSDictionary *params = @{
                             @"distance":@(self.preferredSearchRadius),
                             @"lat":@(self.searchOriginLocation.coordinate.latitude),
                             @"lng":@(self.searchOriginLocation.coordinate.longitude),
                             @"client_id":kInstagramClientId
                             };
    
    NSString *querystring = [NSString queryStringWithParams:params];
    
    return [NSString stringWithFormat:@"%@/%@%@",kInstagramAPIServer,kInstagramMediaSearchEndpoint,querystring];
}

#pragma private

- (void)fetchPhotosWithinCurrentLocationWithSuccessBlock:(void (^)(NSArray *photos))successBlock failureBlock:(void (^)(NSError *error))failureBlock {
    
    NSURL *url = [NSURL URLWithString:[self createServiceURLString]];
    NSMutableURLRequest *request = [NSMutableURLRequest  requestWithURL:url];
    NSLog(@"Fetching Data from instagram API for URL: %@", url);
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
                               
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                               
                               if(!error) {
                                   if(httpResponse.statusCode == 200) {
                                       
                                       NSMutableDictionary *jsonResponse = [NSMutableDictionary new];
                                       NSError *jsonParseError = nil;
                                       jsonResponse = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                       options:NSJSONReadingMutableContainers
                                                                                         error:&jsonParseError];
                                       if( jsonParseError != nil) {
                                           if (failureBlock) failureBlock(error);
                                           return ;
                                       }
                                       else {
                                           NSMutableArray *photosArray = [NSMutableArray new];
                                           
                                           NSArray *unparsedPhotosArray = jsonResponse[@"data"];
                                           //Parse photos from JSONResponse
                                           for (NSDictionary *photoDict in unparsedPhotosArray){
                                               AEInstagramPhoto *photo = [AEInstagramPhoto instagramPhotoFromJSONDictionary:photoDict];
                                               [photosArray addObject:photo];
                                           }
                                           if (successBlock) successBlock(photosArray);
                                       }
                                   }
                               }
                           }];
}

@end
