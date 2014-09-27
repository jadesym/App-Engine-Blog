<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
 
<html>
 <head>
   <link type="text/css" rel="stylesheet" href="/css/bootstrap.min.css" />
   
   <link type="text/css" rel="stylesheet" href="/css/bootstrap-theme.min.css" />
    <script src="/js/bootstrap.min.js"></script>
   <link type="text/css" rel="stylesheet" href="/css/blogposts.css" />
   
</head>
 
  <body>
 
<%
    String guestbookName = request.getParameter("guestbookName");
    if (guestbookName == null) {
        guestbookName = "Web Blog";
    }
    pageContext.setAttribute("guestbookName", guestbookName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
<nav class="navbar navbar-default" role="navigation" style="margin-bottom: 0px; margin: 10px 0px 10px 0px;">
  <div class="container-fluid">
    <div class="row"> <!-- Brand and toggle get grouped for better mobile display -->
      <p style="font-size: 30px;">Hello, ${fn:escapeXml(user.nickname)}! (You can
		<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
		 <form action="/subscribe" method="post">
          <div><button class="btn btn-warning" style="border-radius: 20px;"><h4 style="padding: 0;">Subscribe</h4></button></div>
    </form>
    <form action="/subscribe" method="get">
          <div><button class="btn btn-warning" style="border-radius: 20px;"><h4 style="padding: 0;">Unubscribe</h4></button></div>
    </form>
      </div>
  </div><!-- /.container-fluid -->
</nav>
<%
    } else {
%>
<nav class="navbar navbar-default" role="navigation" style="margin-bottom: 0px; padding: 10px;">
  <div class="container-fluid">
    <!-- Brand and toggle get grouped for better mobile display -->
	<p style="font-size: 30px;">Hello!
	<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
	to be able to post here.</p>
  </div><!-- /.container-fluid -->
</nav>
<%
    }
%>
 
<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.
    Query query = new Query("Greeting", guestbookKey).addSort("date", Query.SortDirection.DESCENDING);
    List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());
    if (greetings.isEmpty()) {
        %>
        <div class="jumbotron" style="background-repeat:no-repeat; background-size: 100%; background-image: url('http://www.green-solar-power.info/images/sky%20banner.jpg');">
        <h2><b>ShenFu Weather Blog Post List has no messages. </b></h2>
        </div>
        <%
    } else {
        %>
        <div class="jumbotron" style="background-repeat:no-repeat; background-size: 100%; background-image: url('http://www.green-solar-power.info/images/sky%20banner.jpg');">
        <h2><b>ShenFu Weather Blog Post List </b></h2>
        </div>
    <form action="/guestbook.jsp" method="post">
          <div><button class="btn btn-danger" style="border-radius: 20px;"><h4 style="padding: 0;">Take me back!</h4></button></div>
    
    </form>
        <%
        for (Entity greeting : greetings) {
            pageContext.setAttribute("greeting_title_of_post",
                    greeting.getProperty("title"));
        	pageContext.setAttribute("greeting_content",
                                     greeting.getProperty("content"));
        	pageContext.setAttribute("greeting_date", greeting.getProperty("date"));

            if (greeting.getProperty("user") == null) {
                %>
               
                <p>An anonymous person wrote:</p>
                <%
            } else {
                pageContext.setAttribute("greeting_user",
                                         greeting.getProperty("user"));
                %>
                <p style=" font-size: 20px;"><b style="color: orange;">${fn:escapeXml(greeting_user.nickname)}</b> wrote on ${fn:escapeXml(greeting_date)}:</p>
                <%
            }
            %>
            <h3 style="font-family: papyrus;"><b> ${fn:escapeXml(greeting_title_of_post)}</b></h3>
            <blockquote> ${fn:escapeXml(greeting_content)}</blockquote>
            <hr>
            <%

        }
    }
%>
<%
 if (user != null) {
	 %>
 
    <form action="/post.jsp" method="post">
    <div><h3>Want to make a post? Click the button below!</h3></div>
	
      <div><button type="submit" class="btn btn-primary" style="border-radius: 20px;"><h4 style="padding: 0;">Sure!</h4></button></div>
      <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
    </form>

 <% } %>
  </body>
</html>