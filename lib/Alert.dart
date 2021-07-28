import 'package:cool_alert/cool_alert.dart';

class Alert {
  static sucessAlert({ctx, text, title, ontap}) {
    return CoolAlert.show(
        barrierDismissible: false,
        context: ctx,
        type: CoolAlertType.success,
        text: text,
        title: title,
        onConfirmBtnTap: ontap);
  }

  static errorAlert({ctx, text}) {
    return CoolAlert.show(
        barrierDismissible: true,
        context: ctx,
        type: CoolAlertType.error,
        title: "Oops...",
        text: text ?? 'Some thing went wrong !!');
  }

  static loadingAlert({ctx}) {
    return CoolAlert.show(
      barrierDismissible: false,
      context: ctx,
      type: CoolAlertType.loading,
      text: "Loading please wait....",
    );
  }
}
