import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kickstarter/homeView.dart';
import 'calendar.dart';

void main() {
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Flutter Demo',
			theme: ThemeData(
				primarySwatch: Colors.blue,
			),
			initialRoute: '/homePage',
			
			routes:
			{
				'/homePage': (context) => HomeView(),
			},
			debugShowCheckedModeBanner: false,
		);
	}
}

class MyHomePage extends StatefulWidget {
	MyHomePage({ Key? key, required this.title}) : super(key: key);

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
			return Text( "Error connecting, check internet connection!" );
		}
		
		if( !_initialized )
		{
			// return loading screen
		}
	
		return Calendar();
	}
	
}
