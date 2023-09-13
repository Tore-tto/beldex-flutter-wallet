import 'dart:ffi';

import 'package:beldex_wallet/l10n.dart';
import 'package:beldex_wallet/src/stores/settings/settings_store.dart';
import 'package:beldex_wallet/src/widgets/showSnackBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:beldex_wallet/palette.dart';
import 'package:beldex_wallet/routes.dart';
//import 'package:beldex_wallet/src/domain/common/crypto_currency.dart';
import 'package:beldex_wallet/src/screens/base_page.dart';
import 'package:beldex_wallet/src/stores/address_book/address_book_store.dart';
import 'package:beldex_wallet/src/widgets/beldex_dialog.dart';
import 'package:provider/provider.dart';
import 'package:beldex_wallet/src/util/constants.dart' as constants;

class AddressBookPage extends BasePage {
  AddressBookPage({this.isEditable = true});

  final bool isEditable;

  @override
  String getTitle(AppLocalizations t) => t.address_book;

  @override
  Widget? trailing(BuildContext context) {
    if (isEditable) return null;
    final addressBookStore = Provider.of<AddressBookStore>(context);
    return InkWell(
      onTap: () async {
        await Navigator.of(context).pushNamed(Routes.addressBookAddContact);
        await addressBookStore.updateContactList();
      },
      child: Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: Color(0xff0BA70F),
            shape: BoxShape.circle,
          ),
          margin: EdgeInsets.only(right: 15),
          child: Icon(
            Icons.add,
            color: Color(0xffffffff),
            size: 26,
          )),
    );
  }

  @override
  Widget body(BuildContext context) {
    final addressBookStore = Provider.of<AddressBookStore>(context);
    final settingsStore = Provider.of<SettingsStore>(context);
    return addressBookStore.contactList.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.36 / 3),
                //color: Colors.yellow,
                height: MediaQuery.of(context).size.height * 1 / 3,
                child: SvgPicture.asset(settingsStore.isDarkTheme
                    ? 'assets/images/new-images/address_empty_darktheme.svg'
                    : 'assets/images/new-images/address_empty_whitetheme.svg'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Container(
                    child: Text(
                  'No addresses in book',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      color: settingsStore.isDarkTheme
                          ? Color(0xff646474)
                          : Color(0xff82828D)),
                )),
              )
            ],
          )
        : Column(
            children: [
              Observer(
                  builder: (_) => Expanded(
                        child: Container(
                          child: ListView.builder(
                              itemCount: addressBookStore.contactList == null
                                  ? 0
                                  : addressBookStore.contactList.length,
                              itemBuilder: (BuildContext context, int index) {
                                final contact =
                                    addressBookStore.contactList[index];

                                return !isEditable
                                    ? Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.55 /
                                                3,
                                        width: double.infinity,
                                        margin: EdgeInsets.only(
                                            left: 15.0, right: 15, top: 10),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color(0xffDADADA),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color:
                                                      settingsStore.isDarkTheme
                                                          ? Color(0xff272733)
                                                          : Color(0xffEDEDED)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 8.0,
                                                    ),
                                                    child: Text(
                                                      contact.name,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop(contact);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0),
                                                      child: SvgPicture.asset(
                                                          'assets/images/new-images/send.svg',
                                                          color: settingsStore
                                                                  .isDarkTheme
                                                              ? Color(
                                                                  0xffffffff)
                                                              : Color(
                                                                  0xff16161D)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(contact.address,
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.05 /
                                                              3,
                                                      color: settingsStore
                                                              .isDarkTheme
                                                          ? Color(0xffFFFFFF)
                                                          : Color(0xff626262))),
                                            )
                                          ],
                                        ))
                                    : Slidable(
                                        key: Key('${contact.key}'),
                                        endActionPane: ActionPane(
                                            motion: const DrawerMotion(),
                                            children: [
                                              SlidableAction(
                                                label: 'Edit',
                                                backgroundColor: Colors.blue,
                                                foregroundColor:
                                                    settingsStore.isDarkTheme
                                                        ? Color(0xff171720)
                                                        : Color(0xffffffff),
                                                icon: Icons.edit,
                                                onPressed: (context) async {
                                                  await Navigator.of(context)
                                                      .pushNamed(
                                                          Routes
                                                              .addressBookAddContact,
                                                          arguments: contact);
                                                  await addressBookStore
                                                      .updateContactList();
                                                },
                                              ),
                                              SlidableAction(
                                                label: 'Delete',
                                                backgroundColor: Colors.red,
                                                icon: CupertinoIcons.delete,
                                                foregroundColor:
                                                    settingsStore.isDarkTheme
                                                        ? Color(0xff171720)
                                                        : Color(0xffffffff),
                                                onPressed: (context) async {
                                                  await showAlertDialog(context)
                                                      .then((isDelete) async {
                                                    if (isDelete) {
                                                      await addressBookStore
                                                          .delete(
                                                              contact: contact);
                                                      await addressBookStore
                                                          .updateContactList();
                                                    }
                                                  });
                                                },
                                              ),
                                            ]),
                                        startActionPane: ActionPane(
                                            motion: const DrawerMotion(),
                                            dismissible: DismissiblePane(
                                              onDismissed: () async {
                                                await addressBookStore.delete(
                                                    contact: contact);
                                                await addressBookStore
                                                    .updateContactList();
                                              },
                                              confirmDismiss: () async {
                                                return await showAlertDialog(
                                                    context);
                                              },
                                            ),
                                            children: []),
                                        child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.55 /
                                                3,
                                            width: double.infinity,
                                            margin: EdgeInsets.only(
                                                left: 15.0, right: 15, top: 10),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color(0xffDADADA),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: settingsStore
                                                              .isDarkTheme
                                                          ? Color(0xff272733)
                                                          : Color(0xffEDEDED)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 8.0,
                                                        ),
                                                        child: Text(
                                                          contact.name,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          Clipboard.setData(
                                                              ClipboardData(
                                                                  text: contact
                                                                      .address));
                                                          displaySnackBar(
                                                              context,
                                                              'Copied'
                                                            );
                                                          print(
                                                              'address copied');
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 8.0),
                                                          child: SvgPicture.asset(
                                                              'assets/images/new-images/copy.svg',
                                                              color: settingsStore
                                                                      .isDarkTheme
                                                                  ? Color(
                                                                      0xffffffff)
                                                                  : Color(
                                                                      0xff16161D)),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(contact.address,
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.05 /
                                                              3,
                                                          color: settingsStore
                                                                  .isDarkTheme
                                                              ? Color(
                                                                  0xffFFFFFF)
                                                              : Color(
                                                                  0xff626262))),
                                                )
                                              ],
                                            )),
                                      );
                              }),
                        ),
                      )),
            ],
          );
  }

  Future<bool> showAlertDialog(BuildContext context) async {
    var result = false;
    await showConfirmBeldexDialog(context, 'Remove contact',
        'Are you sure that you want to remove selected contact?',
        onDismiss: (context) => Navigator.pop(context, false),
        onConfirm: (context) {
          result = true;
          Navigator.pop(context, true);
          //return result;
        });
    return result;
  }

  Future<bool> showNameAndAddressDialog(
      BuildContext context, String name, String address) async {
    var result = false;
    await showSimpleBeldexDialog(
      context,
      name,
      address,
      buttonText: 'Copy',
      onPressed: (context) {
        result = true;
        Navigator.of(context).pop(true);
      },
    );
    return result;
  }
}
