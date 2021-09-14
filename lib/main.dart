import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kickstarter/addPledge.dart';
import 'package:kickstarter/homeView.dart';
import 'package:kickstarter/showMore.dart';
import 'calendar.dart';
import 'addProject.dart';

void main() {
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Flutter Demo',
			theme: ThemeData(
				// This is the theme of your application.
				//
				// Try running your application with "flutter run". You'll see the
				// application has a blue toolbar. Then, without quitting the app, try
				// changing the primarySwatch below to Colors.green and then invoke
				// "hot reload" (press "r" in the console where you ran "flutter run",
				// or simply save your changes to "hot reload" in a Flutter IDE).
				// Notice that the counter didn't reset back to zero; the application
				// is not restarted.
				primarySwatch: Colors.blue,
			),
			// home: MyHomePage(title: 'Flutter Demo Home Page'),
			initialRoute: '/homePage',
			
			routes:
			{
				'/homePage': (context) => HomeView(),
				'/calendar': (context) => Calendar(),
				'/addProject': (context) => AddProjectScreen(),
				'/showMore': (context) => ShowMoreScreen(),
				'/addPledge': (context) => AddPledgeScreen(),
			},
		);
	}
}

class MyHomePage extends StatefulWidget {
	MyHomePage({ Key? key, required this.title}) : super(key: key);

	// This widget is the home page of your application. It is stateful, meaning
	// that it has a State object (defined below) that contains fields that affect
	// how it looks.

	// This class is the configuration for the state. It holds the values (in this
	// case the title) provided by the parent (in this case the App widget) and
	// used by the build method of the State. Fields in a Widget subclass are
	// always marked "final".

	final String title;

	@override
	_MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> 
{
	bool _initialized = false;
	bool _error = false;
	
	void initializeFirebase() async
	{
		try
		{
			await Firebase.initializeApp();
			setState( () 
			{
				_initialized = true;
			} );
		}
		catch( e )
		{
			setState( () 
			{
				_error = true;
			});
		}
	}
	
	@override
	void initState()
	{
		initializeFirebase();
		super.initState();
	}
	
	@override
	Widget build( BuildContext context )
	{
		if( _error )
		{
			// return error screen
		}
		
		if( !_initialized )
		{
			// return loading screen
		}
	
		return Calendar();
	}
	
}
