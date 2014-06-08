//
//  AEAppDelegate.m
//  InstaPix
//
//  Created by Ahmed Eid Air on 5/22/14.
//  Copyright (c) 2014 Ahmed_Eid_Inc. All rights reserved.
//

#import "AEAppDelegate.h"
#import "AEMainMapViewController.h"

@implementation AEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    AEMainMapViewController *mainViewController = [AEMainMapViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    self.window.rootViewController = navigationController;
    return YES;
}

@end
