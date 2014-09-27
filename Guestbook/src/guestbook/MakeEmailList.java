package guestbook;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import javax.jdo.PersistenceManager;
import javax.jdo.PersistenceManagerFactory;
import javax.servlet.http.*;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;
import static com.googlecode.objectify.ObjectifyService.ofy;

@SuppressWarnings("serial")

public class MakeEmailList extends HttpServlet {
	
	static{
		ObjectifyService.register(EmailAddress.class);
	}
	
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
              throws IOException {
    	 
    	UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        
        //Key userKey = KeyFactory.createKey("user", user.getEmail());
        //Entity subscriber = new Entity("Subscriber", userKey);
        //subscriber.setProperty("user", user.getEmail());
        
        EmailAddress subscribe = new EmailAddress(user.getEmail(), user.getNickname());
        ofy().save().entity(subscribe).now();
 
        //DatastoreService subList = DatastoreServiceFactory.getDatastoreService();
        //subList.put(subscriber);
        
        resp.sendRedirect("subscribed.jsp");
        
    }
    
    public void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

    	UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();

        //Key userKey = KeyFactory.createKey("user", user.getEmail());
        //Entity subscriber = new Entity("Subscriber", userKey);
        //subscriber.setProperty("user", user.getEmail());
        EmailAddress unsubscribe = new EmailAddress(user.getEmail(), user.getNickname());
        ofy().delete().entity(unsubscribe).now();
      
    	resp.sendRedirect("unsubscribe.jsp");
    }
}