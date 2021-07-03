
import 'package:flutter/material.dart';
import 'dart:convert';

class Project
{
	Widget image;
	String name;
	String publisher;
	DateTime date;
	String link;

	Project(
	{
		required this.image,
		required this.name,
		required this.publisher,
		required this.date,
		required this.link,
	});
	
	fromJson( Map<String, dynamic> json )
	{
		name = json['name'];
		publisher = json['publisher'];
		link = json['link'];
		date = json['date'];
	}
	
	Map<String, dynamic> toJson() =>
	{
		'name': name,
		'publisher': publisher,
		'link': link,
		'date': date,
	};
}

class ProjectsDatabase
{
	ProjectsDatabase._privateConstructor()
	{
		_projects.add( Project
		(
			publisher: 'Game Brewer',
			date: new DateTime( 2021, DateTime.september ),
			image: Container
			(
				decoration: const BoxDecoration( color: Colors.blue ),
			),
			name: 'Stroganov',
			link: 'https://www.kickstarter.com/projects/gamebrewer/stroganov',
		) );
		
		_projects.add( Project
		(
			publisher: 'Travis',
			date: new DateTime( 2021, DateTime.november ),
			image: Container
			(
				decoration: const BoxDecoration( color: Colors.yellow),
			),
			name: 'Aeons End',
			link: 'https://www.kickstarter.com/projects/ibcgames/aeons-end-legacy-of-gravehold',
		) );
	}
	
	static final ProjectsDatabase database = ProjectsDatabase._privateConstructor();
	
	List<Project> _projects = [];
	
	
	List<Project> getProjects()
	{
		print(_projects.length);
		return _projects;
	}
	
	void addProject( Project project )
	{
		_projects.add( project );
	}
}