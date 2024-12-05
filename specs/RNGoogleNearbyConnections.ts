import type {TurboModule} from 'react-native';
import {TurboModuleRegistry} from 'react-native';

export interface Spec extends TurboModule {
  initConnectionManager(serviceId: string, strategy: string): void;
  startDiscovery(): void;
  stopDiscovery(): void;
  startAdvertising(identifier: string): void;
  stopAdvertising(): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>(
  'GoogleNearbyConnectionsWrapper',
);
