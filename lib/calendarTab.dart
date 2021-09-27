

import 'package:flutter/material.dart';
import 'package:kickstarter/addPledge.dart';
import 'package:kickstarter/addProject.dart';
import 'package:kickstarter/calendar.dart';
import 'package:kickstarter/showMore.dart';

///
/// A tab for the project calendar and its related navigation
///
class CalendarTab extends StatefulWidget
{
	late final _CalendarTabState _state;
	
	@override
	_CalendarTabState createState()
	{
		_state = _CalendarTabState();
		return _state;
	}
	
	void goToHome()
	{
		_state.goToHome();
	}
}

class _CalendarTabState extends State<CalendarTab>
{
	late BuildContext navContext;
	Calendar calendarPage = Calendar();
	
	@override
	Widget build( BuildContext context )
	{
		return Navigator
		(
			onGenerateRoute: ( RouteSettings settings )
			{
				return MaterialPageRoute
				(
					settings: settings,
					builder: ( BuildContext navContext )
					{
						this.navContext = navContext;
						switch( settings.name)
						{
							case '/addProject':
								return AddProjectScreen();
							case '/showMore':
								return ShowMoreScreen();
							case '/addPledge':
								return AddPledgeScreen();
							case '/calendar':
							default:
								return calendarPage;
						}
					}
				);
			},
		);
	}
	
	///
	/// Reset the route of this tab to the home page
	///
	void goToHome()
	{
		Navigator.pushNamed( navContext, '/calendar' );
	}
}