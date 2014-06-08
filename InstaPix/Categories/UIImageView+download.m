//
//  UIImageView+download.m
//  InstaPix
//
//  Created by Ahmed Eid Air on 5/22/14.
//  Copyright (c) 2014 Ahmed_Eid_Inc. All rights reserved.
//

#import "UIImageView+download.h"

@implementation UIImageView (download)

-(void) blackPlaceholder {
    UIGraphicsBeginImageContext(self.frame.size);
    [[UIColor blackColor]setFill];
    UIRectFill(self.bounds);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


-(void) downloadImageFromUrl:(NSString*)urlString {
    [self blackPlaceholder];

    static int retrycount = 0;
    if(retrycount > 2) {
        return;
    }
    
    NSURL *imageUrl = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageUrl];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *_urlresponse,
                                               NSData *responseData,
                                               NSError *error) {
         if(error == nil) {
             self.image = [UIImage imageWithData:responseData];
         }
         else {
             retrycount++;
             [self downloadImageFromUrl:urlString];
             
         }
     }];
}

@end
