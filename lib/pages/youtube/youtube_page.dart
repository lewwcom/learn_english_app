import 'package:flutter/material.dart';
import 'package:learn_english_app/models/channel_model.dart';
import 'package:learn_english_app/pages/youtube/search_page.dart';
import 'package:learn_english_app/services/api_youtube_service.dart';
import 'package:learn_english_app/pages/youtube/channel_page.dart';

class YoutubeScreen extends StatefulWidget {
  @override
  _YoutubeScreenState createState() => _YoutubeScreenState();
}

class _YoutubeScreenState extends State<YoutubeScreen> {
  List<Channel>? list_channel;
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Youtube Channel');
  @override
  void initState() {
    super.initState();
    _initListChannel();
  }

  _initListChannel() async {
    List<String> list_channel_id = [
      'UCLsI5-B3rIr27hmKqE8hi4w',
      'UCeTVoczn9NOZA9blls3YgUg',
      'UCKyTokYo0nK2OA-az-sDijA',
      'UC16niRr50-MSBwiO3YDb3RA',
      'UCAuUUnT6oDeKwE6v1NGQxug',
      'UCa35qyNpnlZ_u8n9qoAZbMQ',
      'UC0SW6B8NNOE6O0iaJfhn6uA',
      'UCWv7vMbMWH4-V0ZXdmDpPBA',
      'UCicjynhfFw2LiIQFnoS1JTw'
    ];
    List<Channel> allChanels = [];
    for (String channel_id in list_channel_id) {
      Channel channel =
          await APIGoogleYoutubeService.instance.fetchChannel(channel_id);
      allChanels.add(channel);
    }
    setState(() {
      list_channel = allChanels;
    });
  }

  _buildProfileInfo(Channel channel) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => ChannelScreen(channel))),
      child: Container(
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.all(20.0),
        height: 100.0,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 35.0,
              backgroundImage: NetworkImage(channel.profilePictureUrl),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    channel.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${channel.subscriberCount} subscribers',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customSearchBar,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (customIcon.icon == Icons.search) {
                    customIcon = const Icon(Icons.cancel);
                    customSearchBar = ListTile(
                      leading: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 28,
                      ),
                      title: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Type in youtube video...',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        onSubmitted: (String value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SearchScreen(value),
                              ));
                        },
                      ),
                    );
                  } else {
                    customIcon = const Icon(Icons.search);
                    customSearchBar = const Text('Youtube Channel');
                  }
                });
              },
              icon: customIcon)
        ],
      ),
      body: list_channel != null
          ? NotificationListener<ScrollNotification>(
              child: ListView.builder(
                  itemCount: list_channel?.length,
                  itemBuilder: (BuildContext context, int index) {
                    Channel channel = list_channel![index];
                    return _buildProfileInfo(channel);
                  }))
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor, // Red
                ),
              ),
            ),
    );
  }
}
