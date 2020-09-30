import 'package:carg/models/player/player.dart';
import 'package:carg/services/player_service.dart';
import 'package:flutter/material.dart';

class APIMiniPlayerWidget extends StatefulWidget {
  final String playerId;
  final bool displayImage;

  APIMiniPlayerWidget({
    @required this.playerId,
    @required this.displayImage,
  });

  @override
  State<StatefulWidget> createState() {
    return _APIMiniPlayerWidgetState(playerId, displayImage);
  }
}

class _APIMiniPlayerWidgetState extends State<APIMiniPlayerWidget> {
  final PlayerService _playerService = PlayerService();
  final String _playerId;
  final bool _displayImage;

  _APIMiniPlayerWidgetState(this._playerId, this._displayImage);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Player>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.connectionState == ConnectionState.none &&
            snapshot.hasData == null) {}
        if (snapshot.data != null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: InputChip(
                  avatar: (snapshot.data.profilePicture != '' && _displayImage)
                      ? Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Theme.of(context).primaryColor,
                              ),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      snapshot.data.profilePicture))),
                        )
                      : null,
                  onPressed: () {},
                  label: Text(
                    snapshot.data.userName,
                    style: TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  )),
            ),
          );
        }
        return Text('error');
      },
      future: _playerService.getPlayer(_playerId),
    );
  }
}
