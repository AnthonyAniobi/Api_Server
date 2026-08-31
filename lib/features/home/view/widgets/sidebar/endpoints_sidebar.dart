import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:api_server/core/constants/app_strings.dart';
import 'package:api_server/features/home/cubit/endpoints_cubit.dart';
import 'package:api_server/features/home/cubit/endpoints_state.dart';
import 'package:api_server/features/home/view/widgets/sidebar/add_endpoint_menu.dart';
import 'package:api_server/features/home/view/widgets/sidebar/endpoint_card.dart';

class EndpointsSidebar extends StatelessWidget {
  const EndpointsSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      color: Colors.white,
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  AppStrings.addEndpoints,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              AddEndpointMenu(),
            ],
          ),
          const Divider(
            color: Colors.grey,
            height: 20,
            thickness: 1,
          ),
          Expanded(
            child: BlocBuilder<EndpointsCubit, EndpointsState>(
              buildWhen: (previous, current) =>
                  previous.endpoints.length != current.endpoints.length,
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.endpoints.length,
                  itemBuilder: (context, index) => EndpointCard(listIndex: index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
