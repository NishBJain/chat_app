import 'package:flutter/material.dart';
import 'store_page_view.dart';

class StatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Image.asset(
            "assets/images/logo.jpeg",
            height: 40,
          ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              color: Colors.grey[700],
              elevation: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            "https://s3.amazonaws.com/wll-community-production/images/no-avatar.png"),
                      ),
                      Positioned(
                        bottom: 0.0,
                        right: 1.0,
                        child: Container(
                          height: 20,
                          width: 20,
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    ],
                  ),
                  title: Text(
                    "My Status",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Tap to add status update"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Viewed updates",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.grey[700],
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            "https://media-exp1.licdn.com/dms/image/C5103AQGY5LNUNPgHaQ/profile-displayphoto-shrink_200_200/0?e=1598486400&v=beta&t=mJDAbCfzc-c9m5hi8aRnqPg2S5qyPeDvVkLxjQCORv4"),
                      ),
                      title: Text(
                        "Palash",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Today, 20:16 PM"),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StoryPageView())),
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
}
