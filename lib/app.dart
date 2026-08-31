import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:api_server/core/constants/app_strings.dart';
import 'package:api_server/core/theme/app_theme.dart';
import 'package:api_server/features/home/cubit/endpoints_cubit.dart';
import 'package:api_server/features/home/cubit/server_cubit.dart';
import 'package:api_server/features/home/view/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => EndpointsCubit()),
        BlocProvider(create: (_) => ServerCubit()),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        themeMode: AppTheme.themeMode,
        home: const HomePage(),
      ),
    );
  }
}
