//
//  AEInstagramPhoto+API.h
//  InstaPix
//
//  Created by Ahmed Eid Air on 5/22/14.
//  Copyright (c) 2014 Ahmed_Eid_Inc. All rights reserved.
//

#import "AEInstagramPhoto.h"

@interface AEInstagramPhoto (API)

//Parses JSON dictionary returned from Instagram API and returned an AEInstagramPhoto
+(AEInstagramPhoto *)instagramPhotoFromJSONDictionary:(NSDictionary *)dict;

@end
