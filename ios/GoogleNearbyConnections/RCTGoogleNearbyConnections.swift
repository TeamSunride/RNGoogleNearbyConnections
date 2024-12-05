//
//  RCTGoogleNearbyConnections.swift
//  RNGoogleNearbyConnections
//
//  Created by James Chrysaphiades on 05/12/2024.
//

import Foundation
import NearbyConnections

@objc public class GoogleNearbyConnectionsWrapper: RCTEventEmitter {
  private var connectionManager: ConnectionManager?
  private var discoverer: Discoverer?
  private var advertiser: Advertiser?

  @objc public override init() {
    super.init()
  }
  
    // Initialize the connection manager
  @objc public func initConnectionManager(serviceId: String, strategy: String) {
    switch (strategy) {
      case "cluster":
      self.connectionManager = ConnectionManager(serviceID: serviceId, strategy: .cluster)
      break
    case "star":
      self.connectionManager = ConnectionManager(serviceID: serviceId, strategy: .star)
      break
    case "pointToPoint":
      self.connectionManager = ConnectionManager(serviceID: serviceId, strategy: .pointToPoint)
      break
    default:
      self.connectionManager = ConnectionManager(serviceID: serviceId, strategy: .pointToPoint)
      break
    }
    
    self.connectionManager?.delegate = self
    
    self.discoverer = Discoverer(connectionManager: self.connectionManager!)
    self.discoverer?.delegate = self
    
    self.advertiser = Advertiser(connectionManager: self.connectionManager!)
    self.advertiser?.delegate = self
  }
  
  @objc public func startDiscovery() {
    self.discoverer?.startDiscovery()
  }
  
  @objc public func stopDiscovery() {
    self.discoverer?.stopDiscovery()
  }

  @objc public func startAdvertising(identifier: String) {
    self.advertiser?.startAdvertising(using: identifier.data(using: .utf8)!)
  }
  
  @objc public func stopAdvertising() {
    self.advertiser?.stopAdvertising()
  }
  
  @objc public override static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  @objc public override func constantsToExport() -> [AnyHashable: Any]!{
    return ["validStrategies":["cluster", "star", "pointToPoint"]]
  }
  
  @objc public override func supportedEvents() -> [String]! {
      return ["connectionVerificationRequest", "payloadReceived", "payloadStatusUpdate", "connecting", "connected", "disconnected", "rejected", "endpointFound", "endpointLost", "connectionRequest"]
  }
}

extension GoogleNearbyConnectionsWrapper: ConnectionManagerDelegate {
  public func connectionManager(
    _ connectionManager: ConnectionManager, didReceive verificationCode: String,
    from endpointID: EndpointID, verificationHandler: @escaping (Bool) -> Void) {
    // Optionally show the user the verification code. Your app should call this handler
    // with a value of `true` if the nearby endpoint should be trusted, or `false`
    // otherwise.
    sendEvent(withName: "connectionVerificationRequest", body: ["verificationCode": verificationCode, "endpointID": endpointID])
  }

  public func connectionManager(
    _ connectionManager: ConnectionManager, didReceive data: Data,
    withID payloadID: PayloadID, from endpointID: EndpointID) {
    // A simple byte payload has been received. This will always include the full data.
    print(data)
    sendEvent(withName: "payloadReceived", body: ["endpointID": endpointID])
  }

  public func connectionManager(
    _ connectionManager: ConnectionManager, didReceive stream: InputStream,
    withID payloadID: PayloadID, from endpointID: EndpointID,
    cancellationToken token: CancellationToken) {
    // We have received a readable stream.
    
  }

  public func connectionManager(
    _ connectionManager: ConnectionManager,
    didStartReceivingResourceWithID payloadID: PayloadID,
    from endpointID: EndpointID, at localURL: URL,
    withName name: String, cancellationToken token: CancellationToken) {
    // We have started receiving a file. We will receive a separate transfer update
    // event when complete.
    
  }

  public func connectionManager(
    _ connectionManager: ConnectionManager,
    didReceiveTransferUpdate update: TransferUpdate,
    from endpointID: EndpointID, forPayload payloadID: PayloadID) {
    // A success, failure, cancelation or progress update.
    sendEvent(withName: "payloadStatusUpdate", body: ["endpointID": endpointID])
  }

  public func connectionManager(
    _ connectionManager: ConnectionManager, didChangeTo state: ConnectionState,
    for endpointID: EndpointID) {
    switch state {
    case .connecting:
      // A connection to the remote endpoint is currently being established.
      sendEvent(withName: "connecting", body: ["endpointID": endpointID])
      break
    case .connected:
      // We're connected! Can now start sending and receiving data.
      sendEvent(withName: "connected", body: ["endpointID": endpointID])
      break
    case .disconnected:
      // We've been disconnected from this endpoint. No more data can be sent or received.
      sendEvent(withName: "disconnected", body: ["endpointID": endpointID])
      break
    case .rejected:
      // The connection was rejected by one or both sides.
      sendEvent(withName: "rejected", body: ["endpointID": endpointID])
      break
    }
  }
}

extension GoogleNearbyConnectionsWrapper: DiscovererDelegate {
  public func discoverer(
    _ discoverer: Discoverer, didFind endpointID: EndpointID, with context: Data) {
    // An endpoint was found.
    sendEvent(withName: "endpointFound", body: ["endpointID": endpointID])
  }

  public func discoverer(_ discoverer: Discoverer, didLose endpointID: EndpointID) {
    // A previously discovered endpoint has gone away.
    sendEvent(withName: "endpointLost", body: ["endpointID": endpointID])
  }
}

extension GoogleNearbyConnectionsWrapper: AdvertiserDelegate {
  public func advertiser(
    _ advertiser: Advertiser, didReceiveConnectionRequestFrom endpointID: EndpointID,
    with context: Data, connectionRequestHandler: @escaping (Bool) -> Void) {
    // Accept or reject any incoming connection requests. The connection will still need to
    // be verified in the connection manager delegate.
    sendEvent(withName: "connectionRequest", body: ["endpointID": endpointID])
    connectionRequestHandler(true)
  }
}
