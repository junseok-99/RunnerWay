import 'package:flutter/material.dart';
import 'package:frontend/controllers/filter_controller.dart';
import 'package:frontend/controllers/search_controller.dart';
import 'package:get/get.dart';

import '../../../widgets/course/course_card.dart';
import '../../../widgets/filter_condition.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final searchController = Get.find<SearchBarController>();

    final result = searchController.searchResults;

    return Obx(
      () {
        if (searchController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (result.isEmpty) {
          return Container(
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/empty.png',
                  height: 150,
                  width: 150,
                ),
                Text(
                  '검색 결과가 없습니다',
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          );
        }

        return Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '\'${searchController.searchText}\'으로 검색된',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        ' 코스 결과',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  // 페이지네이션 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 이전 페이지 버튼
                      if (searchController.currentPage.value > 1)
                        IconButton(
                          onPressed: () {
                            searchController.fetchPreviousPage(
                                searchController.searchText.value);
                          },
                          icon: Icon(Icons.navigate_before_rounded),
                        ),
                      SizedBox(width: 10),

                      // 페이지 번호 표시
                      Text(
                        '${searchController.currentPage.value} / ${searchController.totalPages.value}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 10),

                      // 다음 페이지 버튼
                      if (searchController.currentPage.value <
                          searchController.totalPages.value)
                        IconButton(
                          onPressed: () {
                            searchController.fetchNextPage(
                                searchController.searchText.value);
                          },
                          icon: Icon(Icons.navigate_next_rounded),
                        ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15),

              // ListView.builder without SingleChildScrollView
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: result.length + 1,
                  itemBuilder: (context, index) {
                    if (index == result.length) {
                      // SizedBox 추가
                      return SizedBox(
                        height: 100,
                      );
                    }
                    return CourseCard(course: result[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
