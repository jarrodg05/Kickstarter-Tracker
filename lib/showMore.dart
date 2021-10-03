import 'package:flutter/material.dart';

import 'date.dart';
import 'projects.dart';
import 'pledge.dart';

class ShowMoreScreen extends StatefulWidget
{
	@override
	State<StatefulWidget> createState() => ShowMoreState();
}

class ShowMoreState extends State
{
	late Project project;
	
	@override
	Widget build( BuildContext context ) 
	{
		this.project = ModalRoute.of( context )!.settings.arguments as Project;
		
		return Scaffold
		(
			appBar: appBar(context),
			body: Column
			( 
				children: 
				[
					arrivalWidget(),
					projectStatusWidget(),
					addPledgeWidget(),
					pledgeStatusWidget(),
					
				],
			),
		);
	}
	
	Widget arrivalWidget()
	{
		return Text( "Expected Arrival: " + prettyPrint(this.project.date) );
	}
	
	Widget projectStatusWidget()
	{
		return Text( "Project Status: " + this.project.status.toString() );
	}
	
	Widget pledgeStatusWidget()
	{
		Pledge? pledge = this.project.pledges.getPledge();
		if( pledge != null )
		{
			return Column
			(
				children: 
				[
					Text( pledge.name ),
					Text( pledge.amount.toString() ),
				]
			);
		}
		else
		{
			return Column
			(
				children: 
				[
					Text( "No Pledges Added" ),
				],
			);
		}
	}
	
	Widget addPledgeWidget()
	{
		return Row
		(
			children: 
			[
				Text( "Add New Pledge" ),
				Padding( padding: EdgeInsetsDirectional.only(start: 20) ),
				Material
				(
					child: IconButton
					(
						onPressed: ()
						{
							Navigator.pushNamed( context, '/addPledge', arguments: this.project );
						},
						icon: Icon( Icons.add ),
					),
				),
			],
		);
	}
	
	PreferredSizeWidget appBar( BuildContext context )
	{
		return AppBar
		(
			leading: Material
					(
						child: IconButton
						(
							onPressed: ()
							{
								editProject();
							},
							icon: Icon( Icons.edit ),
						),
						color: Colors.green,
					),
			title: Text( project.name ),
			actions: 
			[
				Material
				(
					child: IconButton
					(
						onPressed: ()
						{
							deleteProject();
						},
						icon: Icon( Icons.delete_forever ),
						color: Colors.white,
					),
					color: Colors.red,
				)
			],
			centerTitle: true,
		);
	}
	
	void editProject() async
	{
		final result = await Navigator.pushNamed( context, '/editProject', arguments: this.project );
		if( result != null )
		{
			setState( () 
			{
				this.project = result as Project;
			});
		}
	}
	
	void deleteProject()
	{
		ProjectsDatabase.database.deleteProject( this.project.id );
		Navigator.pop( context );
	}
}