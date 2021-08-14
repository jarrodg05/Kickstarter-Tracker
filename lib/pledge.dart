

import 'package:cloud_firestore/cloud_firestore.dart';

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
	
	Map<String, dynamic> toMap() =>
	{
		'name': name,
		'amount': amount,
		'description': description,
		'pledged' : pledged,
		'paid': paid,
	};
	
	static Pledge fromMap( Map<String, dynamic> json )
	{
		String name = json['name'];
		int amount = json['amount'];
		String description = json['description'];
		bool pledged = json['pledged'];
		bool paid = json['paid'];
		
		return new Pledge
		(
			name: name,
			amount: amount,
			description: description,
			pledged: pledged,
			paid: paid 
		);
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
	
	void addPledge( Pledge pledge )
	{
		pledges.add( pledge );
	}
	
	void removePledge( Pledge pledge )
	{
		pledges.remove( pledge );
	}
	
	void updatePledge( Pledge oldPledge, Pledge newPledge )
	{
		int index = pledges.indexOf( oldPledge );
		pledges.remove( oldPledge );
		pledges.insert( index, newPledge );
	}
	
	/// retrieve the pledges from the firestore
	static Pledges getFromFirestore( CollectionReference<Map<String, dynamic>> pledgesCollection )
	{
		Pledges pledges = new Pledges( null );
		pledgesCollection.get().then( (snapshot) 
		{
			List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.docs;
			for( QueryDocumentSnapshot<Map<String, dynamic>> doc in docs )
			{
				pledges.addPledge( Pledge.fromMap(doc.data()) );
			}
		});
		
		return pledges;
	}
	
	/// adds the pledges to the firestore
	void addToFirestore( CollectionReference<Map<String, dynamic>> pledgesCollection )
	{
		for( Pledge pledge in this.pledges )
		{
			// add the pledge if not in the firestore
			Query<dynamic> result = pledgesCollection.where( pledge.name );
			result.get().then( (snapshot) => 
			{
				if( snapshot.docs.isEmpty )
				{
					pledgesCollection.add( pledge.toMap() )
				}
			} );
		}
	}
}