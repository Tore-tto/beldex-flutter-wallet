import 'package:beldex_wallet/l10n.dart';
import 'package:beldex_wallet/src/stores/settings/settings_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beldex_wallet/routes.dart';
import 'package:beldex_wallet/src/screens/base_page.dart';
import 'package:beldex_wallet/src/screens/auth/auth_page.dart';
import 'package:provider/provider.dart';

import '../../widgets/nav/new_nav_list_arrow.dart';

class ProfilePage extends BasePage {
  final _bodyKey = GlobalKey();

  @override
  String getTitle(AppLocalizations t) => t.settings_title;

  @override
  Widget trailing(BuildContext context){
    return Container(
      child: Icon(Icons.settings, color: Colors.transparent,),
    );
  }

  //Important -->
  /*@override
  Widget trailing(BuildContext context) {
    return SizedBox(
      width: 25,
      child: FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () => Navigator.of(context).pushNamed(Routes.settings),
          child: Icon(Icons.settings_rounded,
              color: Theme.of(context).primaryTextTheme.caption.color,
              size: 25)),
    );
  }*/

  @override
  Widget body(BuildContext context) => ProfilePageBody(key: _bodyKey);
}

class ProfilePageBody extends StatefulWidget {
  ProfilePageBody({Key? key}) : super(key: key);

  @override
  ProfilePageBodyState createState() => ProfilePageBodyState();
}

class ProfilePageBodyState extends State<ProfilePageBody> {
  @override
  Widget build(BuildContext context) {
     final settingsStore = Provider.of<SettingsStore>(context);
     final t= tr(context);
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        SizedBox(height: 30,),
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              margin:EdgeInsets.only(left:MediaQuery.of(context).size.width*0.4/3),
              child:Text(t.wallet,style: TextStyle(fontSize: 20.0, color:Color(0xff737385)),),
            ),
            NewNavListArrow(
              balanceVisibility: false,
                decimalVisibility: false,
                currencyVisibility: false,
                feePriorityVisibility: false,
                leading: SvgPicture.asset('assets/images/new-images/swallet.svg',width: 25,height: 25,
                    color: Theme.of(context).primaryTextTheme.headline6!.color),
                text: t.wallets,
                onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(Routes.walletList);}),
            NewNavListArrow(
                balanceVisibility: false,
                decimalVisibility: false,
                currencyVisibility: false,
                feePriorityVisibility: false,
                leading: SvgPicture.asset('assets/images/new-images/settingsnut.svg',width: 25,height: 25,
                    color:Theme.of(context).primaryTextTheme.headline6!.color
                    ),
                text: t.walletSettings,
                onTap: () =>
                    Navigator.of(context).pushNamed(Routes.settings)),
              
              Container(
              margin:EdgeInsets.only(left:MediaQuery.of(context).size.width*0.4/3,top:MediaQuery.of(context).size.width*0.3/3),
              child:Text(t.account,style: TextStyle(fontSize: 20.0, color:Color(0xff737385)),),
            ),
           // NewNavListHeader(title: S.current.wallet_menu),
            // NewNavListArrow(
            //     balanceVisibility: false,
            //     decimalVisibility: false,
            //     currencyVisibility: false,
            //     feePriorityVisibility: false,
            //     leading: SvgPicture.asset('assets/images/stake_svg.svg',width: 25,height: 25,
            //         color: Theme.of(context).primaryTextTheme.headline6.color),
            //     text: S.current.title_stakes,
            //     onTap: () =>
            //         Navigator.of(context).pushNamed(Routes.stake)),
            NewNavListArrow(
                balanceVisibility: false,
                decimalVisibility: false,
                currencyVisibility: false,
                feePriorityVisibility: false,
                leading: SvgPicture.asset('assets/images/new-images/settingsaddbook.svg',width: 25,height: 25,
                    color: Theme.of(context).primaryTextTheme.headline6!.color),
                text: t.address_book,
                onTap: () =>
                    Navigator.of(context).pushNamed(Routes.addressBook)),
            NewNavListArrow(
                balanceVisibility: false,
                decimalVisibility: false,
                currencyVisibility: false,
                feePriorityVisibility: false,
                leading: SvgPicture.asset('assets/images/new-images/settingsaccount.svg',width: 25,height: 25,
                    color: Theme.of(context).primaryTextTheme.headline6!.color),
                text:t.accounts,
                onTap: () =>
                    Navigator.of(context).pushNamed(Routes.accountList)),
            //Important -->
              Container(
              margin:EdgeInsets.only(left:MediaQuery.of(context).size.width*0.4/3,top:MediaQuery.of(context).size.width*0.3/3),
              child:Text(t.seedKeys,style: TextStyle(fontSize: 20.0, color:Color(0xff737385)),),
            ),
            //NewNavListHeader(title: S.current.dangerzone),
            NewNavListArrow(
                leading: Icon(Icons.vpn_key_rounded,
                    color: Theme.of(context).primaryTextTheme.headline6!.color),
                text: t.show_keys,
                onTap: () => Navigator.of(context).pushNamed(Routes.auth,
                    arguments: (bool isAuthenticatedSuccessfully,
                            AuthPageState auth) =>
                        isAuthenticatedSuccessfully
                            ? Navigator.of(auth.context)
                                .popAndPushNamed(Routes.dangerzoneKeys)
                            : null)),
            NewNavListArrow(
                leading: SvgPicture.asset('assets/images/new-images/settingsseed.svg',width: 25,height: 25,
                    color: Theme.of(context).primaryTextTheme.headline6!.color),
                text: t.show_seed,
                onTap: () => Navigator.of(context).pushNamed(Routes.auth,
                    arguments: (bool isAuthenticatedSuccessfully,
                            AuthPageState auth) =>
                        isAuthenticatedSuccessfully
                            ? Navigator.of(auth.context)
                                .popAndPushNamed(Routes.dangerzoneSeed)
                            : null)),
          ],
        ),
      ],
    ));
  }
}
