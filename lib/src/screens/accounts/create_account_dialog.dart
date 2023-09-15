import 'package:beldex_wallet/src/domain/services/wallet_service.dart';
import 'package:beldex_wallet/src/stores/account_list/account_list_store.dart';
import 'package:beldex_wallet/src/stores/settings/settings_store.dart';
import 'package:beldex_wallet/src/wallet/beldex/account.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAccountDialog extends StatefulWidget {
  CreateAccountDialog({Key? key, this.account,required this.accList}) : super(key: key);
  final Account? account;
  final List<Account> accList;

  @override
  State<CreateAccountDialog> createState() => _CreateAccountDialogState();
}

class _CreateAccountDialogState extends State<CreateAccountDialog>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  List<String> accnameList = [];

  @override
  void initState() {
    if (widget.account != null) _textController.text = widget.account!.label;
    WidgetsBinding.instance.addObserver(this);
    getAccList();
    super.initState();
  }

  void getAccList() {
    setState(() {
      if (widget.accList != null) {
        for (var i = 0; i < widget.accList.length; i++) {
          accnameList.add(widget.accList[i].label);
        }
      }
    });
    print(accnameList);
  }

  bool checkNameAlreadyExist(String accName) {
    return accnameList.contains(accName);
  }

  @override
  void dispose() {
    _textController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusManager.instance.primaryFocus?.unfocus();
    } else if (state == AppLifecycleState.resumed) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  bool validateInput(String input) {
    if (input.trim().isEmpty || input.startsWith(' ')) {
      // Value consists only of spaces or contains a leading space
      return false;
    }
    // Other validation rules can be applied here
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final settingsStore = Provider.of<SettingsStore>(context);
    final walletService = Provider.of<WalletService>(context);
    return Provider(
        create: (_) => AccountListStore(walletService: walletService),
        builder: (context, child) {
          final accountListStore = Provider.of<AccountListStore>(context);
          return Dialog(
            insetPadding: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: settingsStore.isDarkTheme
                ? Color(0xff272733)
                : Color(0xffFFFFFF),
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Add Account',
                      style: TextStyle(
                          fontSize: 18,
                          // fontFamily: 'Poppinsbold',
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        controller: _textController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: 'Account name',
                          hintStyle: TextStyle(color: Color(0xff77778B)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xff2979FB),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (!validateInput(value!) || value.length > 15) {
                            return 'Enter valid name upto 15 characters';
                          } else if (checkNameAlreadyExist(value)) {
                            return 'Account already exist';
                          } else {
                            accountListStore.validateAccountName(value);
                            return accountListStore.errorMessage;
                          }
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: MaterialButton(
                            onPressed: () => Navigator.pop(context),
                            elevation: 0,
                            color: settingsStore.isDarkTheme
                                ? Color(0xff383848)
                                : Color(0xffE8E8E8),
                            height:
                                MediaQuery.of(context).size.height * 0.18 / 3,
                            minWidth: MediaQuery.of(context).size.width / 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: settingsStore.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              if (!(_formKey.currentState?.validate() ?? false)) {
                                return ;
                              }
                              if (widget.account != null &&
                                  !checkNameAlreadyExist(
                                      _textController.text)) {
                                accountListStore.renameAccount(
                                    index: widget.account!.id,
                                    label: _textController.text);
                              } else if (checkNameAlreadyExist(
                                  _textController.text)) {
                                //return 'Account already exist';
                              } else {
                                accountListStore.addAccount(
                                    label: _textController.text);
                              }
                              Navigator.of(context).pop();
                            },
                            elevation: 0,
                            color: Color(0xff0BA70F),
                            height:
                                MediaQuery.of(context).size.height * 0.18 / 3,
                            minWidth: MediaQuery.of(context).size.width / 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              widget.account != null ? 'Rename' : 'Add',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
