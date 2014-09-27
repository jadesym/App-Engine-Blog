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
    List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
    if (greetings.isEmpty()) {
        %>
        <div class="jumbotron" style="background-repeat:no-repeat; background-size: 100%; background-image: url('http://www.green-solar-power.info/images/sky%20banner.jpg');">
        <h2><b>ShenFu Weather Blog: Make a post! </b></h2>
        </div>
        <%
    } else {
        %>
        <div class="jumbotron" style="background-repeat:no-repeat; background-size: 100%; background-image: url('http://www.green-solar-power.info/images/sky%20banner.jpg');">
        <h2><b>ShenFu Weather Blog</b></h2>
        </div>
        
        
        <%

    }
%>

<%
 if (user != null) {
	 %>
 
    <form action="/sign" method="post">
    <div><h3>Want to make a post? Write one down below!</h3></div>
      <div class="form-group row">
      	    <label class="control-label col-lg-1 col-lg-offset-3"><h4>Title of Post</h4></label>
      		<div class="col-lg-5" style="text-align: left;">
      			<input type="text" style="height: 35px; width: 500px;" name="titleOfPost" placeholder=" Title of Your Post">
      		</div>
      </div>
      <div class="form-group row">
        <label class="control-label col-lg-1 col-lg-offset-3"><h4>Content of Post</h4></label>
      	<div class="col-lg-5">
      		<textarea name="content" rows="5" cols="110" placeholder= "Write your text here!"></textarea>
      	</div>
      </div>
      <br>
      <div><button type="submit" class="btn btn-primary" style="border-radius: 20px;"><h4 style="padding: 0;">Post Entry</h4></button></div>
      <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
    </form>
    <form action="/guestbook.jsp" method="post">
          <div><button class="btn btn-warning" style="border-radius: 20px;"><h4 style="padding: 0;">Cancel Entry</h4></button></div>
    
    </form>

 <% } %>
  </body>
</html>