import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
    required this.size,
    this.identity = "",
    this.treeCount,
  }) : super(key: key);

  final Size size;
  final String identity;
  final String? treeCount;

  // Pre-computed color selection for better performance
  Color? _getRatingColor() {
    if (treeCount == null) return fPrimaryBlackColour;

    final count = int.tryParse(treeCount!);
    if (count == null) return fPrimaryBlackColour;

    if (count >= 500) return fPrimaryPlatinumColour;
    if (count >= 200) return fPrimaryGoldColour;
    if (count >= 100) return fPrimarySilver;
    if (count >= 0) return fPrimaryBronze;

    return fPrimaryBlackColour;
  }

  // Memoized widget creation
  Widget _buildLogo() {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: Image.asset(
        "lib/libassets/logos/hcmslogo.png",
        fit: BoxFit.cover,
        scale: 12,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Pre-compute values outside of widget tree
    final ratingColor = _getRatingColor();
    final welcomeText = "Welcome, $identity";

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: _buildLogo(),
            title: const Text(
              "HCMS APP",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            subtitle: Text(
              welcomeText,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.verified_user),
              iconSize: 30.0,
              color: ratingColor,
              onPressed: () => userRatingDialogue(context, treeCount),
            ),
          ),
        ],
      ),
    );
  }
}