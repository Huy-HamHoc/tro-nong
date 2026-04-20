import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── USERS ──────────────────────────────────────────────────

  /// Lấy thông tin hồ sơ người dùng theo uid
  Future<DocumentSnapshot?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists ? doc : null;
  }

  /// Tạo / cập nhật hồ sơ người dùng
  Future<void> setUser(String uid, Map<String, dynamic> data) {
    return _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }

  /// Cập nhật settings của user
  Future<void> updateUserSettings(String uid, Map<String, dynamic> settings) {
    return _db.collection('users').doc(uid).update({'settings': settings});
  }

  // ─── PROJECTS ───────────────────────────────────────────────

  /// Lấy tất cả dự án của một nông dân
  Stream<QuerySnapshot> getProjects(String farmerId) {
    return _db
        .collection('projects')
        .where('farmerId', isEqualTo: farmerId)
        .snapshots();
  }

  /// Thêm dự án mới + đồng bộ so_project
  Future<DocumentReference> addProject(Map<String, dynamic> data) async {
    final ref = await _db.collection('projects').add(data);
    await _syncProjectCount(data['farmerId'] as String?);
    return ref;
  }

  /// Cập nhật dự án
  Future<void> updateProject(String projectId, Map<String, dynamic> data) {
    return _db.collection('projects').doc(projectId).update(data);
  }

  /// Xóa dự án + đồng bộ so_project
  Future<void> deleteProject(String projectId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    await _db.collection('projects').doc(projectId).delete();
    await _syncProjectCount(uid);
  }

  /// Đếm lại số dự án và cập nhật vào users
  Future<void> _syncProjectCount(String? farmerId) async {
    if (farmerId == null) return;
    final snap = await _db
        .collection('projects')
        .where('farmerId', isEqualTo: farmerId)
        .get();
    await _db.collection('users').doc(farmerId).update({
      'so_project': snap.docs.length,
    });
  }

  // ─── CROP LOGS (Nhật ký) ────────────────────────────────────

  /// Lấy nhật ký của một dự án
  Stream<QuerySnapshot> getCropLogs(String projectId) {
    return _db
        .collection('crop_logs')
        .where('projectId', isEqualTo: projectId)
        .snapshots();
  }

  /// Thêm nhật ký mới
  Future<DocumentReference> addCropLog(Map<String, dynamic> data) {
    return _db.collection('crop_logs').add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ─── QR CODES ───────────────────────────────────────────────

  /// Lấy QR code theo projectId
  Future<QuerySnapshot> getQrCodes(String projectId) {
    return _db
        .collection('qr_codes')
        .where('projectId', isEqualTo: projectId)
        .get();
  }

  /// Tạo QR code mới
  Future<DocumentReference> createQrCode(Map<String, dynamic> data) {
    return _db.collection('qr_codes').add(data);
  }

  // ─── MARKET LISTINGS (Cửa hàng) ─────────────────────────────

  /// Lấy tất cả sản phẩm của một nông dân
  Stream<QuerySnapshot> getMarketListings(String farmerId) {
    return _db
        .collection('market_listings')
        .where('farmerId', isEqualTo: farmerId)
        .snapshots();
  }

  /// Lấy tất cả sản phẩm trên chợ (cho màn hình cửa hàng chung)
  Stream<QuerySnapshot> getAllListings() {
    return _db
        .collection('market_listings')
        .orderBy('productName')
        .snapshots();
  }

  /// Đăng bán sản phẩm + đồng bộ so_lohang
  Future<DocumentReference> addListing(Map<String, dynamic> data) async {
    final ref = await _db.collection('market_listings').add({
      ...data,
      'sold': 0,
    });
    await _syncListingCount(data['farmerId'] as String?);
    return ref;
  }

  /// Cập nhật số lượng tồn kho / đã bán
  Future<void> updateListing(String listingId, Map<String, dynamic> data) {
    return _db.collection('market_listings').doc(listingId).update(data);
  }

  /// Xóa sản phẩm + đồng bộ so_lohang
  Future<void> deleteListing(String listingId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    await _db.collection('market_listings').doc(listingId).delete();
    await _syncListingCount(uid);
  }

  /// Đếm lại số sản phẩm và cập nhật vào users
  Future<void> _syncListingCount(String? farmerId) async {
    if (farmerId == null) return;
    final snap = await _db
        .collection('market_listings')
        .where('farmerId', isEqualTo: farmerId)
        .get();
    await _db.collection('users').doc(farmerId).update({
      'so_lohang': snap.docs.length,
    });
  }

  // ─── FORUM POSTS (Diễn đàn) ─────────────────────────────────

  /// Lấy tất cả bài đăng diễn đàn (mới nhất trước)
  Stream<QuerySnapshot> getForumPosts() {
    return _db
        .collection('forum_posts')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Đăng bài mới
  Future<DocumentReference> addForumPost(Map<String, dynamic> data) {
    return _db.collection('forum_posts').add({
      ...data,
      'likes': 0,
      'commentsCount': 0,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Like bài viết (+1)
  Future<void> likePost(String postId) {
    return _db.collection('forum_posts').doc(postId).update({
      'likes': FieldValue.increment(1),
    });
  }
}
