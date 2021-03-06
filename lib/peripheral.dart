part of flutter_ble_lib;

abstract class _PeripheralMetadata {
  static const name = "name";
  static const identifier = "id";
}

class Peripheral {
  static const int _minimumMtu = 23;

  ManagerForPeripheral _manager;

  String name;
  String identifier;

  Peripheral.fromJson(Map<String, dynamic> json, ManagerForPeripheral manager)
      : _manager = manager,
        name = json[_PeripheralMetadata.name],
        identifier = json[_PeripheralMetadata.identifier];

  Future<void> connect(
          {bool isAutoConnect = false,
          int requestMtu = _minimumMtu,
          bool refreshGatt = false,
          Duration timeout}) =>
      _manager.connectToPeripheral(identifier,
          isAutoConnect: isAutoConnect,
          requestMtu: requestMtu,
          refreshGatt: refreshGatt,
          timeout: timeout);

  Stream<PeripheralConnectionState> observeConnectionState(
          {bool emitCurrentValue = false,
          bool completeOnDisconnect = false}) =>
      _manager.observePeripheralConnectionState(identifier, emitCurrentValue, completeOnDisconnect);


  Future<bool> isConnected() => _manager.isPeripheralConnected(identifier);

  Future<void> disconnectOrCancelConnection() =>
      _manager.disconnectOrCancelPeripheralConnection(identifier);

  Future<void> discoverAllServicesAndCharacteristics({String transactionId}) =>
      _manager.discoverAllServicesAndCharacteristics(this, transactionId);

  Future<List<Service>> services() => _manager.services(this);

  Future<List<Characteristic>> characteristics(String servicedUuid) =>
      _manager.characteristics(this, servicedUuid);

  Future<int> rssi({String transactionId}) {
    return _manager.rssi(this, transactionId);
  }

  Future<int> requestMtu(int mtu, {String transactionId}) {
    return _manager.requestMtu(this, mtu, transactionId);
  }

  Future<CharacteristicWithValue> readCharacteristic(
    String serviceUUID,
    String characteristicUUID, {
    String transactionId,
  }) =>
      _manager.readCharacteristicForDevice(
        this,
        serviceUUID,
        characteristicUUID,
        transactionId,
      );

  Future<Characteristic> writeCharacteristic(
    String serviceUUID,
    String characteristicUUID,
    Uint8List bytes,
    bool withResponse, {
    String transactionId,
  }) =>
      _manager.writeCharacteristicForDevice(
        this,
        serviceUUID,
        characteristicUUID,
        bytes,
        withResponse,
        transactionId,
      );

  Stream<CharacteristicWithValue> monitorCharacteristic(
    String serviceUUID,
    String characteristicUUID, {
    String transactionId,
  }) =>
      _manager.monitorCharacteristicForDevice(
        this,
        serviceUUID,
        characteristicUUID,
        transactionId,
      );

  @override
  String toString() {
    return 'Peripheral{\n\tname: $name, \n\tidentifier: $identifier\n}';
  }
}

enum PeripheralConnectionState {
  connecting,
  connected,
  disconnected,
  disconnecting
}
