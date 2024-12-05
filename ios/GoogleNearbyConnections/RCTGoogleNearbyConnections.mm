//
//  RCTGoogleNearbyConnections.m
//  RNGoogleNearbyConnections
//
//  Created by James Chrysaphiades on 05/12/2024.
//

#import "RCTGoogleNearbyConnections.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

#import "RNGoogleNearbyConnections-Swift.h"

@implementation RCTGoogleNearbyConnections

RCT_EXPORT_MODULE(GoogleNearbyConnectionsWrapper)

// React Native requires this for TurboModules
+ (BOOL)requiresMainQueueSetup {
  return [GoogleNearbyConnectionsWrapper requiresMainQueueSetup];
}

// Override supportedEvents to expose event names from Swift
- (NSArray<NSString *> *)supportedEvents {
  GoogleNearbyConnectionsWrapper *swiftWrapper = [[GoogleNearbyConnectionsWrapper alloc] init];
  return [swiftWrapper supportedEvents];
}

// Initialize connection manager
RCT_EXPORT_METHOD(initConnectionManager:(NSString *)serviceId
                  strategy:(NSString *)strategy)
{
    GoogleNearbyConnectionsWrapper *swiftWrapper = [[GoogleNearbyConnectionsWrapper alloc] init];
    [swiftWrapper initConnectionManagerWithServiceId:serviceId strategy:strategy];
}



@end
