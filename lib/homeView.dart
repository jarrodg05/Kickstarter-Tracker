

import 'package:flutter/material.dart';
import 'calendarTab.dart';

class HomeView extends StatefulWidget
{
	@override
	_HomeViewState createState() => _HomeViewState();
	
}

class _HomeViewState extends State<HomeView>
{	
	int _selectedIndex = 0;
	CalendarTab _calendarTab = new CalendarTab();
	
	
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
					_calendarTab,
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
			if( _selectedIndex == index && index == 1 )
			{
				_calendarTab.goToHome();
			}
			_selectedIndex = index;
		});
	}
}
