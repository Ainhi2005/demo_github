import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'room_model.dart';
import 'api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Tìm Trọ Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RoomListScreen(),
    );
  }
}

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  final ApiService _apiService = ApiService(Dio());
  late Future<List<RoomModel>> _roomsFuture;

  // Biến để theo dõi trạng thái
  int _loadCount = 0;
  DateTime? _lastLoadTime;

  @override
  void initState() {
    super.initState();
    _debugPrint('🔄 INIT STATE: Bắt đầu khởi tạo');
    _roomsFuture = _loadRoomsWithDebug();
  }

  // Hàm reload dữ liệu với debug
  void _refreshData() {
    _debugPrint('🔄 REFRESH: Người dùng yêu cầu làm mới dữ liệu');
    setState(() {
      _roomsFuture = _loadRoomsWithDebug();
    });
  }

  // Hàm tải dữ liệu với debug chi tiết
  Future<List<RoomModel>> _loadRoomsWithDebug() async {
    _loadCount++;
    final startTime = DateTime.now();
    _debugPrint('🚀 LOAD #$_loadCount: Bắt đầu tải dữ liệu - ${startTime.toIso8601String()}');

    if (_lastLoadTime != null) {
      final timeSinceLastLoad = startTime.difference(_lastLoadTime!);
      _debugPrint('⏰ Thời gian từ lần tải trước: ${timeSinceLastLoad.inSeconds} giây');
    }

    try {
      final rooms = await _apiService.getRooms();
      final endTime = DateTime.now();
      final loadDuration = endTime.difference(startTime);

      _debugPrint('✅ LOAD #$_loadCount THÀNH CÔNG:');
      _debugPrint('   • Thời gian tải: ${loadDuration.inMilliseconds}ms');
      _debugPrint('   • Số lượng phòng: ${rooms.length}');
      _debugPrint('   • Thời gian kết thúc: ${endTime.toIso8601String()}');

      // Debug chi tiết từng phòng
      _debugPrint('📊 CHI TIẾT PHÒNG:');
      for (var i = 0; i < rooms.length; i++) {
        final room = rooms[i];
        _debugPrint('   ${i + 1}. ${room.title}');
        _debugPrint('      ID: ${room.id}');
        _debugPrint('      Địa chỉ: ${room.address}');
        _debugPrint('      Giá: ${room.price} VNĐ');
        _debugPrint('      Ảnh: ${room.imageUrl}');
        _debugPrint('      ---');
      }

      _lastLoadTime = endTime;
      return rooms;

    } catch (error, stackTrace) {
      final endTime = DateTime.now();
      final loadDuration = endTime.difference(startTime);

      _debugPrint('❌ LOAD #$_loadCount THẤT BẠI:');
      _debugPrint('   • Lỗi: $error');
      _debugPrint('   • Thời gian trước khi lỗi: ${loadDuration.inMilliseconds}ms');
      _debugPrint('   • StackTrace: $stackTrace');

      // Re-throw để FutureBuilder có thể xử lý
      rethrow;
    }
  }

  // Hàm in debug với format đẹp
  void _debugPrint(String message) {
    final timestamp = DateTime.now().toIso8601String();
    print('[$timestamp] $message');
  }

  @override
  Widget build(BuildContext context) {
    _debugPrint('🎨 BUILD: Widget được build lại');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách phòng trọ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
          // Thêm badge hiển thị số lần load
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$_loadCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<List<RoomModel>>(
        future: _roomsFuture,
        builder: (context, snapshot) {
          _debugPrint('📱 FUTUREBUILDER:');
          _debugPrint('   • ConnectionState: ${snapshot.connectionState}');
          _debugPrint('   • HasData: ${snapshot.hasData}');
          _debugPrint('   • HasError: ${snapshot.hasError}');

          if (snapshot.connectionState == ConnectionState.waiting) {
            _debugPrint('   ⏳ Trạng thái: ĐANG TẢI...');
            return _buildLoadingWidget();
          } else if (snapshot.hasError) {
            _debugPrint('   💥 Trạng thái: LỖI - ${snapshot.error}');
            return _buildErrorWidget(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            _debugPrint('   ℹ️ Trạng thái: KHÔNG CÓ DỮ LIỆU');
            return _buildEmptyWidget();
          }

          _debugPrint('   ✅ Trạng thái: DỮ LIỆU THÀNH CÔNG');
          return _buildRoomList(snapshot.data!);
        },
      ),
      // Thêm floating action button để debug
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDebugInfo(context);
        },
        child: const Icon(Icons.bug_report),
        tooltip: 'Thông tin Debug',
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Đang tải dữ liệu...'),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          const Text(
            'Lỗi tải dữ liệu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _refreshData,
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Không có phòng trọ nào',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _refreshData,
            child: const Text('Tải lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomList(List<RoomModel> rooms) {
    return ListView.builder(
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];

        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: _buildImageWidget(room),
            title: Text(room.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(room.address),
                Text('Giá: ${room.price} VNĐ',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showRoomDetail(context, room);
            },
          ),
        );
      },
    );
  }

  Widget _buildImageWidget(RoomModel room) {
    _debugPrint('🖼️ BUILD IMAGE: ${room.title} - URL: ${room.imageUrl}');

    return SizedBox(
      width: 80,
      height: 80,
      child: room.imageUrl.isNotEmpty
          ? ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          room.imageUrl,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              _debugPrint('✅ IMAGE LOADED: ${room.title}');
              return child;
            }
            _debugPrint('📥 IMAGE LOADING: ${room.title} - ${loadingProgress.cumulativeBytesLoaded}/${loadingProgress.expectedTotalBytes}');
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            _debugPrint('❌ IMAGE ERROR: ${room.title} - $error');
            _debugPrint('   URL: ${room.imageUrl}');
            return _buildPlaceholder();
          },
        ),
      )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.home, color: Colors.grey, size: 40),
    );
  }

  void _showRoomDetail(BuildContext context, RoomModel room) {
    _debugPrint('👆 TAP ROOM: ${room.title} (ID: ${room.id})');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(room.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${room.id}'),
              Text('Địa chỉ: ${room.address}'),
              Text('Giá: ${room.price} VNĐ'),
              const SizedBox(height: 16),
              const Text('URL ảnh:', style: TextStyle(fontWeight: FontWeight.bold)),
              SelectableText(room.imageUrl),
              const SizedBox(height: 16),
              room.imageUrl.isNotEmpty
                  ? Image.network(room.imageUrl)
                  : const Text('Không có ảnh'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showDebugInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.bug_report),
            SizedBox(width: 8),
            Text('Thông tin Debug'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Số lần tải: $_loadCount'),
            Text('• Lần tải cuối: ${_lastLoadTime?.toIso8601String() ?? "Chưa có"}'),
            const SizedBox(height: 16),
            const Text(
              'Xem console để biết chi tiết debug',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          TextButton(
            onPressed: () {
              _refreshData();
              Navigator.pop(context);
            },
            child: const Text('Tải lại'),
          ),
        ],
      ),
    );
  }
}