import 'package:flutter/material.dart';

import '../Shared/custom_app_bar.dart';
import '../theme/custom_text_style.dart';
import '../theme/theme_helper.dart';

class Chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: CustomAppBar(title: 'Messages'),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(" Groups",
                          style: CustomTextStyles.titleSmallff0e7491),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                groupChat(context),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(" Chats",
                          style: CustomTextStyles.titleSmallff0e7491),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                PersonalChat(context),
              ],
            ),
          )),
    );
  }
}

Widget PersonalChat(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      children: [
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: Image.network(
                      'https://r2.starryai.com/results/911754633/bccb46bd-67fe-47c7-8e5e-3dd39329d638.webp',
                      height: 50,
                      width: 49,
                    ).image,
                  ),
                ),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      _buildHeader(context, name: "Kokii", Time: "10:30PM"),
                      SizedBox(height: 8),
                      Text(
                        'Hi!!',
                        // style: Theme.of(context).textTheme.bodyText2,
                      )
                    ]))
              ],
            );
          },
        )
      ],
    ),
  );
}

Widget groupChat(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      children: [
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemCount: 4,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 25,
                    child: Text('G${index + 1}'),
                  ),
                ),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      _buildHeader(context,
                          name: "Group${index + 1}", Time: "10:30PM"),
                      SizedBox(height: 8),
                      Text(
                        'Hi!!',
                        // style: Theme.of(context).textTheme.bodyText2,
                      )
                    ]))
              ],
            );
          },
        )
      ],
    ),
  );
}

Widget _buildHeader(
  BuildContext context, {
  required String name,
  required String Time,
}) {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(name,
        style: CustomTextStyles.titleSmallTeal900
            .copyWith(color: appTheme.teal900)),
    Padding(
        padding: EdgeInsets.only(top: 3),
        child: Text(Time,
            style: CustomTextStyles.bodySmallTeal900
                .copyWith(color: appTheme.teal900)))
  ]);
}
