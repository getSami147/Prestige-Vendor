import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/models/getShopModel.dart';
import 'package:prestige_vender/utils/Constant.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/viewModel/weeksProvider.dart';
import 'package:provider/provider.dart';

class SelectWeeks extends StatefulWidget {
  final List<Week>? weeks;
  final bool isUpdate;

  const SelectWeeks({Key? key, this.weeks, required this.isUpdate})
      : super(key: key);

  @override
  State<SelectWeeks> createState() => _SelectWeeksState();
}

class _SelectWeeksState extends State<SelectWeeks> {
  bool _isInitialized = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
      ),
      child: Consumer<WeeksProvider>(
        builder: (context, provider, child) {
          if (!_isInitialized &&
              widget.isUpdate &&
              widget.weeks != null &&
              widget.weeks!.isNotEmpty) {
            provider.initializeTimings(widget.weeks!);
            _isInitialized = true;
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text("Select the Weeks.",
                        fontSize: textSizeLargeMedium,
                        fontWeight: FontWeight.w600)
                    .paddingTop(20),
                const Divider().paddingBottom(20),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.timings.keys.length,
                    itemBuilder: (context, index) {
                      String day = provider.timings.keys.elementAt(index);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text("$day:", fontWeight: FontWeight.w500),
                            Row(
                              children: [
                                buildTimeField(
                                    context, provider, day, "openTime"),
                                const SizedBox(width: 10),
                                buildTimeField(
                                    context, provider, day, "closeTime"),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                elevatedButton(
                  context,
                  onPress: () {
                    if (provider.timings.values.any((time) =>
                        time['openTime']!.isEmpty ||
                        time['closeTime']!.isEmpty)) {
                      Fluttertoast.showToast(
                          msg: "Please fill all the fields",
                          backgroundColor: Colors.orange);
                    } else {
                      // Navigator.pop(context, provider.timings);
                      List<Week> weeksList =
                          provider.timings.entries.map((entry) {
                        String day = entry.key;
                        String openTime = entry.value['openTime'] != null
                            ? provider
                                .convertTo12HourFormat(entry.value['openTime']!)
                            : 'Open Time'; // Default if not set
                        String closeTime = entry.value['closeTime'] != null
                            ? provider
                                .convertTo12HourFormat(entry.value['openTime']!)
                            : 'Close Time'; // Default if not set
                        return Week(
                            day: day, openTime: openTime, closeTime: closeTime);
                      }).toList();

                      Navigator.pop(context, weeksList);
                    }
                  },
                  child: text("Add Weeks",
                      color: white, fontWeight: FontWeight.w500),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildTimeField(BuildContext context, WeeksProvider provider,
      String day, String timeType) {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          String formattedTime = pickedTime.format(context);
          provider.setTiming(
              day,
              timeType == 'openTime'
                  ? formattedTime
                  : provider.timings[day]!['openTime']!,
              timeType == 'closeTime'
                  ? formattedTime
                  : provider.timings[day]!['closeTime']!);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey),
        ),
        child: text(
          provider.timings[day]?[timeType]?.isEmpty ?? true
              ? (timeType == 'openTime' ? "Open Time" : "Close Time")
              : provider.timings[day]![timeType]!,
          fontSize: 12.0,
          color: black,
        ),
      ),
    );
  }
}
