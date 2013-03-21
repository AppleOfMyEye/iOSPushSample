//
//  KiiAppDelegate.m
//  KiiPushSample
//
//  Created by Riza Alaudin Syah on 1/30/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import "KiiAppDelegate.h"
#import <KiiSDK/Kii.h>
@implementation KiiAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Kii beginWithID:@"b58eee48"
              andKey:@"c5abe20b006c3883e1151eb80a2f979c"
             andSite:kiiSiteJP];
//    [self apnsAuth];
//    [self testSendExpicitPush];
    //[Kii enableAPNSWithDevelopmentMode:YES andNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    // Override point for customization after application launch.
    return YES;
}
- (void) auth {
    
    NSString *username = [NSString stringWithFormat:@"test%d", (int)round([[NSDate date] timeIntervalSince1970])];
   
    
    KiiError *err;
    KiiUser *user = [KiiUser userWithUsername:username andPassword:@"kii12345"];
    [user performRegistrationSynchronous:&err];
    [user describe];
    
    [user refreshSynchronous:&err];
    [user describe];
    
    [user setObject:@"121320540207054848 " forKey:@"internalUserID"];
    
  
    [user saveSynchronous:&err];
    
    
    [user refreshSynchronous:&err];
    [user describe];
}

-(void) apnsAuth{
    NSError* error;
    
    KiiUser* user=[KiiUser authenticateSynchronous:@"test1362712301" withPassword:@"kii12345" andError:&error];
    [user setObject:@"121320540207054848 " forKey:@"internalUserID"];
    
   
    [user saveSynchronous:&error];
    
    
    [user refreshSynchronous:&error];
    [user describe];
    
    
    
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    /*
    [Kii setAPNSDeviceToken:deviceToken];
     NSError* error;
     [KiiPushInstallation installSynchronous:&error];
    NSLog(@"%@",error);
    
     */
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
	NSLog(@"Received notification: %@", userInfo);
    KiiPushMessage* message=[KiiPushMessage messageFromAPNS:userInfo];
    [message showMessageAlertWithTitle:@"test"];
    
    
	
}
-(void) testSendExpicitPush{
    KiiUser* user=[KiiUser currentUser];
    
    NSError* error=nil;
    KiiTopic* topic=[user topicWithName:@"testTopics"];
    [topic saveSynchronous:&error];
    [KiiPushSubscription subscribeSynchronous:topic withError:&error];
    KiiAPNSFields* fields=[KiiAPNSFields createFields];
    fields.alertBody=@"Test";
    [fields setSpecificData:[NSDictionary dictionaryWithObject:@"this data is only for iOS" forKey:@"ios_data"]];
    
    KiiGCMFields* gcmFields=[KiiGCMFields createFields];
    
    [gcmFields setSpecificData:[NSDictionary dictionaryWithObject:@"this data is only for android " forKey:@"andro_data"]];
    
    KiiPushMessage* message=[KiiPushMessage composeMessageWithAPNSFields:fields andGCMFields:gcmFields];
    
    
    NSDictionary* customData=[NSDictionary dictionaryWithObject:@"data 1" forKey:@"data1"];
    
    message.data=customData;
    
    
    
    [topic sendMessageSynchronous:message withError:&error];
    
    if (nil!=error) {
        NSLog(@"%@",error);
    }
    
    
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

@end
