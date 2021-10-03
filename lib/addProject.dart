import 'package:flutter/material.dart';
import 'projects.dart';
import 'date.dart';

class AddProjectScreen extends StatefulWidget
{
	@override
	_AddProjectState createState() => _AddProjectState();	
}

class _AddProjectState extends _ProjectFieldsState
{
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
				child: projectFields( context, _confirmWidget() ),
			),
		);
	}
	
	Widget _confirmWidget()
	{
		return Row
		(
			children: 
			[
				Text( 'Add to Tracker: ' ),
				IconButton( onPressed: () {_addProject();}, icon: Icon(Icons.add_task) )
			],
		);
	}
	
	void _addProject()
	{
		String name = super.name.text;
		String publisher = super.publisher.text;
		String link = super.link.text;
		DateTime date = super.date!;
		
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

class EditProjectScreen extends StatefulWidget
{
	EditProjectScreen();
	
	@override
	_EditProjectState createState() => _EditProjectState();
}

class _EditProjectState extends _ProjectFieldsState
{
	late Project project;
	
	_EditProjectState() : super();
	
	@override
	Widget build( BuildContext context )
	{
		return Scaffold
		(
			appBar: AppBar
			(
				title: Text( 'Edit Project' ),
			),
			body: Center
			(
				child: projectFields( context, _confirmWidget() ),
			),
		);
	}
	
	@override
	void didChangeDependencies()
	{
		this.project = ModalRoute.of( context )!.settings.arguments as Project;
		super.didChangeDependencies();
		
		fillFields( project );
	}
	
	Widget _confirmWidget()
	{
		return Row
		(
			children: 
			[
				Text( 'Save Changes: ' ),
				IconButton( onPressed: () {_editProject();}, icon: Icon(Icons.add_task) )
			],
		);
	}
	
	void _editProject()
	{
		String name = this.name.text;
		String publisher = this.publisher.text;
		String link = this.link.text;
		DateTime date = this.date!;
		
		// TODO add validation of inputs beofer here
		
		this.project.name = name;
		this.project.publisher = publisher;
		this.project.date = date;
		this.project.link = link;
		
		ProjectsDatabase.database.updateProject( this.project.toMap(), this.project.id );
		Navigator.pop( context, this.project );
	}
}

abstract class _ProjectFieldsState extends State
{
	TextEditingController name = TextEditingController();
	TextEditingController publisher = TextEditingController();
	TextEditingController link = TextEditingController();
	DateTime? date;
	
	DateTime currentDate = DateTime( DateTime.now().year, DateTime.now().month );
	
	Text dateText = Text( "Pick Date" );
	
	_ProjectFieldsState();
	
	void fillFields( Project project )
	{
		name.text = project.name;
		publisher.text = project.publisher;
		link.text = project.link;
		date = project.date;
	}

	Widget projectFields( BuildContext context, Widget confirmWidget )
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
				confirmWidget,
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
				SizedBox( child: TextField(controller: name,), width: 400, ),
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
				SizedBox( child: TextField(controller: publisher,), width: 400, ),
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
				SizedBox( child: TextField(controller: link,), width: 400, ),
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
				TextButton( onPressed: () {selectDate(context);}, child: dateText ),
			],
		);
	}
	
	selectDate( BuildContext context ) async
	{
		this.date = await showDatePicker
		(
			context: context,
			initialDate: currentDate,
			firstDate: currentDate,
			lastDate: currentDate.add( Duration(days: 5*365) ),
			initialDatePickerMode: DatePickerMode.year,
		);
		
		String dateString = prettyPrint( date! );
		dateText = Text( dateString );
		setState(() {
			return;
		});
	}
}
