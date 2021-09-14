

import 'package:flutter/material.dart';
import 'package:kickstarter/addProject.dart';
import 'package:kickstarter/calendar.dart';

class HomeView extends StatefulWidget
{
	@override
	_HomeViewState createState() => _HomeViewState();
	
}

class _HomeViewState extends State<HomeView>
{	
	int _selectedIndex = 0;
	Calendar _calendarPage = new Calendar();
	
	@override
	Widget build( BuildContext context )
	{
		return Scaffold
		(
			body: IndexedStack
			(
				index: _selectedIndex,
				children: 
				[
					Text('Home'),
					_calendarPage,
				],
			),
			bottomNavigationBar: BottomNavigationBar
			(
				items: 
				[
					BottomNavigationBarItem
					(
						icon: Icon( Icons.home ),
						label: "Home",
					),
					BottomNavigationBarItem
					(
						icon: Icon( Icons.calendar_today ),
						label: "Projects",
					),
				],
				currentIndex: _selectedIndex,
				onTap: _pageTapped,
			),
		);
	}
	
	void _pageTapped( int index )
	{
		setState( ()
		{
			_selectedIndex = index;
		});
	}
	
	// Widget _pages( int index )
	// {
	// 	if( index == 0 )
	// 	{
	// 		return Text( "Home" );
	// 	}
	// 	else if( index == 1 )
	// 	{
	// 		return _calendarPage;
	// 	}
	// 	else
	// 	{
	// 		return new AddProjectScreen();
	// 	}
	// }
}