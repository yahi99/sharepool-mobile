import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'currency.dart';

class CurrencyDropdown extends StatefulWidget {
  Function onSaved;

  CurrencyDropdown({this.onSaved});

  @override
  _CurrencyDropdownState createState() => _CurrencyDropdownState();
}

class _CurrencyDropdownState extends State<CurrencyDropdown> {
  Currency dropdownValue = Currency.EUR;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Currency>(
      onChanged: (Currency newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      value: dropdownValue,
      items: [
        DropdownMenuItem<Currency>(
          child: Text("€ (EUR)"),
          value: Currency.EUR,
        ),
        DropdownMenuItem<Currency>(
          child: Text("\$ (USD)"),
          value: Currency.USD,
        ),
        DropdownMenuItem<Currency>(
          child: Text("£ (GBP)"),
          value: Currency.GBP,
        )
      ],
      onSaved: widget.onSaved,
    );
  }
}
