import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:kickstarter/projects.dart';

import 'projects.dart';
import 'date.dart';

class ProjectListItem extends StatelessWidget
{
	final Widget image;
	final String name;
	final String publisher;
	final DateTime date;
	final String link;

	const ProjectListItem(
	{
		Key? key,
		required this.image,
		required this.name,
		required this.publisher,
		required this.date,
		required this.link,
	}) : super( key: key );

	@override
	Widget build( BuildContext context )
	{
		Padding padding = Padding
		(
			padding: const EdgeInsets.fromLTRB( 5.0, 0.0, 0.0, 0.0 ),
			child: Row(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: <Widget>[
					Expanded(
						child: image,
						flex: 2
					),
					Expanded(
						child: _ProjectDescription(
							title: name,
							publisher: publisher,
							releaseDate: date, 
							),
						flex: 3,
					),
					const Icon(
						Icons.more_vert,
						size: 16.0
					),
				],
			),
		);
		
		return new GestureDetector(
			onTap: ()
			{
				openBrowser( this.link );
			},
			child: padding,
		);
	}
}

openBrowser( String url ) async
{
	await FlutterWebBrowser.openWebPage( url: url );
}

class _ProjectDescription extends StatelessWidget
{
	final String title;
	final String publisher;
	final DateTime releaseDate;
	
	const _ProjectDescription(
	{
		Key? key,
		required this.title,
		required this.publisher,
		required this.releaseDate,
	}) : super( key: key );
	
	@override
	Widget build( BuildContext context )
	{
		return Padding
		(
			padding: const EdgeInsets.fromLTRB( 5.0, 0.0, 0.0, 0.0 ),
			child: Column
			(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: <Widget>
				[
					const Padding( padding: EdgeInsets.symmetric(vertical: 1.0)),
					Text
					(
						title,
						style: const TextStyle
						(
							fontWeight: FontWeight.w500,
							fontSize: 14.0,
						),
					),
					
					const Padding( padding: EdgeInsets.symmetric(vertical: 2.0) ),
					Text
					(
						publisher,
						style: const TextStyle( fontSize: 10.0 ),
					),
					
					const Padding( padding: EdgeInsets.symmetric(vertical: 1.0)),
					Text
					(
						'Arrives: ' + prettyPrint( releaseDate ),
						style: const TextStyle( fontSize: 10.0 ),
					),
					
					const Padding( padding: EdgeInsets.symmetric(vertical: 1.0)),
					Divider
					( 
						color: Colors.blue,
					)
				],
			),
		);
	}
}

List<ProjectListItem> getProjects()
{
	List<Project> projects = ProjectsDatabase.database.getProjects();
	List<ProjectListItem> projectsList = [];
	
	// create a list item for each project
	for( Project project in projects )
	{
		projectsList.add( ProjectListItem
		( 
			image: project.image,
			name: project.name,
			publisher: project.publisher,
			date: project.date,
			link: project.link
		) );
	}
	
	projectsList.sort( (a,b) => a.date.compareTo(b.date) );
	return projectsList;
}

Widget titleBar( BuildContext context )
{
	return Row
	(
		children: [
			Material(
				child: IconButton
				(
					onPressed: ()
					{
						CalendarPage.instance.addProject( context );
					},
					icon: Icon( Icons.add_circle ),
				),
			),
		],
		mainAxisAlignment: MainAxisAlignment.end,
	);
}

class CalendarPage extends State<Calendar>
{
	late Widget _calendar;
	static late final CalendarPage instance;
	late ListView projectList;
	bool loading = true;
	
	CalendarPage()
	{
		instance = this;
		projectList = projectListView();
	}
	
	Widget calendarPage()
	{
		return _calendar;
	}
	
	void reload()
	{
		setState(() 
		{
			loading = false;
			projectList = projectListView();
		});
	}
	
	Widget build( BuildContext context )
	{
		ProjectsDatabase.database.checkProjects( reload );

		if( loading )
		{
			return Text( "Loading" );
		}
		
		Container projects = Container
		(
			height: 244.0,
			child: projectList,
		);
		
		return Column
		(
			children: [
				titleBar( context ),
				projects,
			],
		);
	}
	
	ListView projectListView()
	{
		List<ProjectListItem> projects =  getProjects();
		return ListView.builder
		(
			itemCount: projects.length,
			itemBuilder: ( BuildContext context, int index) { return projects[index]; },
		);
	}
	
	
	void addProject( BuildContext context ) async
	{
		await Navigator.pushNamed( context, '/addProject' );
		// ProjectsDatabase.database.checkProjects();
		setState( () 
		{
			projectList = projectListView();
		});
	}
}

class Calendar extends StatefulWidget
{
	CalendarPage createState() => CalendarPage() ;
}

