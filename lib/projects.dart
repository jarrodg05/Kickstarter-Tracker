import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'pledge.dart';
class Project
{
	Widget image;
	String name;
	String publisher;
	DateTime date;
	String link;
	Pledges pledges;
	ProjectStatus status;

	Project(
	{
		required this.image,
		required this.name,
		required this.publisher,
		required this.date,
		required this.link,
		required this.status,
		pledges,
	}) : this.pledges = pledges ?? [];
	
	static fromJson( Map<String, dynamic> json )
	{
		try
		{
			return Project
			(
				image: Container( decoration: const BoxDecoration( color: Colors.blue ), ),
				name: json['name'],
				publisher: json['publisher'],
				link: json['link'],
				date: DateTime.parse( json['date'] ),
				pledges: Pledges.parse( json['pledges'] ),
				status: json['status'],
			);
		}
		catch( e )
		{
			// might be earlier version - pre status and pledges
			return Project
			(
				image: Container( decoration: const BoxDecoration( color: Colors.blue ), ),
				name: json['name'],
				publisher: json['publisher'],
				link: json['link'],
				date: DateTime.parse( json['date'] ),
				pledges: new Pledges( null ),
				status: ProjectStatus.Campaign,
			);
		}
	}
	
	Map<String, dynamic> toJson() =>
	{
		'name': name,
		'publisher': publisher,
		'link': link,
		'date': date.toString(),
		'pledges': pledges.toString(),
		'status': status.index,
	};
}

enum ProjectStatus
{
	PreLaunch,
	Campaign,
	Successful,
	LatePledge,
	Production,
	Shipping,
}

class ProjectsDatabase
{
	//////////////////////////////////////////////////
	//                 CONSTRUCTORS
	//////////////////////////////////////////////////
	ProjectsDatabase._privateConstructor()
	{
		loadProjects( null );
	}
	
	///////////////////////////////////////////////////////////
	//                  STATIC VARIABLES
	///////////////////////////////////////////////////////////
	static final ProjectsDatabase database = ProjectsDatabase._privateConstructor();
	
	///////////////////////////////////////////////////////////
	//                   INSTANCE VARIABLES
	///////////////////////////////////////////////////////////
	List<Project> _projects = [];
	final _projectFirebase = FirebaseFirestore.instance.collection( 'projects' )
		.withConverter<Project>
		(
			fromFirestore: ( snapshot, _ ) => Project.fromJson( snapshot.data()! ), 
			toFirestore: ( project, _ ) => project.toJson(),
		);
	
	bool upToDate = false;
	///////////////////////////////////////////////////////////
	//                INSTANCE METHODS
	///////////////////////////////////////////////////////////
	List<Project> getProjects()
	{
		return _projects;
	}
	
	bool checkProjects( void Function() reload )
	{
		if( !upToDate )
		{
			loadProjects( reload );
			return false;
		}
		return true;
	}
	
	void addProject( Project project ) async
	{
		upToDate = false;
		await _projectFirebase.add( project );
		loadProjects( null );
	}
	
	void loadProjects( void Function()? reload ) async
	{
		// TODO there is almost certainly a better way to do this
		await _projectFirebase
			.get()
			.then( (snapshot) {
				List<QueryDocumentSnapshot<Project>> projects = snapshot.docs;
				_projects = projects.map( (snapshot) => snapshot.data() ).toList();
				upToDate = true;
			
				if( reload != null )
				{
					reload.call();
				}
			});
	}
}