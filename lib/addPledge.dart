

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kickstarter/pledge.dart';
import 'package:kickstarter/projects.dart';

class AddPledgeScreen extends StatefulWidget
{
	@override
	State<StatefulWidget> createState() => AddPledgeState();
}

class AddPledgeState extends State
{
	late Project project;
	late BuildContext context;
	
	TextEditingController _name = TextEditingController();
	TextEditingController _description = TextEditingController();
	TextEditingController _amount = TextEditingController();
	
	bool _pledged = false;
	bool _paid = false;

	@override
	Widget build( BuildContext context )
	{
		this.project = ModalRoute.of( context )!.settings.arguments as Project;
		this.context = context;
		
		return Scaffold
		(
			appBar: AppBar
			(
				title: Text( 'Add Pledge' ),
			),
			body: Center
			(
				child: pledgeFields(),
			),
		);
	}
	
	Widget pledgeFields()
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
		return TextField
		(
			controller: _name,
			decoration: new InputDecoration( labelText: "Pledge Name:" ),
		);
	}
	
	Widget descriptionField()
	{
		return TextField
		(
			controller: _description,
			decoration: new InputDecoration( labelText: "Pledge Description:" ),
		);
	}
	
	Widget amountField()
	{
		return TextField
		(
			controller: _amount,
			decoration: new InputDecoration( labelText: "Pledge Amount: \$" ),
			keyboardType: TextInputType.number,
			inputFormatters: [ FilteringTextInputFormatter.digitsOnly ],
		);
	}
	
	Widget pledgedCheckbox()
	{
		return CheckboxListTile
		(
			value: _pledged,
			onChanged: ( checked ) => 
			{
				setState( (){_pledged = checked!;} )
			},
			title: Text( "Pledged" ),
		);
	}
	
	Widget paidCheckbox()
	{
		return CheckboxListTile
		(
			value: _paid,
			onChanged: ( checked ) => 
			{ 
				setState( (){_paid = checked!;} )
			},
			title: Text( "Paid" ),
		);
	}
	
	Widget confirmField()
	{
		return Row
		(
			children: 
			[
				Text( 'Add Pledge: ' ),
				IconButton
				(
					onPressed: () { addPledge(); },
					icon: Icon( Icons.add_task )
				),
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
		
		this.project.addPledge( pledge );
		
		Navigator.pop( this.context );
	}
}