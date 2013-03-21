//
//  KiiPushSampleTests.m
//  KiiPushSampleTests
//
//  Created by Riza Alaudin Syah on 1/30/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import "KiiPushSampleTests.h"
#import <KiiSDK/Kii.h>
@implementation KiiPushSampleTests

- (void)setUp
{
    [super setUp];
    [Kii beginWithID:@"b58eee48"
              andKey:@"c5abe20b006c3883e1151eb80a2f979c"
             andSite:kiiSiteJP];
    NSError* error;
    
    KiiUser* user=[KiiUser authenticateSynchronous:@"test1362712301" withPassword:@"kii12345" andError:&error];
    [user setObject:@"121320540207054848 " forKey:@"internalUserID"];
    
    
    [user saveSynchronous:&error];
    
    
    [user refreshSynchronous:&error];
    [user describe];
    
}

- (void)tearDown
{
    // Tear-down code here.
    [KiiUser logOut];
    [super tearDown];
}

- (void)test100Push
{
    KiiUser* user=[KiiUser currentUser];
    
    NSError* error=nil;
    KiiTopic* topic=[user topicWithName:@"testTopics"];
    
    for (int i=0; i<100; i++) {
        KiiAPNSFields* fields=[KiiAPNSFields createFields];
        fields.alertBody=[NSString stringWithFormat:@"Test %d",i];
        fields.badge=[NSNumber numberWithInt:i];
        
        [fields setSpecificData:nil];
        
        KiiGCMFields* gcmFields=[KiiGCMFields createFields];
        
        [gcmFields setSpecificData:nil];
        
        KiiPushMessage* message=[KiiPushMessage composeMessageWithAPNSFields:fields andGCMFields:gcmFields];
        
        
        NSDictionary* customData=[NSDictionary dictionaryWithObject:@"data 1" forKey:@"data1"];
        
        message.data=customData;
        
        
        
        [topic sendMessageSynchronous:message withError:&error];
        
        if (nil!=error) {
            NSLog(@"%@",error);
        }

    }
    
}

@end
