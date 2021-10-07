import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:kickstarter/projects.dart';

import 'package:http/http.dart' as http;
import 'package:kickstarter/swapImage.dart';
import 'package:transparent_image/transparent_image.dart';
import 'projects.dart';
import 'date.dart';

class ProjectListItem extends StatelessWidget
{
	final Project project;

	const ProjectListItem(
	{
		Key? key,
		required this.project,
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
						child: projectImage(),
						flex: 2
					),
					Expanded(
						child: _ProjectDescription(
							title: project.name,
							publisher: project.publisher,
							releaseDate: project.date, 
							),
						flex: 3,
					),
					const Icon(
						Icons.more_horiz,
						size: 16.0
					),
				],
			),
		);
		
		return new GestureDetector(
			onTap: ()
			{
				showMore( this.project, context );
			},
			child: padding,
		);
	}
	
	showMore( Project project, BuildContext context ) async
	{
		await Navigator.pushNamed( context, '/showMore', arguments: project );
		CalendarPage? page = context.findAncestorStateOfType();
		if( page != null )
		{
			page.reload();
		}
	}
	
	Widget projectImage()
	{
		if( this.project.link != "" )
		{
			// FadeInImage image = FadeInImage.memoryNetwork( placeholder: kTransparentImage, image: 'https://ksr-static.imgix.net/tq0sfld-kickstarter-logo-green.png?ixlib=rb-2.1.0&s=0cce952d7b55823ff451a58887a0c578' );
			// getImageUrl( this.project.link ).then( (imageUrl) => 
			// {
			// 	// if( imageUrl != null )
			// 	// {
			// 		image = FadeInImage.memoryNetwork( placeholder: kTransparentImage, image: imageUrl! )
			// 	// }
			// } );
			return SwapImage( getImageUrl(this.project.link) );
			// return image;
		}
		else
		{
			return this.project.image;
		}
	}
	
	Future<String?> getImageUrl( String projectUrl ) async 
	{
		// Download the content of the site
		Uri uri = Uri.parse( projectUrl );
		http.Response response = await http.get( uri, headers: { "Access-Control-Allow-Origin": "*" } );
		String html = response.body;
		
		// The html contains the following string exactly one time.
		// After this specific string the url of the profile picture starts. 
		String needle = '<meta name="image" property="og:image" content="';
		int index = html.indexOf(needle);
		
		// The result of indexOf() equals -1 if the needle didn't occurred in the html.
		// In that case the received username may be invalid.
		if (index == -1)
			return null;
		
		// Remove all characters up to the start of the text snippet that we want.
		html = html.substring(html.indexOf(needle) + needle.length);
		
		// return all chars until the first occurrence of '"'
		return html.substring(0, html.indexOf('"'));
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

ListView projectListView()
{
	List<ProjectListItem> projects =  getProjects();
	return ListView.builder
	(
		itemCount: projects.length,
		itemBuilder: ( BuildContext context, int index) { return projects[index]; },
	);
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
			project: project,
		) );
	}
	
	projectsList.sort( (a,b) => a.project.date.compareTo(b.project.date) );
	return projectsList;
}

class CalendarPage extends State<Calendar>
{
	ListView projectList;
	bool loading = true;
	
	CalendarPage() : this.projectList = projectListView();
	
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
		loading = ! ProjectsDatabase.database.checkProjects( reload );

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
	
	void addProject( BuildContext context ) async
	{
		await Navigator.pushNamed( context, '/addProject' );
		// ProjectsDatabase.database.checkProjects();
		setState( () 
		{
			projectList = projectListView();
		});
	}
	
	Widget titleBar( BuildContext context )
	{
		return Row
		(
			children: 
			[
				Material
				(
					child: IconButton
					(
						onPressed: ()
						{
							addProject( context );
						},
						icon: Icon( Icons.add_circle ),
						color: Colors.white,
					),
					color: Colors.green,
				),
			],
			mainAxisAlignment: MainAxisAlignment.end,
		);
	}
}

class Calendar extends StatefulWidget
{
	CalendarPage createState() => CalendarPage() ;
}

