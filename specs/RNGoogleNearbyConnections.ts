import type {TurboModule} from 'react-native';
import {TurboModuleRegistry} from 'react-native';

export interface Spec extends TurboModule {
  initConnectionManager(serviceId: string, strategy: string): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>(
  'GoogleNearbyConnectionsWrapper',
);
