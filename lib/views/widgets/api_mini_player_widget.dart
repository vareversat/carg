import 'package:carg/models/player/player.dart';
import 'package:carg/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  String _errorMessage = '';

  _APIMiniPlayerWidgetState(this._playerId, this._displayImage);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Player>(
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.connectionState == ConnectionState.waiting) {
          child = Center(
            key: ValueKey(0),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: SpinKitThreeBounce(
                    size: 20,
                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(
                          decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                      ));
                    })),
          );
        }
        if (snapshot.hasData) {
          child = Center(
            key: ValueKey(2),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: InputChip(
                    avatar:
                        (snapshot.data.profilePicture != '' && _displayImage)
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
                    label: Text(snapshot.data.userName,
                        style: TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis))),
          );
        }
        if (!snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          child = Center(
            key: ValueKey(3),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: InputChip(
                    avatar: Container(
                        decoration: BoxDecoration(
                      color: Theme.of(context).errorColor,
                      shape: BoxShape.circle,
                    )),
                    label: Text(_errorMessage))),
          );
        }
        return AnimatedSwitcher(
            duration: Duration(milliseconds: 500), child: child);
      },
      future: _playerService.getPlayer(_playerId).catchError((error) => {
            setState(() {
              _errorMessage = error.toString();
            })
          }),
    );
  }
}
