import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:jagat_teknologi_indonesia_test/independent_controller/connectivity_controller/connectivity_state.dart';
import 'package:jagat_teknologi_indonesia_test/independent_controller/outlet/outlet_cubit.dart';
import 'package:jagat_teknologi_indonesia_test/independent_controller/user_account/user_account_cubit.dart';
import 'package:jagat_teknologi_indonesia_test/models/models.dart';
import 'package:jagat_teknologi_indonesia_test/pages/dashboard_page/dashboard_bloc.dart';
import 'package:jagat_teknologi_indonesia_test/pages/login_page/login_bloc.dart';
import 'package:jagat_teknologi_indonesia_test/pages/services_page/income_page/income_page_bloc.dart';
import 'package:jagat_teknologi_indonesia_test/pages/services_page/outcome_page/outcome_page_bloc.dart';
import 'package:jagat_teknologi_indonesia_test/pages/services_page/pindah_page/pindah_page_bloc.dart';
import 'package:jagat_teknologi_indonesia_test/pages/splash_screen/splash_bloc.dart';
import 'package:jagat_teknologi_indonesia_test/services/services.dart';
import 'package:jagat_teknologi_indonesia_test/shared/shared.dart';
import 'package:jagat_teknologi_indonesia_test/shared/widgets/outlet_card_widget/cubit/card_handler_cubit.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../independent_controller/background_service/background_service_bloc.dart';

part 'login_page/login_view.dart';
part 'dashboard_page/dashboard_view.dart';
part 'splash_screen/splash_view.dart';
part 'services_page/income_page/income_page_view.dart';
part 'services_page/outcome_page/outcome_page_view.dart';
part 'services_page/pindah_page/pindah_page_view.dart';
