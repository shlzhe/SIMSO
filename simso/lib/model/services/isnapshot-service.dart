import 'package:simso/model/entities/snapshot-model.dart';

abstract class ISnapshotService {
  Future<List<Snapshot>> getSnapshots(String uid);
  Future<void> addSnapshot(Snapshot snapshot);
  Future<void> updateSnapshot(Snapshot snapshot);
  Future<void> deleteSnapshot(String uid);
  Future<List<Snapshot>> contentSnapshotList(bool friends, List<dynamic> friendsList);
}