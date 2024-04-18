import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_layer/models/http_models/dish_http_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valentino/buisiness/auth_bloc/auth_bloc.dart';
import 'package:valentino/buisiness/basket_bloc/basket_bloc_bloc.dart';
import 'package:valentino/ui/constants.dart';

import 'package:valentino/ui/menu_page/components/select_dish_dialog.dart';

class MenuCategoryItem extends StatelessWidget {
  const MenuCategoryItem({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  final String title;
  final List items;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 0, left: 15),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              // fontFamily: 'Moniqa',
              color: Colors.white60,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GridView.count(
              padding: const EdgeInsets.all(5),
              crossAxisSpacing: 1,
              mainAxisSpacing: 3,
              childAspectRatio: 0.76,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: [...items],
            ))
        // Center(
        //   child: GridView(
        //     gridDelegate:
        //         SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        //     children: [...items],
        //     padding: const EdgeInsets.all(5),
        //     shrinkWrap: true,
        //     physics: const NeverScrollableScrollPhysics(),
        //   ),
        // )
      ],
    );
  }
}

class MenuCard extends StatelessWidget {
  final DishHttpModel dishHttpModel;
  const MenuCard({Key? key, required this.dishHttpModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //  BlocProvider.of<BasketBloc>(context);
    return GestureDetector(
        onTap: () {
          BasketBloc basketBloc = BlocProvider.of<BasketBloc>(context);
          AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return BlocProvider<AuthBloc>.value(
                  value: authBloc, //
                  child: BlocProvider<BasketBloc>.value(
                      value: basketBloc, //
                      child: SelectDishDialog(
                        dishHttpModel: dishHttpModel,
                      )));
            },
          );
        },
        child: Stack(children: [
          Container(
            width: width / 2.3,
            height: height / 3.6,
            padding: const EdgeInsets.only(top: 4.0),
            margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: kPrimaryColor),
            child: Column(children: [
              Container(
                width: width / 2.4,
                height: height / 7.6,
                // padding: const EdgeInsets.all(2), // Border width
                decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(15.0)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(70), // Image radius
                    child: CachedNetworkImage(
                        cacheKey: (dishHttpModel.imageLinks.isEmpty)
                            ? ''
                            : dishHttpModel.imageLinks.first,
                        useOldImageOnUrlChange: true,
                        fadeInDuration: Duration(milliseconds: 500),
                        fadeOutDuration: Duration(milliseconds: 0),
                        filterQuality: FilterQuality.low,
                        imageUrl:
                            //    'https://art-lunch.ru/content/uploads/2018/07/Greek_salad_01.jpg',
                            (dishHttpModel.imageLinks.isEmpty)
                                ? ''
                                : dishHttpModel.imageLinks.first,
                        placeholder: (context, url) => Container(
                            width: 50,
                            height: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                    child: Text(
                                  'Изображение загружается',
                                  textAlign: TextAlign.center,
                                )),
                                CircularProgressIndicator.adaptive(),
                              ],
                            )),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.005,
              ),
              SizedBox(
                height: height / 17,
                width: width * 0.41,
                child: Text(
                  dishHttpModel.name ?? '',
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    height: 0.97,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
                child: Row(children: [
                  SizedBox(
                    width: width / 40,
                  ),
                  // Вес блюда
                  (dishHttpModel.energyFullAmount != 0)
                      ? Text(
                          '${dishHttpModel.energyFullAmount!.toInt()} ккал',
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      : Container(),
                  SizedBox(
                    width: width * 0.005,
                  ),
                  (dishHttpModel.energyFullAmount != 0)
                      ? const Icon(Icons.circle,
                          size: 4, color: Color.fromARGB(189, 255, 255, 255))
                      : Container(),
                  // Энергетическая ценность
                  (dishHttpModel.weight != 0)
                      ? Text(
                          ' ${(dishHttpModel.weight! * 1000).toInt()} гр',
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      : Container()
                ]),
              ),
              SizedBox(
                height: height * 0.005,
              ),
              Container(
                width: width / 2.5,
                height: height / 22,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Color.fromARGB(246, 88, 88, 88)),
                  color: const Color.fromARGB(255, 246, 246, 246),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    '${dishHttpModel.currentPrice!.toInt()} ₽',
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color.fromARGB(204, 59, 59, 59),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ]));
  }
}
