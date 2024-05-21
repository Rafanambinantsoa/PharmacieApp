import 'package:MyPharmacie/controllers/EventController.dart';
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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.getEvents();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const SearchBar()),
      body: Center(
        child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Obx(() {
              return _controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: _controller.events.value.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 136,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _controller.events.value[index].titre,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                      "${_controller.events.value[index].lieu} - ${_controller.events.value[index].heure.toString()} - ${_controller.events.value[index].date.toString()}",
                                      style: TextStyle(color: Colors.black54)),
                                  const SizedBox(height: 8),
                                  Text(
                                      _controller
                                          .events.value[index].description,
                                      style: TextStyle(color: Colors.black54)),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icons.bookmark_border_rounded,
                                      Icons.share,
                                      Icons.more_vert
                                    ].map((e) {
                                      return InkWell(
                                        onTap: () {},
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Icon(e, size: 16),
                                        ),
                                      );
                                    }).toList(),
                                  )
                                ],
                              )),
                            ],
                          ),
                        );
                      },
                    );
            })),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!_isActive)
          Text("Tous les événements",
              style: Theme.of(context).appBarTheme.titleTextStyle),
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
                        decoration: InputDecoration(
                            hintText: 'Rechercher un événement',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isActive = false;
                                  });
                                },
                                icon: const Icon(Icons.close))),
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
