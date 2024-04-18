import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:valentino/ui/constants.dart';
import 'package:valentino/utils/Validator.dart';

// as datetimepic;

class TableDialog extends StatefulWidget {
  TableDialog();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TableDialogState();
  }
}

class TableDialogState extends State<TableDialog> {
  String firstname = '';

  String phone = '';

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 79, 102, 59),
      insetPadding: EdgeInsets.all(30),
      title: const Column(
        children: [
          Text(
            'Забронировать столик',
            style: TextStyle(color: Color.fromARGB(248, 255, 255, 255)),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      content: SizedBox(
          width: width,
          height: height * 0.4,
          child: Column(children: [
            const Text(
              'С Вами свяжется наш менеджер и уточнит детали',
              style: TextStyle(
                  color: Color.fromARGB(239, 255, 255, 255), fontSize: 12),
            ),
            Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.only(top: height * 0.01)),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      cursorColor: Color.fromARGB(139, 255, 255, 255),
                      validator: (value) => Validator.isEmptyValid(value!),
                      onChanged: (String value) {
                        firstname = value;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(139, 255, 255, 255),
                                  width: 2.0)),
                          prefixIcon: const Icon(Icons.person_add,
                              color: Color.fromARGB(211, 255, 255, 255)),
                          labelText: 'Имя',
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(205, 255, 255, 255))),
                    ),
                    Padding(padding: EdgeInsets.only(top: height * 0.01)),
                    TextFormField(
                      cursorColor: const Color.fromARGB(139, 255, 255, 255),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))
                      ],
                      validator: (value) =>
                          Validator.isPhoneValid('8' + value!),
                      onChanged: (String value) {
                        phone = '8' + value;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(139, 255, 255, 255),
                                  width: 2.0)),
                          prefixIcon: const Icon(Icons.phone_iphone,
                              color: Color.fromARGB(211, 255, 255, 255)),
                          labelText: 'Телефон',
                          prefixText: '+7',
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(211, 255, 255, 255))),
                    ),
                    Padding(padding: EdgeInsets.only(top: height * 0.01)),

                    // BlocBuilder<AuthBloc, AuthState>(
                    //   builder: (context, state) {
                    //     if (state.message == 'Успех') {
                    //       Navigator.pop(context);
                    //     }
                    //     return Text(state.message,
                    //         style: TextStyle(color: Colors.red));
                    //   },
                    // ),

                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // <-- Radius
                            ),
                            elevation: 5,
                            minimumSize: Size(height * 0.75, width * 0.12),
                            backgroundColor: Colors.white),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          try {
                            final result =
                                await InternetAddress.lookup('google.com');
                            if (result.isNotEmpty &&
                                result[0].rawAddress.isNotEmpty) {}
                          } on SocketException catch (_) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Внимание'),
                                    content: Text('Нед доступа к Интернету'),
                                  );
                                });
                          }

                          if (!_formKey.currentState!.validate()) return;
                          print(phone);
                          Response response = await await Dio().post(
                              'http://91.222.236.176:8880/orders_info/reserve_table/',
                              data: {"name": firstname, "phone": phone});
                          Navigator.pop(context);
                        },
                        child: const Text('Отправить')),
                    Padding(padding: EdgeInsets.only(top: height * 0.001)),
                    TextButton(
                      child: const Text('Отмена',
                          style: TextStyle(
                              color: Color.fromARGB(210, 255, 255, 255),
                              fontSize: 14)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      '*Нажимая на кнопку «Отправить» вы даете согласие на обработку персональных данных',
                      style: TextStyle(
                          color: Color.fromARGB(209, 255, 255, 255),
                          fontSize: 8),
                    ),
                  ],
                ))
          ])),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );

    // TODO: implement build
  }
}
