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

// Expose the startDiscovery method
RCT_EXPORT_METHOD(startDiscovery)
{
  GoogleNearbyConnectionsWrapper *wrapperInstance = [[GoogleNearbyConnectionsWrapper alloc] init];
  [wrapperInstance startDiscovery];
}

// Expose the stopDiscovery method
RCT_EXPORT_METHOD(stopDiscovery)
{
  GoogleNearbyConnectionsWrapper *wrapperInstance = [[GoogleNearbyConnectionsWrapper alloc] init];
  [wrapperInstance stopDiscovery];
}

// Expose the startAdvertising method with a string parameter
RCT_EXPORT_METHOD(startAdvertising:(NSString *)identifier)
{
  GoogleNearbyConnectionsWrapper *wrapperInstance = [[GoogleNearbyConnectionsWrapper alloc] init];
  [wrapperInstance startAdvertisingWithIdentifier:identifier];  // Ensure Swift method accepts NSString
}

// Expose the stopAdvertising method
RCT_EXPORT_METHOD(stopAdvertising)
{
  GoogleNearbyConnectionsWrapper *wrapperInstance = [[GoogleNearbyConnectionsWrapper alloc] init];
  [wrapperInstance stopAdvertising];
}

@end
