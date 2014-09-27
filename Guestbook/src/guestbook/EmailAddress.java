package guestbook;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.google.appengine.api.datastore.Key;
import com.googlecode.objectify.Ref;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;

@Entity

public class EmailAddress {

	//Custom constructor to populate the attributes of the entity
	//Note that id is not explicitly set, as AppEngine auto-generates this field
    	public EmailAddress (String e, String k) {
		this.id = k;
		this.email = e;
	}
    
    	//Must declare a default constructor for AppEngine's internal use
    	public EmailAddress(){}
    
    	//Id value for simple entity retrieval
	
    	@Id String id;
    	
	
	//We set this field annotation as indexed so we can filter results on this value
    	@Index  String email;
    	//String key;   
}
