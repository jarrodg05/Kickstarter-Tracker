import 'package:flutter/material.dart';
import 'projects.dart';

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
				Row( children: [Text('Name'), SizedBox(child: TextField( controller: _name,),width: 400,)]),
				TextField( controller: _publisher ),
				TextField( controller: _link, ),
				TextButton( onPressed: () {selectDate(context);}, child: _dateText ),
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
		
		String dateString = _date!.month.toString() + _date!.year.toString() ;
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
			link: link
		);
		
		ProjectsDatabase.database.addProject( project );
		
		
		Navigator.pop( context );
	}
}