import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quest_for_calculus/my_home_page.dart';

class Leaderboards extends StatefulWidget {
  const Leaderboards({Key? key}) : super(key: key);

  @override
  State<Leaderboards> createState() => _LeaderboardsState();
}

class _LeaderboardsState extends State<Leaderboards> {
  Widget _buildPodiumItem(QueryDocumentSnapshot? position) {
    if (position == null) {
      return Container(); // Return an empty container or customize as needed
    }

    var name = position['name'];
    var score = position['score'];

    return Container(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Rosario',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 5, 54, 122),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                score.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: 1,
              ),
              Icon(
                Icons.star,
                color: Colors.orange,
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle columnTitle = const TextStyle(
      fontFamily: 'Rosario',
      fontWeight: FontWeight.w700,
      fontSize: 16,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        title: const Text(
          'Leaderboards',
          style: TextStyle(fontFamily: 'Rosario', fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MyHomePage(),
                ),
                ModalRoute.withName('/homepage'));
            ;
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 45,
              width: 130,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 51, 51),
                border:
                    Border.all(color: Color.fromARGB(255, 3, 34, 77), width: 6),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Text(
                  'RANKINGS',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Rosario',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('leaderboards')
                  .orderBy('score', descending: true)
                  .limit(3)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                var documents = snapshot.data?.docs;

                if (documents!.length >= 3) {
                  var firstPosition = documents[0];
                  var secondPosition = documents[1];
                  var thirdPosition = documents[2];

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image(
                        image: AssetImage("assets/top-3.png"),
                      ),
                      Positioned(
                        left: 100,
                        bottom: 100,
                        child: _buildPodiumItem(firstPosition),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 70,
                        child: _buildPodiumItem(secondPosition),
                      ),
                      Positioned(
                        left: 195,
                        bottom: 65,
                        child: _buildPodiumItem(thirdPosition),
                      ),
                    ],
                  );
                } else {
                  return Text('Not enough data in the leaderboard');
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 3, 34, 77),
                borderRadius: BorderRadius.circular(20),
              ),
              width: 300,
              height: 7,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 196, 195, 195),
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('leaderboards')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  var documents = snapshot.data?.docs;

                  documents?.sort((a, b) =>
                      (b['score'] as int).compareTo(a['score'] as int));

                  // Get a sublist of documents starting from index 3
                  var rankedDocuments = documents?.sublist(3);

                  return Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.white,
                      dividerTheme: DividerThemeData(
                        color: const Color.fromARGB(255, 196, 195, 195),
                      ),
                    ),
                    child: Container(
                      height: 330,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          dataRowMinHeight: 20,
                          dataRowMaxHeight: 35,
                          columns: [
                            DataColumn(
                              label: Text(
                                'Rank',
                                style: columnTitle,
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Name',
                                  style: columnTitle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Container(
                                child: Text(
                                  'Score',
                                  style: columnTitle,
                                ),
                              ),
                            ),
                          ],
                          rows: rankedDocuments?.asMap().entries.map((entry) {
                                var index = entry.key + 4; // Start from rank 4
                                var doc = entry.value;
                                var name = doc['name'];
                                var score = doc['score'];

                                return DataRow(cells: [
                                  DataCell(Text(index.toString())),
                                  DataCell(Container(
                                    width: 75,
                                    child: Text(
                                      name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Rosario',
                                          fontWeight: FontWeight.w700,
                                          color:
                                              Color.fromARGB(255, 5, 54, 122)),
                                    ),
                                  )),
                                  DataCell(Text(score.toString())),
                                ]);
                              }).toList() ??
                              [],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
