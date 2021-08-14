import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'pledge.dart';

/// a class that stores and manages/delegates all the information for a particular project
class Project
{
	String id;
	Widget image;
	String name;
	String publisher;
	DateTime date;
	String link;
	ProjectStatus status;
	Pledges pledges;

	Project(
	{
		required this.id, // kinda want this to be late, but it seems dart doesn't like it
		required this.image,
		required this.name,
		required this.publisher,
		required this.date,
		required this.link,
		required this.status,
		pledges,
	}) : this.pledges = pledges ?? Pledges( null );
	
	void addPledge( pledge )
	{
		pledges.addPledge( pledge );
		ProjectsDatabase.database.updatePledges( pledge, this.id, true );
	}
	
	/// load a project from a firestore document of that project
	static Project getFromFirestore( QueryDocumentSnapshot<Map<String,dynamic>> projectDocument )
	{
		return Project
		(
			image: Container( decoration: const BoxDecoration( color: Colors.blue ), ),
			name: projectDocument['name'],
			publisher: projectDocument['publisher'],
			link: projectDocument['link'],
			date: DateTime.parse( projectDocument['date'] ),
			status: getAsStatus( projectDocument['status'] ),
			id: projectDocument.id,
			pledges: Pledges.getFromFirestore( projectDocument.reference.collection('pledges') ),
		);
	}
	
	/// returns a map that can be used for storing this project in the firestore
	Map<String, dynamic> toMap()
	{
		return
		{
			'name': name,
			'publisher': publisher,
			'link': link,
			'date': date.toString(),
			'status': describeEnum( status ),
		};
	}
}

/// turn a stringified status into the enum
ProjectStatus getAsStatus( String value )
{
	return ProjectStatus.values.firstWhere( (element) => describeEnum(element) == value );
}

/// the current status of the project
enum ProjectStatus
{
	PreLaunch,
	Campaign,
	Successful,
	LatePledge,
	Production,
	Shipping,
	Delivered,
}

/// a class for handling the connection to the firestore that stores everything
class ProjectsDatabase
{
	//////////////////////////////////////////////////
	//                 CONSTRUCTORS
	//////////////////////////////////////////////////
	ProjectsDatabase._privateConstructor()
	{
		loadProjects( null );
	}
	
	//---------------------------------------------------------
	//                  STATIC VARIABLES
	//---------------------------------------------------------
	static final ProjectsDatabase database = ProjectsDatabase._privateConstructor();
	
	//---------------------------------------------------------
	//                   INSTANCE VARIABLES
	//---------------------------------------------------------
	List<Project> _projects = [];
	final _projectFirebase = FirebaseFirestore.instance.collection( 'projects' );
	
	bool upToDate = false;
	//---------------------------------------------------------
	//                    INSTANCE METHODS
	//---------------------------------------------------------
	
	/// returns the list of loaded projects, to be sure the list is up to date
	/// a call should be made to [checkProjects] first, which provides a way for
	/// a synchronus method to get the projects
	List<Project> getProjects()
	{
		return _projects;
	}
	
	/// check if the projects are up to date, and request an async reload if not,
	/// should be called prior to call to [getProjects]. If the projects need to be
	/// updated the reload function will be called once the projects are loaded 
	bool checkProjects( void Function() reload )
	{
		if( !upToDate )
		{
			loadProjects( reload );
			return false;
		}
		return true;
	}
	
	/// add a project to the firestore
	void addProject( Project project ) async
	{
		var doc = _projectFirebase.doc();
		project.id = doc.id;
		upToDate = false;
		
		await _projectFirebase.doc( project.id ).set( project.toMap() );
		CollectionReference<Map<String, dynamic>> pledgesCollection = _projectFirebase.doc( project.id ).collection( 'pledges' );
		project.pledges.addToFirestore(pledgesCollection);
		loadProjects( null );
	}
	
	// void updateProject( Map<String, Object> updates, String projectId ) async
	// {
	// 	upToDate = false;
		
	// 	await _projectFirebase.doc( projectId ).update( updates );
	// 	loadProjects( null );
	// }
	
	/// updates a pledge on a particular project
	void updatePledges( Pledge pledge, String projectId, bool newPledge )
	{
		if( newPledge )
		{
			_projectFirebase.doc( projectId )
				.collection( 'pledges' )
				.add( pledge.toMap() );
		}
		else
		{

		}
	}
	
	/// load the projects from the firestore
	void loadProjects( void Function()? reload ) async
	{
		// TODO there is almost certainly a better way to do this
		await _projectFirebase
			.get()
			.then( (snapshot) {
				List<QueryDocumentSnapshot<Map<String, dynamic>>> projects = snapshot.docs;
				_projects = projects.map( (snapshot) => Project.getFromFirestore(snapshot) ).toList();
				upToDate = true;
			
				if( reload != null )
				{
					reload.call();
				}
			});
	}
}