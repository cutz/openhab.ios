//
//  OpenHABAppDelegate.m
//  openHAB
//
//  Created by Victor Belov on 12/01/14.
//  Copyright (c) 2014 Victor Belov. All rights reserved.
//

#import "OpenHABAppDelegate.h"
#import "Crittercism.h"
#import "GAI.h"
#import "AFNetworking.h"
#import "NSData+HexString.h"
@implementation OpenHABAppDelegate
@synthesize appData;

- (id)init
{
    self.appData = [[OpenHABDataObject alloc] init];
    return [super init];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions started");
    // Override point for customization after application launch.
    [Crittercism enableWithAppID: @"5134a8a08e54584a75000015"];
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-49587640-1"];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.operationQueue.maxConcurrentOperationCount = 50;
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"CacheDataAgressively"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    [self loadSettingsDefaults];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    NSLog(@"uniq id %@", [UIDevice currentDevice].identifierForVendor.UUIDString);
    NSLog(@"device name %@", [UIDevice currentDevice].name);
    NSLog(@"didFinishLaunchingWithOptions ended");
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", [deviceToken hexString]);
    NSDictionary *dataDict = @{
                               @"deviceToken": [deviceToken hexString],
                               @"deviceId": [UIDevice currentDevice].identifierForVendor.UUIDString,
                               @"deviceName": [UIDevice currentDevice].name,
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"apsRegistered" object:self userInfo:dataDict];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)loadSettingsDefaults
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (![prefs boolForKey:@"initialized"]) {
        NSLog(@"Loading default settings");
        [prefs setValue:@"" forKey:@"localUrl"];
        [prefs setValue:@"" forKey:@"remoteUrl"];
        [prefs setValue:@"" forKey:@"username"];
        [prefs setValue:@"" forKey:@"password"];
        [prefs setBool:NO forKey:@"ignoreSSL"];
        [prefs setBool:YES forKey:@"demomode"];
        [prefs setBool:YES forKey:@"initialized"];
    }
}

@end