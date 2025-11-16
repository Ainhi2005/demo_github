import 'package:flutter/material.dart';
// Import các file khác (nếu tách ra nhiều file)
// import 'basic_listview.dart';
// import 'builder_listview.dart';
// import 'separated_listview.dart';
// import 'horizontal_listview.dart';
// import 'complex_listview.dart';

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
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Icon(
                    Icons.list_alt,
                    size: 64,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Flutter ListView',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tìm hiểu các loại ListView trong Flutter',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Menu items
            _buildMenuCard(
              context,
              'Basic ListView',
              'Danh sách cơ bản với children cố định',
              Icons.list,
              Colors.blue,
                  () {
                // Navigator.push(context, MaterialPageRoute(builder: (_) => BasicListView()));
                _showComingSoon(context, 'Basic ListView');
              },
            ),

            _buildMenuCard(
              context,
              'ListView.builder',
              'Danh sách động với itemBuilder (tối ưu)',
              Icons.build,
              Colors.green,
                  () {
                // Navigator.push(context, MaterialPageRoute(builder: (_) => BuilderListView()));
                _showComingSoon(context, 'ListView.builder');
              },
            ),

            _buildMenuCard(
              context,
              'ListView.separated',
              'Danh sách với separator tùy chỉnh',
              Icons.horizontal_rule,
              Colors.orange,
                  () {
                // Navigator.push(context, MaterialPageRoute(builder: (_) => SeparatedListView()));
                _showComingSoon(context, 'ListView.separated');
              },
            ),

            _buildMenuCard(
              context,
              'Horizontal ListView',
              'Danh sách cuộn ngang',
              Icons.swipe,
              Colors.purple,
                  () {
                // Navigator.push(context, MaterialPageRoute(builder: (_) => HorizontalListView()));
                _showComingSoon(context, 'Horizontal ListView');
              },
            ),

            _buildMenuCard(
              context,
              'Complex ListView',
              'Danh sách phức tạp với nhiều loại item',
              Icons.dashboard,
              Colors.red,
                  () {
                // Navigator.push(context, MaterialPageRoute(builder: (_) => ComplexListView()));
                _showComingSoon(context, 'Complex ListView');
              },
            ),

            SizedBox(height: 20),

            // Info card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Uncomment các Navigator.push để điều hướng đến các màn hình demo',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Uncomment Navigator để xem demo'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}