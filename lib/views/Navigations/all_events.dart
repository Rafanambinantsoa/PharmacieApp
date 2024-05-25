import 'dart:convert';

import 'package:MyPharmacie/controllers/EventController.dart';
import 'package:MyPharmacie/model/reservationRes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class AllEvents extends StatefulWidget {
  const AllEvents({super.key});

  @override
  State<AllEvents> createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
  final EventController _controller = Get.put(EventController());
  bool _isLoadingRes = false;
  String _searchText = "";
  int iCheck = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.getEvents();
    });
    super.initState();
  }

  void _reservation(String eventId, int indx) async {
    setState(() {
      iCheck = indx;
    });
    Future.delayed(Duration(seconds: 2), () {});
    setState(() {
      _isLoadingRes = true;
    });
    var res = await _controller.reservation(eventId);
    if (res == null) {
      print("NULLE");
    } else {
      var caster = ReservationRes.fromJson(jsonDecode(res));
      setState(() {
        _isLoadingRes = false;
      });
      //Show a snackbar notification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(caster.message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: SearchBar(onSearch: (text) {
        setState(() {
          _searchText = text;
        });
      })),
      body: Center(
        child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Obx(() {
              var filteredEvents = _controller.events.value.where((event) {
                return event.titre
                        .toLowerCase()
                        .contains(_searchText.toLowerCase()) ||
                    event.lieu
                        .toLowerCase()
                        .contains(_searchText.toLowerCase()) ||
                    event.description
                        .toLowerCase()
                        .contains(_searchText.toLowerCase());
              }).toList();

              return _controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        _controller.getEvents();
                      },
                      child: ListView.builder(
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredEvents.length,
                        itemBuilder: (BuildContext context, int index) {
                          var time = filteredEvents[index].date.toString();
                          DateTime dateReserv = DateTime.parse(time);
                          return Container(
                            height: 141,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8.0),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xFFE0E0E0)),
                                borderRadius: BorderRadius.circular(8.0)),
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        filteredEvents[index].titre,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                          "${filteredEvents[index].lieu} - ${filteredEvents[index].heure.toString()} - ${dateReserv.day}/${dateReserv.month}/${dateReserv.year}",
                                          style: const TextStyle(
                                              color: Colors.black54)),
                                      const SizedBox(height: 8),
                                      Text(filteredEvents[index].description,
                                          style: const TextStyle(
                                              color: Colors.black54)),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          //Button with icons reservation
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              _reservation(
                                                  filteredEvents[index]
                                                      .id
                                                      .toString(),
                                                  index);
                                            },
                                            icon: (_isLoadingRes &&
                                                    iCheck == index)
                                                ? const SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator())
                                                : const Icon(Icons.add),
                                            label: (_isLoadingRes &&
                                                    iCheck == index)
                                                ? const Text("En cours...")
                                                : const Text("Réserver"),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
            })),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final Function(String) onSearch;
  const SearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  bool _isActive = false;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!_isActive)
          Text("Tous les événements",
              style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 250),
              child: _isActive
                  ? Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0)),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                            hintText: 'Rechercher un événement',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isActive = false;
                                    _searchController.clear();
                                    widget.onSearch("");
                                  });
                                },
                                icon: const Icon(Icons.close))),
                        onChanged: widget.onSearch,
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          _isActive = true;
                        });
                      },
                      icon: const Icon(Icons.search)),
            ),
          ),
        ),
      ],
    );
  }
}
