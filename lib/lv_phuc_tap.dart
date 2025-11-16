import 'package:flutter/material.dart';

// File: complex_listview.dart
// ListView phức tạp với nhiều loại item khác nhau (Feed style)

class ComplexListView extends StatefulWidget {
  @override
  State<ComplexListView> createState() => _ComplexListViewState();
}

class _ComplexListViewState extends State<ComplexListView> {
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !_showBackToTop) {
        setState(() => _showBackToTop = true);
      } else if (_scrollController.offset <= 300 && _showBackToTop) {
        setState(() => _showBackToTop = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Danh sách items hỗn hợp
  final List<FeedItem> items = [
    HeaderItem('📰 Tin tức mới nhất'),
    PostItem(
      author: 'Nguyễn Văn A',
      avatar: 'A',
      time: '2 giờ trước',
      content: 'Hôm nay thời tiết đẹp quá! Đi dạo công viên thôi 🌞',
      likes: 24,
      comments: 5,
    ),
    PostItem(
      author: 'Trần Thị B',
      avatar: 'B',
      time: '3 giờ trước',
      content: 'Vừa hoàn thành dự án mới. Cảm ơn team đã hỗ trợ! 🎉',
      likes: 42,
      comments: 8,
      hasImage: true,
    ),
    AdItem(
      title: '🎁 Khuyến mãi đặc biệt',
      description: 'Giảm giá 50% cho tất cả sản phẩm. Nhanh tay!',
      buttonText: 'Xem ngay',
    ),
    HeaderItem('💡 Gợi ý kết bạn'),
    SuggestionItem(name: 'Lê Văn C', avatar: 'C', mutualFriends: 12),
    SuggestionItem(name: 'Phạm Thị D', avatar: 'D', mutualFriends: 8),
    HeaderItem('🔥 Bài viết phổ biến'),
    PostItem(
      author: 'Hoàng Văn E',
      avatar: 'E',
      time: '1 ngày trước',
      content: 'Chia sẻ tips học lập trình hiệu quả cho newbie. Ai cần thì comment nhé!',
      likes: 156,
      comments: 34,
    ),
    PostItem(
      author: 'Đặng Thị F',
      avatar: 'F',
      time: '1 ngày trước',
      content: 'Review quán cafe mới cực xinh và yên tĩnh ☕',
      likes: 89,
      comments: 15,
      hasImage: true,
    ),
    AdItem(
      title: '🚀 Học Flutter miễn phí',
      description: 'Khóa học Flutter từ cơ bản đến nâng cao',
      buttonText: 'Đăng ký ngay',
    ),
    PostItem(
      author: 'Vũ Văn G',
      avatar: 'G',
      time: '2 ngày trước',
      content: 'Cuối tuần rồi! Ai có kế hoạch gì thú vị không? 🎮',
      likes: 67,
      comments: 21,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complex ListView'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications_outlined),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '3',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 1));
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✓ Đã làm mới'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                // Info banner đầu tiên
                if (index == 0) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.red.shade50,
                    child: Row(
                      children: [
                        Icon(Icons.dashboard, color: Colors.red, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'ListView với nhiều loại item khác nhau (Header, Post, Ad, Suggestion)',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.red.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final item = items[index - 1];

                // Render theo loại item
                if (item is HeaderItem) {
                  return _buildHeader(item);
                } else if (item is PostItem) {
                  return _buildPost(item);
                } else if (item is AdItem) {
                  return _buildAd(item);
                } else if (item is SuggestionItem) {
                  return _buildSuggestion(item);
                }

                return SizedBox.shrink();
              },
            ),
          ),

          // Back to top button
          if (_showBackToTop)
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton.small(
                backgroundColor: Colors.red,
                child: Icon(Icons.arrow_upward),
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // Build header section
  Widget _buildHeader(HeaderItem item) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
      color: Colors.grey.shade100,
      child: Text(
        item.title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  // Build post item
  Widget _buildPost(PostItem item) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    item.avatar,
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.author,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        item.time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, size: 20),
                  onPressed: () {
                    _showPostMenu(context, item);
                  },
                ),
              ],
            ),

            SizedBox(height: 12),

            // Content
            Text(
              item.content,
              style: TextStyle(fontSize: 14, height: 1.4),
            ),

            // Image placeholder
            if (item.hasImage) ...[
              SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade200, Colors.purple.shade200],
                    ),
                  ),
                  child: Icon(
                    Icons.image,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),
            ],

            SizedBox(height: 12),
            Divider(height: 1),
            SizedBox(height: 8),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  Icons.thumb_up_outlined,
                  '${item.likes}',
                  Colors.blue,
                      () {
                    setState(() {
                      item.likes++;
                    });
                  },
                ),
                _buildActionButton(
                  Icons.comment_outlined,
                  '${item.comments}',
                  Colors.grey.shade700,
                      () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Bình luận về ${item.author}')),
                    );
                  },
                ),
                _buildActionButton(
                  Icons.share_outlined,
                  'Chia sẻ',
                  Colors.grey.shade700,
                      () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Chia sẻ bài viết')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // Build ad item
  Widget _buildAd(AdItem item) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.deepOrange.shade500],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    item.description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Clicked: ${item.title}'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(item.buttonText),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Icon(Icons.card_giftcard, size: 60, color: Colors.white),
          ],
        ),
      ),
    );
  }

  // Build suggestion item
  Widget _buildSuggestion(SuggestionItem item) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Text(
            item.avatar,
            style: TextStyle(
              color: Colors.green.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          item.name,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('${item.mutualFriends} bạn chung'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã gửi lời mời kết bạn tới ${item.name}'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(60, 32),
                padding: EdgeInsets.symmetric(horizontal: 12),
              ),
              child: Text('Thêm', style: TextStyle(fontSize: 12)),
            ),
            SizedBox(width: 4),
            IconButton(
              icon: Icon(Icons.close, size: 20),
              onPressed: () {
                setState(() {
                  items.remove(item);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPostMenu(BuildContext context, PostItem item) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.bookmark_border),
              title: Text('Lưu bài viết'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã lưu bài viết')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.link),
              title: Text('Sao chép liên kết'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã sao chép liên kết')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.report, color: Colors.red),
              title: Text('Báo cáo', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã báo cáo bài viết'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Abstract class và các loại item
abstract class FeedItem {}

class HeaderItem extends FeedItem {
  final String title;
  HeaderItem(this.title);
}

class PostItem extends FeedItem {
  final String author;
  final String avatar;
  final String time;
  final String content;
  int likes;
  final int comments;
  final bool hasImage;

  PostItem({
    required this.author,
    required this.avatar,
    required this.time,
    required this.content,
    required this.likes,
    required this.comments,
    this.hasImage = false,
  });
}

class AdItem extends FeedItem {
  final String title;
  final String description;
  final String buttonText;

  AdItem({
    required this.title,
    required this.description,
    required this.buttonText,
  });
}

class SuggestionItem extends FeedItem {
  final String name;
  final String avatar;
  final int mutualFriends;

  SuggestionItem({
    required this.name,
    required this.avatar,
    required this.mutualFriends,
  });
}

// Demo standalone - Uncomment để chạy riêng file này

void main() {
  runApp(MaterialApp(
    home: ComplexListView(),
    debugShowCheckedModeBanner: false,
  ));
}
