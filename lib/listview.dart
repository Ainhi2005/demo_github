import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListView Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListView Examples'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildMenuCard(
            'Basic ListView',
            'Danh sách cơ bản với children cố định',
            Icons.list,
            Colors.blue,
          ),
          _buildMenuCard(
            'ListView.builder',
            'Danh sách động với itemBuilder',
            Icons.build,
            Colors.green,
          ),
          _buildMenuCard(
            'ListView.separated',
            'Danh sách với separator',
            Icons.horizontal_rule,
            Colors.orange,
          ),
          _buildMenuCard(
            'Horizontal ListView',
            'Danh sách cuộn ngang',
            Icons.swipe,
            Colors.purple,
          ),
          _buildMenuCard(
            'Complex ListView',
            'Danh sách phức tạp với nhiều loại item',
            Icons.dashboard,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 13)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigator sẽ được thêm khi có các screen tương ứng
        },
      ),
    );
  }
}