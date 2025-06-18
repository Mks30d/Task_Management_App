import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tmaa/%20components/auth/signin.dart';
import 'package:tmaa/%20components/tasks/add_task.dart';
import 'package:tmaa/%20components/tasks/all_tasks.dart';
import 'package:tmaa/main.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final auth = FirebaseAuth.instance;
  int _selectedIndex = 0;

  // Pages
  final List<Widget> _pages = [
    AllTasksPage(),
    Center(child: Text("Add")),
    Center(child: Text("Calendar Page")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Get today's day and date
  String getFormattedDate() {
    final now = DateTime.now();
    return DateFormat('EEEE, MMMM d').format(now); // e.g. Tuesday, June 18
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = auth.currentUser;

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: primaryColor),
                accountName: Text("Logged In"),
                accountEmail: Text(currentUser?.email ?? "No email"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: primaryColor),
                ),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Sign Out"),
                onTap: () async {
                  await auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Signin()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text("Task Management App", style: TextStyle(fontSize: 18)),
            Text(getFormattedDate(), style: TextStyle(fontSize: 18)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Non-functional
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _onItemTapped(0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.list,
                      size: 35,
                      color: _selectedIndex == 0 ? primaryColor : Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showAddTaskDialog(context);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      size: 50,
                      color: _selectedIndex == 1 ? primaryColor : Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _onItemTapped(2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 28,
                      color: _selectedIndex == 2 ? primaryColor : Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
