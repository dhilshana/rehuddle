import 'package:flutter/material.dart';
import 'package:rehuddle/utils/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(mainPadding),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                cursorColor: themeColor,
                decoration: InputDecoration(
                  
                  hintText: 'Search...',
                  filled: true,
                  fillColor: kGreyColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.search,))
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}