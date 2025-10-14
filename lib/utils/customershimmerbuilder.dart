// import 'package:sipefci/models/chartitemsmodel.dart';
import 'package:flutter/material.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:shimmer/shimmer.dart';

Column shimmerWidget(size) {
  return Column(
    children: [
      Expanded(
        child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  constraints: BoxConstraints(
                      maxHeight: size.height * .5, maxWidth: size.width),
                  child: Card(
                    elevation: 10.0,
                    // borderRadius: BorderRadius.circular(5.0),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      fit: StackFit.expand,
                      children: [
                        SizedBox(
                          // width: size.width * .8,
                          height: size.height * .49,
                          child: Shimmer.fromColors(
                            baseColor: primaryColourAlt,
                            highlightColor: primaryColour.withOpacity(.7),
                            period: const Duration(milliseconds: 2000),
                            child: const Card(
                              color: Colors.transparent,
                              child: GridTile(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              // width: size.width * .8,
                              height: size.height * .1,
                              color: primaryWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    ],
  );
}

Widget shimmerWidgetReports(size) {
  return Shimmer.fromColors(
    baseColor: const Color(0xFF39e0b5),
    highlightColor: primaryColour.withOpacity(.7),
    period: const Duration(milliseconds: 2000),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                    height: 8.0,
                    color: Colors.transparent,
                  ),
              physics: const ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              itemCount: 5,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: textColour.withOpacity(.4), width: .4),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(15.0),
                      child: ListTile(
                        leading: Image.asset(
                          "assets/logos/uoc_logo_transparent.png",
                          scale: 10.0,
                        ),
                        title: const SizedBox(width: 50),
                        subtitle: const SizedBox(width: 30),
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_right, size: 30.0),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    ),
  );
}

// Widget shimmerBarChart(size) {
//   return Shimmer.fromColors(
//     baseColor: const Color(0xFF39e0b5),
//     highlightColor: primaryColour.withOpacity(.7),
//     period: const Duration(milliseconds: 2000),
//     child: SfCartesianChart(
//       // Initialize category axis
//       primaryXAxis: CategoryAxis(),
//       primaryYAxis: NumericAxis(minimum: 0, maximum: 200, interval: 10),
//       // tooltipBehavior: _tooltip,
//       series: <ChartSeries<ChartItems, String>>[
//         BarSeries<ChartItems, String>(
//             // Bind data source
//             dataSource: [
//               ChartItems("Active", 100),
//               ChartItems("Pending", 150),
//               ChartItems("Resolved", 200),
//             ],
//             xValueMapper: (ChartItems sales, _) => sales.statusType,
//             yValueMapper: (ChartItems sales, _) => sales.length,
//             name: 'Reports',
//             color: Color.fromRGBO(8, 142, 255, 1)),
//       ],
//     ),
//   );
// }

Widget shimmerWidgetDropdown(size) {
  return Shimmer.fromColors(
    baseColor: primaryColour,
    highlightColor: secondaryColour2.withOpacity(.7),
    period: const Duration(milliseconds: 2000),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButtonFormField<String>(
          // child: DropdownButton<String>(
          isExpanded: true,
          // value: _disV,
          dropdownColor: fillColour,
          decoration: InputDecoration(
            filled: true,
            fillColor: primaryBronze,
            counterText: "",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: primaryBlack),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: primaryError,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: primaryColour,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: primaryBlack),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: primaryError,
              ),
            ),
            errorStyle: const TextStyle(color: primaryError),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            labelStyle: const TextStyle(color: primaryBlack),
          ),
          // hint: Text(variantParcel ?? ${localizationsInit(context)?.select}),
          style: const TextStyle(
            fontSize: 14,
          ),
          // icon: const Icon(
          //   CupertinoIcons.arrow_up_down,
          //   size: 17.5,
          // ),
          iconEnabledColor: primaryBlack,
          onChanged: (String? value) {},
          items: const [],
        )
      ],
    ),
  );
}

Widget shimmerWidgetListView(size) {
  return Shimmer.fromColors(
    baseColor: const Color(0xFF39e0b5),
    highlightColor: primaryColour.withOpacity(.7),
    period: const Duration(milliseconds: 2000),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ListView.separated(
          itemBuilder: (context, intValue) {
            return DropdownButtonFormField<String>(
              // child: DropdownButton<String>(
              isExpanded: true,
              // value: _disV,
              dropdownColor: fillColour,
              decoration: InputDecoration(
                filled: true,
                fillColor: primaryBronze,
                counterText: "",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: primaryBlack),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: primaryError,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: primaryColour,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: primaryBlack),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: primaryError,
                  ),
                ),
                errorStyle: const TextStyle(color: primaryError),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 0, minHeight: 0),
                labelStyle: const TextStyle(color: primaryBlack),
              ),
              // hint: Text(variantParcel ?? ${localizationsInit(context)?.select}),
              style: const TextStyle(
                fontSize: 14,
              ),
              // icon: const Icon(
              //   CupertinoIcons.arrow_up_down,
              //   size: 17.5,
              // ),
              iconEnabledColor: primaryBlack,
              onChanged: (String? value) {},
              items: const [],
            );
          },
          itemCount: 7,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const Divider(
            height: 8.0,
            color: Colors.transparent,
          ),
        )
      ],
    ),
  );
}
