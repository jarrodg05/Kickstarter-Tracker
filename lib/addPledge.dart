

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kickstarter/pledge.dart';

class AddPledgeScreen extends StatefulWidget
{
	@override
	State<StatefulWidget> createState() => AddPledgeState();
}

class AddPledgeState extends State
{
	TextEditingController _name = TextEditingController();
	TextEditingController _description = TextEditingController();
	TextEditingController _amount = TextEditingController();
	
	bool _pledged = false;
	bool _paid = false;

	@override
	Widget build( BuildContext context )
	{
		return Scaffold
		(
			appBar: AppBar
			(
				title: Text( 'Add Pledge' ),
			),
			body: Center
			(
				child: pledgeFields( context ),
			),
		);
	}
	
	Widget pledgeFields( BuildContext context )
	{
		return Column
		(
			children: 
			[
				nameField(),
				Padding( padding: EdgeInsets.only(top: 20) ),
				descriptionField(),
				Padding( padding: EdgeInsets.only(top: 20) ),
				amountField(),
				Padding( padding: EdgeInsets.only(top: 20) ),
				pledgedCheckbox(),
				Padding( padding: EdgeInsets.only(top: 20) ),
				paidCheckbox(),
				Padding( padding: EdgeInsets.only(top: 20) ),
				confirmField(),
			],
		);
	}
	
	Widget nameField()
	{
		return Row
		(
			children: 
			[
				Text( 'Name: ' ),
				Padding( padding: EdgeInsets.only(left: 20) ),
				SizedBox( child: TextField(controller: _name,), width: 400, ),
			],
		);
	}
	
	Widget descriptionField()
	{
		return Row
		(
			children: 
			[
				Text( 'Description: ' ),
				Padding( padding: EdgeInsets.only(left: 20) ),
				SizedBox( child: TextField(controller: _description,), width: 400, ),
			],
		);
	}
	
	Widget amountField()
	{
		
		return TextField
		(
			controller: _amount,
			decoration: new InputDecoration( labelText: "Pledge Amount:" ),
			keyboardType: TextInputType.number,
			inputFormatters: [ FilteringTextInputFormatter.digitsOnly ],
		);
	}
	
	Widget pledgedCheckbox()
	{
		return Checkbox
		(
			value: _pledged,
			onChanged: (checked) => {_pledged = checked!},
		);
	}
	
	Widget paidCheckbox()
	{
		return Checkbox
		(
			value: _paid,
			onChanged: (checked) => {_paid = checked!},
		);
	}
	
	Widget confirmField()
	{
		return Row
		(
			children: 
			[
				Text( 'Add Pledge: ' ),
				IconButton( onPressed: () {addPledge();}, icon: Icon(Icons.add_task) )
			],
		);
	}
	
	addPledge()
	{
		String name = _name.text;
		String description = _description.text;
		int amount = int.parse( _amount.text );
		
		Pledge pledge = Pledge
		(
			name: name,
			amount: amount,
			description: description,
			pledged: _pledged,
			paid: _paid,
		);
		
	}
}