/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, {useEffect, useState} from 'react';
import type {PropsWithChildren} from 'react';
import {
  Button,
  FlatList,
  NativeEventEmitter,
  NativeModules,
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,
} from 'react-native';

import {
  Colors,
  DebugInstructions,
  Header,
  LearnMoreLinks,
  ReloadInstructions,
} from 'react-native/Libraries/NewAppScreen';

import RNGoogleNearbyConnections from './specs/RNGoogleNearbyConnections';

const GoogleNearbyConnections = NativeModules.GoogleNearbyConnectionsWrapper;
const nearbyConnections = new NativeEventEmitter(GoogleNearbyConnections);

const Item = ({name}: {name: string}) => (
  <View>
    <Text>{name}</Text>
  </View>
);

function App(): React.JSX.Element {
  const isDarkMode = useColorScheme() === 'dark';

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  };

  useEffect(() => {
    GoogleNearbyConnections.initConnectionManager(
      'org.reactjs.native.sunride.--PRODUCT-NAME-rfc1034identifier-',
      'cluster',
    );
    console.log("init'd");

    const listeners = [
      nearbyConnections.addListener('connectionVerificationRequest', event => {
        console.log('connectionVerificationRequest', event);
        // GoogleNearbyConnections.acceptConnection(event.endpointId);
      }),
      nearbyConnections.addListener('payloadReceived', event => {
        console.log('payloadReceived', event);
      }),
      nearbyConnections.addListener('payloadStatusUpdate', event => {
        console.log('payloadStatusUpdate', event);
      }),
      nearbyConnections.addListener('connecting', event => {
        console.log('connecting', event);
      }),
      nearbyConnections.addListener('connected', event => {
        console.log('connected', event);
      }),
      nearbyConnections.addListener('disconnected', event => {
        console.log('disconnected', event);
      }),
      nearbyConnections.addListener('rejected', event => {
        console.log('rejected', event);
      }),
      nearbyConnections.addListener('endpointFound', event => {
        console.log('endpointFound', event);
      }),
      nearbyConnections.addListener('endpointLost', event => {
        console.log('endpointLost', event);
      }),
      nearbyConnections.addListener('connectionRequest', event => {
        console.log('connectionRequest', event);
      }),
    ];

    console.log("added listeners");

    return () => {
      console.debug('[app] main component unmounting. Removing listeners...');
      for (const listener of listeners) {
        listener.remove();
      }
    };
  }, []);

  const [advertising, setAdvertising] = useState(false);
  const [discovering, setDiscovering] = useState(false);
  const [connections, setConnections] = useState([]);
  const [discoveredEndpoints, setDiscoveredEndpoints] = useState([]);

  return (
    <SafeAreaView style={backgroundStyle}>
      <StatusBar
        barStyle={isDarkMode ? 'light-content' : 'dark-content'}
        backgroundColor={backgroundStyle.backgroundColor}
      />
      <ScrollView
        contentInsetAdjustmentBehavior="automatic"
        style={backgroundStyle}>
        <Header />
        <View
          style={{
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
          }}>
          {advertising === false && (
            <Button
              title="Start Advertising"
              onPress={() => {
                GoogleNearbyConnections.startAdvertising('tracieApp');
                setAdvertising(true);
              }}
            />
          )}
          {advertising === true && (
            <Button
              title="Stop Advertising"
              onPress={() => {
                GoogleNearbyConnections.stopAdvertising();
                setAdvertising(false);
              }}
            />
          )}
          {discovering === false && (
            <Button
              title="Start Discovery"
              onPress={() => {
                GoogleNearbyConnections.startDiscovery();
                setDiscovering(true);
              }}
            />
          )}
          {discovering === true && (
            <Button
              title="Stop Discovery"
              onPress={() => {
                GoogleNearbyConnections.stopDiscovery();
                setDiscovering(false);
              }}
            />
          )}
          <FlatList
            data={discoveredEndpoints}
            renderItem={({item}) => <Item name={item} />}
            keyExtractor={name => name}
          />
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
  },
  highlight: {
    fontWeight: '700',
  },
});

export default App;
