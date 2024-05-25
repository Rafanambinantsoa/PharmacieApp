import 'dart:convert';

import 'package:MyPharmacie/controllers/ReservationController.dart';
import 'package:MyPharmacie/model/reservationRes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class MesReservations extends StatefulWidget {
  const MesReservations({super.key});

  @override
  State<MesReservations> createState() => _MesReservationsState();
}

class _MesReservationsState extends State<MesReservations> {
  final ReservationController _controller = Get.put(ReservationController());

  bool _isLoadingRes = false;
  int iCheck = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.getMyRes();
    });
    super.initState();
  }

  Future getCanceledRes(String eventId, int indx) async {
    setState(() {
      iCheck = indx;
    });
    Future.delayed(Duration(seconds: 2), () {});
    setState(() {
      _isLoadingRes = true;
    });
    var res = await _controller.cancelRes(eventId);
    if (res != null) {
      var caster = ReservationRes.fromJson(jsonDecode(res));
      if (caster.message == "success") {
        //actuliser la liste des reservations
        _controller.getMyRes();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Reservation annulée"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(caster.message),
          ),
        );
      }
    }
    setState(() {
      _isLoadingRes = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mes Reservations',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Obx(() {
              return _controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        _controller.getMyRes();
                      },
                      child: ListView.builder(
                        itemCount: _controller.listRes.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          var time = _controller.listRes.value[index].eventDate
                              .toString();
                          DateTime dateReserv = DateTime.parse(time);
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
                                    child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _controller
                                            .listRes.value[index].eventTilte,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                          // "le ${dateReserv.day}/${dateReserv.month}/${dateReserv.year} a ${dateReserv.hour}:${dateReserv.minute}",
                                          "Date : ${dateReserv.day}/${dateReserv.month}/${dateReserv.year}",
                                          style: const TextStyle(
                                              color: Colors.black54)),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          //Button with icons reservation
                                          ElevatedButton.icon(
                                            onPressed: () => getCanceledRes(
                                                _controller.listRes.value[index]
                                                    .eventId
                                                    .toString(),
                                                index),
                                            icon: (_isLoadingRes &&
                                                    iCheck == index)
                                                ? const SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator())
                                                : const Icon(
                                                    Icons.cancel_presentation),
                                            label: (_isLoadingRes &&
                                                    iCheck == index)
                                                ? const Text("En cours...")
                                                : const Text(
                                                    "Annuler ma reservation"),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
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
