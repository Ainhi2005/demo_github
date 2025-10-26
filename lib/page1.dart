import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListView Demo',
      home: FriendListScreen(),
    );
  }
}

class FriendListScreen extends StatefulWidget {
  @override
  _FriendListScreenState createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  // Danh sách tên ban đầu
  List<String> friends = ['Nhi', 'Minh', 'Phúc', 'Hà', 'Tú'];

  // Hàm thêm bạn
  void _addFriend() {
    setState(() {
      friends.add('Người mới ${friends.length + 1}');
    });
  }

  // Hàm xóa bạn
  void _removeFriend(int index) {
    setState(() {
      friends.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách bạn bè'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(
                  friends[index][0],
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text(friends[index]),
              subtitle: Text('Bạn thân #${index + 1}'),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeFriend(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFriend,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
