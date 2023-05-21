import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlagsProvider with ChangeNotifier {
  bool _updatePosts = false;

  getupdatePosts() => _updatePosts;
  setupdatePosts() {
    this._updatePosts = !this._updatePosts;
    notifyListeners();
  }
}
