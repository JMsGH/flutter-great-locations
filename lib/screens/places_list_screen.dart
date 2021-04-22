import 'package:flutter/material.dart';
import 'package:flutter_great_locations/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';

import '../screens/add_place_screen.dart';
import '../providers/great_places.dart';
import '../screens/place_detail_screen.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('心に残った場所'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<GreatPlaces>(
                child: Center(
                  child: Text('訪問地がまだ追加されていません'),
                ),
                builder: (ctx, greatPlaces, ch) => greatPlaces.items.length <= 0
                    ? ch
                    : ListView.builder(
                        itemCount: greatPlaces.items.length,
                        itemBuilder: (ctx, i) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                FileImage(greatPlaces.items[i].image),
                          ),
                          title: Text(greatPlaces.items[i].title),
                          subtitle: Text(greatPlaces.items[i].location.address),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              PlaceDetailScreen.routeName,
                              arguments: greatPlaces.items[i].id,
                            );
                            // Go to detail page...
                          },
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.purple,
                            ),
                            onPressed: () async {
                              // ダイアログを表示
                              await showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('確認'),
                                      content: Text('この場所を削除しますか？'),
                                      actions: [
                                        TextButton(
                                          child: Text('いいえ'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('はい'),
                                          onPressed: () async {
                                            try {
                                              await Provider.of<GreatPlaces>(
                                                      context,
                                                      listen: false)
                                                  .deletePlace(
                                                      greatPlaces.items[i].id);
                                              Navigator.of(context).pop();
                                            } catch (error) {
                                              Navigator.of(context).pop();
                                              scaffoldMessenger.showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '削除できませんでした。',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            color: Theme.of(context).errorColor,
                          ),
                        ),
                      ),
              ),
      ),
    );
  }
}
