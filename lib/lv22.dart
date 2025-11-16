import 'package:flutter/material.dart';

// File: separated_listview.dart
// ListView.separated với separator tùy chỉnh

class SeparatedListView extends StatelessWidget {
  // Dữ liệu tin nhắn mẫu
  final List<Message> messages = [
    Message(
      sender: 'Nguyễn Văn A',
      content: 'Chào bạn! Hôm nay có rảnh không?',
      time: '10:30',
      isRead: false,
      avatar: 'A',
    ),
    Message(
      sender: 'Trần Thị B',
      content: 'Meeting lúc 2 giờ chiều nhé',
      time: '9:45',
      isRead: true,
      avatar: 'B',
    ),
    Message(
      sender: 'Lê Văn C',
      content: 'File đã gửi trong email rồi',
      time: '9:00',
      isRead: true,
      avatar: 'C',
    ),
    Message(
      sender: 'Phạm Thị D',
      content: 'Cảm ơn bạn nhiều! 😊',
      time: 'Hôm qua',
      isRead: true,
      avatar: 'D',
    ),
    Message(
      sender: 'Hoàng Văn E',
      content: 'Nhớ kiểm tra báo cáo nhé',
      time: 'Hôm qua',
      isRead: false,
      avatar: 'E',
    ),
    Message(
      sender: 'Đặng Thị F',
      content: 'OK, mình đã nhận được',
      time: '2 ngày trước',
      isRead: true,
      avatar: 'F',
    ),
    Message(
      sender: 'Vũ Văn G',
      content: 'Deadline là thứ 6 này',
      time: '3 ngày trước',
      isRead: true,
      avatar: 'G',
    ),
    Message(
      sender: 'Bùi Thị H',
      content: 'Chúc mừng sinh nhật! 🎉',
      time: '1 tuần trước',
      isRead: false,
      avatar: 'H',
    ),
    Message(
      sender: 'Ngô Văn I',
      content: 'Tài liệu đã được cập nhật',
      time: '1 tuần trước',
      isRead: true,
      avatar: 'I',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListView.separated'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.blue,
        elevation: 3,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Info banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.orange.shade50,
            child: Row(
              children: [
                Icon(Icons.horizontal_rule, color: Colors.orange, size: 20),
                SizedBox(width: 80),
                Expanded(
                  child: Text(
                    'ListView.separated cho phép tùy chỉnh separator giữa các item',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.orange.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ListView với separator
          Expanded(
            child: ListView.separated(
              itemCount: messages.length,
              padding: EdgeInsets.symmetric(vertical: 8),

              // Item builder
              itemBuilder: (context, index) {
                final message = messages[index];
                return _buildMessageItem(context, message);
              },

              // Separator builder - Tùy chỉnh theo vị trí
              separatorBuilder: (context, index) {
                // Separator đặc biệt mỗi 3 item
                if (index % 3 == 2) {
                  return Divider(
                    thickness: 2,
                    indent: 16,
                    endIndent: 16,
                    color: Colors.orange.shade100,
                    height: 16,
                  );
                } else {
                  // Separator thông thường
                  return Divider(
                    indent: 72,
                    endIndent: 16,
                    height: 1,
                    color: Colors.grey.shade300,
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.message),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tạo tin nhắn mới'),
              backgroundColor: Colors.orange,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageItem(BuildContext context, Message message) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),

      // Avatar với status
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundColor: message.isRead
                ? Colors.grey.shade300
                : Colors.orange.shade100,
            radius: 28,
            child: Text(
              message.avatar,
              style: TextStyle(
                color: message.isRead
                    ? Colors.grey.shade700
                    : Colors.orange.shade900,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),

      // Nội dung
      title: Row(
        children: [
          Expanded(
            child: Text(
              message.sender,
              style: TextStyle(
                fontWeight: message.isRead ? FontWeight.normal : FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            message.time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),

      subtitle: Padding(
        padding: EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                message.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: message.isRead ? FontWeight.normal : FontWeight.w500,
                  color: message.isRead ? Colors.grey.shade600 : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
            // Badge số tin nhắn chưa đọc
            if (!message.isRead)
              Container(
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),

      onTap: () {
        _showMessageDetail(context, message);
      },

      // Long press menu
      onLongPress: () {
        _showMessageOptions(context, message);
      },
    );
  }

  void _showMessageDetail(BuildContext context, Message message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.orange.shade100,
              child: Text(
                message.avatar,
                style: TextStyle(color: Colors.orange.shade900),
              ),
            ),
            SizedBox(width: 12),
            Expanded(child: Text(message.sender)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thời gian: ${message.time}',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            SizedBox(height: 12),
            Text(message.content),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  message.isRead ? Icons.done_all : Icons.done,
                  size: 18,
                  color: message.isRead ? Colors.blue : Colors.grey,
                ),
                SizedBox(width: 4),
                Text(
                  message.isRead ? 'Đã đọc' : 'Đã gửi',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Trả lời ${message.sender}')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: Text('Trả lời'),
          ),
        ],
      ),
    );
  }

  void _showMessageOptions(BuildContext context, Message message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.reply),
              title: Text('Trả lời'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Trả lời ${message.sender}')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.forward),
              title: Text('Chuyển tiếp'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Chuyển tiếp tin nhắn')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Xóa', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã xóa tin nhắn'),
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

// Model class
class Message {
  final String sender;
  final String content;
  final String time;
  final bool isRead;
  final String avatar;

  Message({
    required this.sender,
    required this.content,
    required this.time,
    this.isRead = true,
    required this.avatar,
  });
}

// Demo standalone - Uncomment để chạy riêng file này

void main() {
  runApp(MaterialApp(
    home: SeparatedListView(),
    debugShowCheckedModeBanner: false,
  ));
}