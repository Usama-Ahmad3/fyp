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
  List category = [];
  List categoryId = [];
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
    return FirebaseFirestore.instance.collection('categories').get();
  }

  searchTitles(List category) {
    ab.clear();
    for (int i = 0; i < category.length; i++) {
      for (var element in abc) {
        if (!(ab.contains(category[i][0].toString().toLowerCase())) &&
            element.toString().toLowerCase() == category[i][0].toLowerCase()) {
          ab.add(element);
        }
      }
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
                  category.clear();
                  for (var i in snapshot.data!.docs) {
                    category.add(i['name']);
                    categoryId.add(i['id']);
                  }
                  searchTitles(category);
                  return Column(
                    children: [
                      ...List.generate(abc.length, (mainIndex) {
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
                                        itemCount: category.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return category[index]
                                                  .toString()
                                                  .toLowerCase()
                                                  .startsWith(abc[mainIndex]
                                                      .toString()
                                                      .toLowerCase())
                                              ? searchWidget(
                                                  width: width,
                                                  height: height,
                                                  categoryName: category[index],
                                                  categoryId: categoryId[index],
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
