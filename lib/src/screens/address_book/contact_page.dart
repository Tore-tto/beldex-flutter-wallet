import 'package:beldex_wallet/src/stores/settings/settings_store.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:beldex_wallet/generated/l10n.dart';
import 'package:beldex_wallet/src/domain/common/contact.dart';
import 'package:beldex_wallet/src/domain/common/crypto_currency.dart';
import 'package:beldex_wallet/src/screens/base_page.dart';
import 'package:beldex_wallet/src/stores/address_book/address_book_store.dart';
import 'package:beldex_wallet/src/widgets/address_text_field.dart';
import 'package:beldex_wallet/src/widgets/beldex_dialog.dart';
import 'package:beldex_wallet/src/widgets/beldex_text_field.dart';
import 'package:beldex_wallet/src/widgets/primary_button.dart';
import 'package:beldex_wallet/src/widgets/scollable_with_bottom_section.dart';
import 'package:provider/provider.dart';

class ContactPage extends BasePage {
  ContactPage({this.contact});

  final Contact contact;

  @override
  String get title => S.current.addAddress;

@override
Widget trailing(BuildContext context){
  return Container();
}
  @override
  Widget body(BuildContext context) => ContactForm(contact,context);
}

class ContactForm extends StatefulWidget {
  ContactForm(this.contact, this.contxt);
  final Contact contact;
  final BuildContext contxt;
  @override
  State<ContactForm> createState() => ContactFormState();
}

class ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _contactNameController = TextEditingController();
  final _currencyTypeController = TextEditingController();
  final _addressController = TextEditingController();
  bool coinVisibility = false;
  final ScrollController _scrollController = ScrollController();
  List<String> addNameList=[];
  CryptoCurrency _selectedCrypto = CryptoCurrency.bdx;
  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _currencyTypeController.text = _selectedCrypto.toString();
    } else {
      _selectedCrypto = widget.contact.type;
      _contactNameController.text = widget.contact.name;
      _currencyTypeController.text = _selectedCrypto.toString();
      _addressController.text = widget.contact.address;
    }
    getAllAddressNames(widget.contxt);
  }

  @override
  void dispose() {
    _contactNameController.dispose();
    _currencyTypeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _setCurrencyType(BuildContext context) async {
    if (coinVisibility == false) {
      setState(() {
        coinVisibility = true;
      });
    } else {
      setState(() {
        coinVisibility = false;
      });
    }
    /* var currencyType = CryptoCurrency.all[0].toString();
    var selectedCurrency = CryptoCurrency.all[0];

    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return BeldexDialog(
              body: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(S.of(context).please_select,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.none,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .caption
                                .color))),
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 30),
                  child: Container(
                    height: 150.0,
                    child: CupertinoPicker(
                        backgroundColor: Theme.of(context).backgroundColor,
                        itemExtent: 45.0,
                        onSelectedItemChanged: (int index) {
                          selectedCurrency = CryptoCurrency.all[index];
                          currencyType = CryptoCurrency.all[index].toString();
                        },
                        children: List.generate(CryptoCurrency.all.length,
                            (int index) {
                          return Center(
                            child: Text(
                              CryptoCurrency.all[index].toString(),
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .caption
                                      .color),
                            ),
                          );
                        })),
                  ),
                ),
                PrimaryButton(
                  text: S.of(context).ok,
                  color:
                      Theme.of(context).primaryTextTheme.button.backgroundColor,
                  borderColor:
                      Theme.of(context).primaryTextTheme.button.decorationColor,
                  onPressed: () {
                    _selectedCrypto = selectedCurrency;
                    _currencyTypeController.text = currencyType;
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ));
        });*/
  }

bool validateInput(String input) {
  if (input.trim().isEmpty || input.startsWith(' ')) {
    // Value consists only of spaces or contains a leading space
    return false;
  }
  // Other validation rules can be applied here
  return true;
}




void getAllAddressNames(BuildContext context1){
    final addressBookStore = Provider.of<AddressBookStore>(context1);
    setState(() {
          for(var i=0;i<addressBookStore.contactList.length;i++){
            addNameList.add(addressBookStore.contactList[i].name);
          }  
        });
      
}



bool _checkName(String enteredName) {
    return addNameList.contains(enteredName);
}



  @override
  Widget build(BuildContext context) {
    final addressBookStore = Provider.of<AddressBookStore>(context);
    final settingsStore = Provider.of<SettingsStore>(context);
    return ScrollableWithBottomSection(
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 14.0),
              BeldexTextField(
                enabled: !coinVisibility,
                hintText: 'Enter name',
                controller: _contactNameController,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                    if(value == null || value == '' ){
                      return 'Name should not be empty';
                    }else if(!validateInput(value)){
                      return 'Enter a valid name';
                    }
                    if(_checkName(value) && widget.contact == null){
                      return 'This Name already Exist';
                    }
                  addressBookStore.validateContactName(value);
                  return addressBookStore.errorMessage;
                },
              ),
              SizedBox(height: 14.0),
              Visibility(
                visible: false,
                child: Stack(
                  children: [
                    Container(
                      child: InkWell(
                        onTap: () => _setCurrencyType(context),
                        child: IgnorePointer(
                          child: BeldexTextField(
                            controller: _currencyTypeController,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: coinVisibility,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 175,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                  offset: Offset(0.0, 2.0))
                            ],
                            border: Border.all(color: Colors.white),
                            color: Color.fromARGB(255, 31, 32, 39),
                            borderRadius: BorderRadius.circular(10)),
                        child: DraggableScrollbar.rrect(
                          padding: EdgeInsets.only(
                              left: 5, right: 5, top: 10, bottom: 10),
                          controller: _scrollController,
                          heightScrollThumb: 25,
                          alwaysVisibleScrollThumb: true,
                          backgroundColor: Theme.of(context)
                              .primaryTextTheme
                              .button
                              .backgroundColor,
                          child: ListView.builder(
                              itemCount: CryptoCurrency.all.length,
                              shrinkWrap: true,
                              controller: _scrollController,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () async {
                                    var currencyType =
                                        CryptoCurrency.all[0].toString();
                                    var selectedCurrency = CryptoCurrency.all[0];
                                    selectedCurrency = CryptoCurrency.all[index];
                                    currencyType =
                                        CryptoCurrency.all[index].toString();
                                    if (coinVisibility == false) {
                                      setState(() {
                                        coinVisibility = true;
                                      });
                                    } else {
                                      setState(() {
                                        coinVisibility = false;
                                      });
                                    }
                                    _selectedCrypto = selectedCurrency;
                                    _currencyTypeController.text = currencyType;
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 20.0, right: 20.0),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      elevation: _selectedCrypto ==
                                              CryptoCurrency.all[index]
                                          ? 2.0
                                          : 0.0,
                                      color: _selectedCrypto ==
                                              CryptoCurrency.all[index]
                                          ? Theme.of(context).backgroundColor
                                          : Color.fromARGB(255, 31, 32, 39),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        padding:
                                            EdgeInsets.only(top: 15, bottom: 15),
                                        child: Text(
                                          CryptoCurrency.all[index].toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: _selectedCrypto !=
                                                      CryptoCurrency.all[index]
                                                  ? Colors.grey.withOpacity(0.6)
                                                  : Theme.of(context)
                                                      .primaryTextTheme
                                                      .headline6
                                                      .color,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.0),
              AddressTextField(
                isActive: !coinVisibility,
                controller: _addressController,
                options: [AddressTextFieldOption.qrCode],
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  for(var items in addressBookStore.contactList) {
                    if (items.address.contains(value)) {
                      return 'The Address already Exist';
                    }
                  }
                  addressBookStore.validateAddress(value,
                      cryptoCurrency: _selectedCrypto);
                  return addressBookStore.errorMessage;
                },
              )
            ],
          ),
        ),
        bottomSection: Container(
          height: MediaQuery.of(context).size.height*0.35/3,
          //color: Colors.yellow,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
       
           GestureDetector(
            onTap:   coinVisibility ? null:() {
                    if (!coinVisibility) {
                      setState(() {
                        _selectedCrypto = CryptoCurrency.xmr;
                        _contactNameController.text = '';
                        _currencyTypeController.text =
                            _selectedCrypto.toString();
                        _addressController.text = '';
                      });
                    }
                  },
             child: Container(
                width: MediaQuery.of(context).size.height*0.60/3,
                margin: EdgeInsets.only(top:15,bottom:15),
                padding: EdgeInsets.only(left:10,right:10,top:15,bottom:15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:settingsStore.isDarkTheme ? Color(0xff383848) :Color(0xffE8E8E8)),
                  child:Text('Reset',textAlign:TextAlign.center, style: TextStyle(fontSize:17,fontWeight: FontWeight.bold,color: settingsStore.isDarkTheme ? Color(0xff93939B) :Color(0xff16161D)),)
              ),
           ),
             SizedBox(width: 5,),
             GestureDetector(
              onTap: coinVisibility ? null:() async {
                    if (!_formKey.currentState.validate()) {return; }
                  // if(validateInput(_contactNameController.text)){
                  //   return '';
                  // }
                    try {
                      if (widget.contact == null) {
                        final newContact = Contact(
                            name: _contactNameController.text,
                            address: _addressController.text,
                            type: _selectedCrypto);
                         
                          await addressBookStore.add(contact: newContact);
                        
                       
                      } else {
                        widget.contact.name = _contactNameController.text;
                        widget.contact.address = _addressController.text;
                        widget.contact
                            .updateCryptoCurrency(currency: _selectedCrypto);

                        await addressBookStore.update(contact: widget.contact);
                      }
                      Navigator.pop(context);
                    } catch (e) {
                      await showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Dialog(
                              elevation: 0,
                              backgroundColor: Theme.of(context).cardTheme.color,//Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)), //this right here
                              child: Container(
                                height: 170,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        e.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 45,
                                            ),
                                            SizedBox(
                                              width: 45,
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10)),
                                                  backgroundColor: Theme.of(context).cardTheme.shadowColor,//Color.fromRGBO(38, 38, 38, 1.0),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop(true);
                                                },
                                                child: Text(
                                                  S.of(context).ok,
                                                  style: TextStyle(color: Theme.of(context).primaryTextTheme.caption.color,),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                },
               child: Container(
                width: MediaQuery.of(context).size.height*0.60/3,
                margin: EdgeInsets.only(top:15,bottom:15),
                padding: EdgeInsets.only(left:10,right:10,top:15,bottom:15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:Colors.green),
                  child:Text('Add',textAlign:TextAlign.center, style: TextStyle(fontSize:17,fontWeight: FontWeight.bold,color: Color(0xffffffff)),)
            ),
             )
            ],
          ),
        ));
  }
}
