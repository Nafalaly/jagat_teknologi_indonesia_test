// ignore_for_file: file_names

part of '../screens.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: mainColor,
        body: Center(
          child: InkWell(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: ListView(
              children: [
                Container(
                  height: DeviceScreen.devHeight,
                  width: DeviceScreen.devWidth,
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Container(
                      height: 500,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: AssetImage(logoOnly))),
                          ),
                          Container(
                            constraints: const BoxConstraints(
                              minHeight: 250,
                              maxWidth: 400,
                            ),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 20),
                            child: loginComp(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginComp() {
    return BlocProvider(
      create: (context) => LoginBloc(
          connection: context.read<ConnectivityCubit>(),
          accountCubit: context.read<UserAccountCubit>()),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginIdleState) {
                if (state.inputState is LoginFormInteruptedByConnection) {
                  showWarning(
                      message: 'Tidak terhubung ke Internet',
                      color: Colors.black,
                      context: context,
                      onFinish: () {
                        context
                            .read<LoginBloc>()
                            .add(LoginConnectionWarningDismiss());
                      });
                }
                if (state.inputState is LoginFormBadInputState) {
                  showWarning(
                      message:
                          (state.inputState as LoginFormBadInputState).message,
                      context: context,
                      onFinish: () {
                        context.read<LoginBloc>().add(LoginDismissBadInput());
                      });
                } else if (state.inputState is LoginFormAccountNotFound) {
                  showWarning(
                      message: 'Username atau password Salah',
                      context: context,
                      onFinish: () {
                        context.read<LoginBloc>().add(LoginDismissBadInput());
                      });
                } else if (state is LoginSucessfullyState) {
                  //TODO GOTO PAGE
                }
              }
            },
            child: Column(
              children: [
                SizedBox(
                    child: Column(
                  children: [
                    Container(
                      width: DeviceScreen.devWidth,
                      margin:
                          const EdgeInsets.symmetric(horizontal: defaultMargin),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black)),
                      child: TextField(
                        controller: usernameController,
                        onChanged: (val) => context
                            .read<LoginBloc>()
                            .add(LoginFormUsernameChanged(username: val)),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: greyFontStyle,
                            hintText: "Username"),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: DeviceScreen.devWidth,
                      margin:
                          const EdgeInsets.symmetric(horizontal: defaultMargin),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black)),
                      child: TextField(
                        controller: passwordController,
                        onChanged: (val) => context
                            .read<LoginBloc>()
                            .add(LoginFormPasswordChanged(password: val)),
                        obscureText: (state as LoginIdleState).passwordVisible,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () => context.read<LoginBloc>().add(
                                    LoginPasswordFormVisibleChanged(
                                        visibleStatus: !state.passwordVisible)),
                                icon: Icon(
                                  state.passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: greyColor,
                                )),
                            border: InputBorder.none,
                            hintStyle: greyFontStyle,
                            hintText: "Password"),
                      ),
                    ),
                  ],
                )),
                Container(
                  margin: const EdgeInsets.only(
                      right: defaultMargin,
                      left: defaultMargin,
                      top: defaultMargin),
                  height: 60,
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            context.read<LoginBloc>().add(LoginAttempt(
                                username: usernameController.text,
                                password: passwordController.text));
                          },
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              backgroundColor:
                                  MaterialStateProperty.all(mainColor)),
                          child: Text(
                            'Login',
                            style: blackFontStyle.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
