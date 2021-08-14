import 'package:flutter/material.dart';
import 'projects.dart';
import 'date.dart';

class AddProjectScreen extends StatefulWidget
{
	@override
	_AddProjectScreenState createState() => _AddProjectScreenState();
}


class _AddProjectScreenState extends State<AddProjectScreen>
{
	TextEditingController _name = TextEditingController();
	TextEditingController _publisher = TextEditingController();
	TextEditingController _link = TextEditingController();
	DateTime? _date;
	
	DateTime _currentDate = DateTime( DateTime.now().year, DateTime.now().month );
	
	Text _dateText = Text( "Pick Date" );
	
	@override
	Widget build( BuildContext context )
	{
		return Scaffold
		(
			appBar: AppBar
			(
				title: Text( 'Add Project' ),
			),
			body: Center
			(
				child: projectFields( context ),
			),
		);
	}

	Widget projectFields( BuildContext context )
	{
		return Column
		(
			children:
			[
				nameField(),
				Padding( padding: EdgeInsets.symmetric(vertical: 10) ),
				publisherField(),
				Padding( padding: EdgeInsets.symmetric(vertical: 10) ),
				linkField(),
				Padding( padding: EdgeInsets.symmetric(vertical: 10) ),
				dateField(),
				Padding( padding: EdgeInsets.symmetric(vertical: 10) ),
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
	
	Widget publisherField()
	{
		return Row
		(
			children: 
			[
				Text( 'Publisher: ' ),
				Padding( padding: EdgeInsets.only(left: 20) ),
				SizedBox( child: TextField(controller: _publisher,), width: 400, ),
			],
		);
	}
		
	Widget linkField()
	{
		return Row
		(
			children: 
			[
				Text( 'Link: ' ),
				Padding( padding: EdgeInsets.only(left: 20) ),
				SizedBox( child: TextField(controller: _link,), width: 400, ),
			],
		);
	}
	
	Widget dateField()
	{
		return Row
		(
			children: 
			[
				Text( 'Arrival Date: ' ),
				TextButton( onPressed: () {selectDate(context);}, child: _dateText ),
			],
		);
	}
	
	Widget confirmField()
	{
		return Row
		(
			children: 
			[
				Text( 'Add to Tracker: ' ),
				IconButton( onPressed: () {addProject();}, icon: Icon(Icons.add_task) )
			],
		);
	}
	
	selectDate( BuildContext context ) async
	{
		_date = await showDatePicker
		(
			context: context,
			initialDate: _currentDate,
			firstDate: _currentDate,
			lastDate: _currentDate.add( Duration(days: 5*365) ),
			initialDatePickerMode: DatePickerMode.year,
		);
		
		String dateString = prettyPrint( _date! );
		_dateText = Text( dateString );
		setState(() {
			return;
		});
	}
	
	addProject()
	{
		String name = _name.text;
		String publisher = _publisher.text;
		String link = _link.text;
		DateTime date = _date!;
		
		Widget image = Container( decoration: const BoxDecoration(color: Colors.blue) );
		
		// TODO add validation of inputs beofer here
		
		Project project = Project
		(
			image: image,
			name: name,
			publisher: publisher,
			date: date,
			link: link,
			status: ProjectStatus.Campaign,
			id: "",
		);
		
		ProjectsDatabase.database.addProject( project );
		
		
		Navigator.pop( context );
	}
}