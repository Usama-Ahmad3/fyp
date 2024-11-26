import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/view/home_screens/search_screen/search_widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List ab = [];
  List abc = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'x',
    'y',
    'z'
  ];

  Future<QuerySnapshot> fetchDataFromFirebase() async {
    return FirebaseFirestore.instance.collection('sell_car_data').get();
  }

  searchTitles(List make) {
    for (int i = 0; i < make.length; i++) {
      abc.forEach((element) {
        print(make[i]);
        print(element);
        if (element.toString().toLowerCase() == make[i][0].toLowerCase()) {
          print('abmmm');
          ab.add(element);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(children: [
          Container(
            color: AppColors.transparent,
            height: height * 0.07,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Filter Search',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: AppColors.black)),
              ],
            ),
          ),
          FutureBuilder(
            future: fetchDataFromFirebase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) {
                  return const Text('Something Went Wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: height * 0.4,
                    child: Center(
                        child: CircularProgressIndicator(
                            color: AppColors.buttonColor)),
                  );
                } else {
                  print(snapshot.data);
                  return Column(
                    children: [
                      ...List.generate(abc.length, (mainIndex) {
                        var document = snapshot.data!.docs[0];
                        searchTitles(document["make"]);
                        return ab.toString().toLowerCase().contains(
                                abc[mainIndex].toString().toLowerCase())
                            ? LayoutBuilder(
                                builder: (context, constraints) =>
                                    ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxHeight: constraints.maxHeight),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.03,
                                            vertical: height * 0.01),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            abc[mainIndex],
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ),
                                      ),
                                      ListView.builder(
                                        itemCount: document['make'].length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          print(
                                              "object ==> ${document['make'][index]}");
                                          return document['make'][index]
                                                  .toString()
                                                  .toLowerCase()
                                                  .startsWith(abc[mainIndex]
                                                      .toString()
                                                      .toLowerCase())
                                              ? searchWidget(
                                                  width: width,
                                                  height: height,
                                                  modelName: document['make']
                                                      [index],
                                                  number:
                                                      'value.carModel.model![index].id.toString()',
                                                  context: context)
                                              : const SizedBox.shrink();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      }),
                    ],
                  );
                }
              } else {
                return SizedBox(
                  height: height * 0.4,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.buttonColor,
                    ),
                  ),
                );
              }
            },
          ),
        ]),
      ),
    ));
  }
}
