import 'package:flutter/material.dart';

import '../config/config.dart';

Widget aboutus() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        const Center(
            child: Text(
          "We provide catering services",
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
        )),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset("assets/images/banner.jpg"),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "About Restaurant",
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          "Doaba Indian Restaurant offers delicious dining and takeout to Powell, OH.",
          style: AppConfig.greytext,
        ),
        Text(
          "Doaba Indian Restaurant is a cornerstone in the Powell community and has been recognized for its outstanding Indian cuisine, excellent service and friendly staff.",
          style: AppConfig.greytext,
        ),
        Text(
          "Our Indian restaurant is known for its modern interpretation of classic dishes and its insistence on only using high quality fresh ingredients.",
          style: AppConfig.greytext,
        ),
        const SizedBox(
          height: 5.0,
        ),
        Container(
          color: Colors.red.shade400,
          padding: const EdgeInsets.all(4.0),
          child: Column(children: [
            Text(
              'We believe that nothing brings people together better than good food – and no matter who are sharing our meal with at that moment, we are all family. This philosophy permeates how we treat you, our customer the second you walk in through the door, you are part of our family.',
              style: AppConfig.whitetext,
            ),
            Text(
                'We use the finest, freshest ingredients to make the most authentic Indian cuisine for our family.',
                style: AppConfig.whitetext),
            Text(
              'We strive to create food that you will like and will do everything to make it right. Try any of our food, ranging from our Tandoor items to delicious Entree & Biryanis  you will want more.',
              style: AppConfig.whitetext,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Note : ",
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              'That all our foods are made fresh to-order and take time to crate-',
              style: AppConfig.whitetext,
            ),
            Text(
              'please allow some time minutes after placing your order either online for carry out or dine-in!',
              style: AppConfig.whitetext,
            ),
            Text(
              'We make the Naan bread from Eggless Dough',
              style: AppConfig.whitetext,
            )
          ]),
        )
      ],
    ),
  );
}
