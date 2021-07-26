

class Pledge
{
	String name;
	String description;
	int amount;
	bool pledged = false;
	bool paid = false;
	
	Pledge(
	{
		required this.name,
		required this.amount,
		required this.description,
		required this.pledged,
		required this.paid,
	});
	
	@override
	String toString()
	{
		String string = "";
		string += "name:" + this.name + ",";
		string += "amount:" + this.amount.toString() + ",";
		string += "description:" + this.description + ",";
		string += "pledged:" + this.pledged.toString() + ",";
		string += "paid:" + this.paid.toString() + ",";
		return string;
	}
	
	static Pledge parse( String string )
	{
		String? name;
		int? amount;
		String? description;
		bool? pledged;
		bool? paid;
	
		// TODO this will be problematic if description can have commas
		List<String> elements = string.split(',');
		for( String element in elements )
		{
			List<String> keyValue = element.split( ":" );
			if( keyValue[0] == "name" )
			{
				name = keyValue[1];
			}
			else if( keyValue[0] == "amount" )
			{
				amount = int.parse( keyValue[1] );
			}
			else if( keyValue[0] == "description" )
			{
				description = keyValue[1];
			}
			else if( keyValue[0] == "pledged" )
			{
				pledged = keyValue[1] == "true";
			}
			else if( keyValue[0] == "paid" )
			{
				paid = keyValue[1] == "true";
			}
		}
		
		return Pledge( name: name!, amount: amount!, description: description!, pledged: pledged!, paid: paid! );
	}
}

class Pledges
{
	List<Pledge> pledges;
	
	Pledges( pledges ): this.pledges = pledges ?? [];
	
	Pledge? getPledge()
	{
		return pledges.length > 0 ? pledges[0] : null;
	}
	
	@override
	String toString()
	{
		String string = "";
		for( Pledge pledge in this.pledges )
		{
			string += pledge.toString();
			string += ";";
		}
		return string;
	}
	
	static Pledges parse( String string )
	{
		List<Pledge> pledges = [];
		List<String> pledgeStrings = string.split(";");
		for( String pledge in pledgeStrings )
		{
			pledges.add( Pledge.parse(pledge) );
		}
		
		return Pledges( pledges );
	}
}