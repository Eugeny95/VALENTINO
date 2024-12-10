import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valentino/buisiness/all_sale_bloc/all_sales_bloc.dart';
import 'package:valentino/ui/all_sales_page/components/sale_card.dart';

import 'package:visibility_detector/visibility_detector.dart';

class AllSalesPage extends StatefulWidget {
  const AllSalesPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AllSalesPageState();
  }
}

class _AllSalesPageState extends State<AllSalesPage> {
  List<GlobalKey> globalKeys = [];
  @override
  void initState() {
    super.initState();
  }

  Widget generateItems(AllSalesState state) {
    // return ListView.builder(
    //     shrinkWrap: true,
    //     itemCount: state.allSalesHttpModel!.all_actions!.length,
    //     physics: const NeverScrollableScrollPhysics(),
    //     itemBuilder: (context, i) {
    //       GlobalKey globalKey = GlobalKey();

    //       globalKeys.add(globalKey);
    //       if (state.allSalesHttpModel!.all_actions!.isEmpty) {
    //         return const Column(
    //           children: [Text('В настоящее время акции не проводятся')],
    //         );
    //       }
    return AllSalesItem(
      // key: globalKey,
      sales: List.generate(
          state.allSalesHttpModel!.all_actions!.length,
          (index) => SaleCard(
                saleHttpModel: state.allSalesHttpModel!.all_actions![index],
              )),
    );
    // });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        color: const Color.fromARGB(0, 62, 62, 62),
        child: CustomScrollView(
          physics: const ScrollPhysics(),
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  BlocBuilder<AllSalesBloc, AllSalesState>(
                    builder: (context, state) {
                      return (state.allSalesStatus == AllSalesStatus.done)
                          ? generateItems(state)
                          : Column(
                              children: [
                                SizedBox(height: height * 0.4),
                                const Center(
                                    child: CircularProgressIndicator()),
                              ],
                            );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}