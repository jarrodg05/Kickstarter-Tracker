
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class SwapImage extends StatefulWidget
{
	final Future<String?> imageUrl;
	
	SwapImage( this.imageUrl );
	
	@override
	State<StatefulWidget> createState() => _SwapImageState( imageUrl );
}

class _SwapImageState extends State<SwapImage>
{
	Future<String?> imageUrl;
	late Widget image;
	
	_SwapImageState( this.imageUrl );
	
	@override
	void initState()
	{
		super.initState();
		
		this.image = FadeInImage.memoryNetwork( placeholder: kTransparentImage, image: 'https://ksr-static.imgix.net/tq0sfld-kickstarter-logo-green.png?ixlib=rb-2.1.0&s=0cce952d7b55823ff451a58887a0c578' );
		
		imageUrl.then( (url)
		{
			if( url != null )
			{
					this.image = FadeInImage.memoryNetwork( placeholder: kTransparentImage, image: url, height: 200, );
				if( this.mounted )
				{
				setState( ()
				{
				} );
				}
			}
		} );
	}
	
	@override
	Widget build( BuildContext context )
	{
		return this.image;
	}
}