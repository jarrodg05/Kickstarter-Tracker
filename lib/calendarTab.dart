

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

// need this to be able to push routes from here down onto navigator
final GlobalKey<NavigatorState> navKey = GlobalKey();

class _CalendarTabState extends State<CalendarTab>
{	
	@override
	Widget build( BuildContext context )
	{
		return Navigator
		(
			key: navKey,
			onGenerateRoute: ( RouteSettings settings )
			{
				WidgetBuilder builder = ( BuildContext navContext )
				{
					switch( settings.name)
					{
						case '/addProject':
							return AddProjectScreen();
						case '/showMore':
							return ShowMoreScreen();
						case '/editProject':
							return EditProjectScreen();
						case '/addPledge':
							return AddPledgeScreen();
						case '/calendar':
						default:
							return Calendar();
					}
				};
				return MaterialPageRoute
				(
					settings: settings,
					builder: builder,
				);
			},
		);
	}
	
	///
	/// Reset the route of this tab to the home page
	///
	void goToHome()
	{
		navKey.currentState!.pushNamed( '/calendar' );
	}
}