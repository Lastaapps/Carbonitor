import 'package:carbonitor/src/cubits/today_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _HomeWidgetState();
  }
}

class _HomeWidgetState extends StatelessWidget {
  const _HomeWidgetState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => TodayCubit());
  }
}

class _HomeWidgetContent extends StatelessWidget {
  const _HomeWidgetContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
