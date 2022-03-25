import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_me_partner/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class ComplaintList extends StatefulWidget with ChangeNotifier{
  final String image, address;
  final double startLatitude, startLongitude, endLatitude, endLongitude;
  final bool isFirst;

  ComplaintList(
      {Key? key,
      required this.image,
      required this.address,
      required this.startLatitude,
      required this.startLongitude,
      required this.endLatitude,
      required this.endLongitude,
      required this.isFirst,})
      : super(key: key);

  @override
  _ComplaintListState createState() => _ComplaintListState();
}

class _ComplaintListState extends State<ComplaintList> {

  @override
  Widget build(BuildContext context) {

    final locationProvider = Provider.of<LocationProvider>(context);

    Future<double> getDistance() async {
      double _distance = Geolocator.distanceBetween(
        locationProvider.latitude,
        locationProvider.longitude,
        widget.endLatitude,
        widget.endLongitude,
      ) / 1000;
      return double.parse(_distance.toStringAsFixed(2));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.isFirst ? Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: 40,
              color: Colors.grey[300],
              height: 2,
            ),
          ),
        ) : Container(),
        widget.isFirst ? Container(
          padding: const EdgeInsets.only(top: 5.0, left: 10, bottom: 10),
          child: const Text(
            "Nearby Complaints",
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ) : Container(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: GestureDetector(
            onTap: () {},
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 8,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10.0),
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: CachedNetworkImageProvider(widget.image),
                  ),
                ),
                title: Text(
                  widget.address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                trailing: FutureBuilder(
                  future: getDistance(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      return Text("${snapshot.data} km");
                    }
                    return const Text("");
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
