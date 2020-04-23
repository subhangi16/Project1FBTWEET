<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query.Filter" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterOperator" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterPredicate" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery" %>
<%@ page import="com.google.appengine.api.datastore.Query.SortDirection" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" href="/css/tweet.css">
	
	<!-- Global site tag (gtag.js) - Google Analytics -->
	<script async src="https://www.googletagmanager.com/gtag/js?id=UA-153625153-1"></script>
	<script>  
		window.dataLayer = window.dataLayer || [];  
		function gtag(){dataLayer.push(arguments);}  
		gtag('js', new Date());  
		gtag('config', 'UA-153625153-1');
	</script>
	
	<script type="text/javascript" src="/js/tweet.js"></script>
	<script type="text/javascript">callme();</script>
	<title>Friends' Tweets Page</title>
</head>
<body>
	<!-- Top Navigation Bar -->
	<div class="topnav">
  		<a href="tweet.jsp">Tweet</a>
  		<a href="friends.jsp">Friends</a>
  		<a id=toptweet href="topTweets.jsp">Top Tweets</a>

  		<div id="fb-root"></div>
  		<div align="right">
  			<div class="fb-login-button" data-max-rows="1" data-size="large" 
  	 			data-button-type="login_with" data-show-faces="false" 
  	 			data-auto-logout-link="true" data-use-continue-as="true" 
  	 			scope="public_profile,email" onlogin="checkLoginState();">
  	 		</div>
  		</div>
	</div>
	
	<!-- Button to get all of the friend's tweets  -->
	<br><br>
	<form action="friends.jsp" method="GET">
		<input type=hidden id=usr_id name=usr_id />
		<input type="submit" class="button" value="View All Friend's Tweets" name="view_tweets" />
	</form>

	<br>
	<h1>Friend's Tweets:</h1>
	<br><br>
	
	<script>
		document.getElementById("usr_id").value = getCookie('user_id');
	</script>
	
	<!-- Create a table to display all of friends tweets  -->
	<table id="friends_tweets">
		<tr>
			<th>#</th>			
			<th>Tweet Message</th>
			<th>Posted by</th>
			<th>Posted at</th>
			<th># of Visits</th>
		</tr>	

<%
	// Only display the friends tweets if the request contains the proper parameter
	if (request.getParameter("usr_id") != null){
				
		// Create a DatastoreService interface instance
		DatastoreService GAEDatastore = DatastoreServiceFactory.getDatastoreService();
		
		// Create a new query for entities whose kind is "tweet" and sort the query results
		Query TweetQuery = new Query("tweet").addSort("visited_count", SortDirection.DESCENDING);
		PreparedQuery prepQ = GAEDatastore.prepare(TweetQuery);
		int counter = 0;

		/* Loop through all of the tweet entity results and display the entities whose
		 * user_id field doesn't match the user_id of the current user */
		for (Entity output : prepQ.asIterable()) {
			if (output.getProperty("user_id") != null
				&& !((output.getProperty("user_id")).equals(request.getParameter("usr_id")))){
				String tweetMessage = (String) output.getProperty("status");
				String firstName = (String) output.getProperty("first_name");
				String lastName = (String) output.getProperty("last_name");
				String timestamp = (String) output.getProperty("timestamp");
				Long visitedCount = (Long) output.getProperty("visited_count");
				
				// Increment the visited_count field for each friends tweet
				Long id = (Long) output.getKey().getId();
				Entity tweet = GAEDatastore.get(KeyFactory.createKey("tweet", id));
				tweet.setProperty("visited_count", visitedCount + 1);
				GAEDatastore.put(tweet);
%>
	
			<tr>
				<td><%= ++counter%></td>
				<td><%= tweetMessage %></td>
				<td><%= firstName+" "+lastName %> </td>				  	
				<td><%= timestamp %></td>
				<td><%= visitedCount %></td>
			</tr>
			
<%  
			}
		}
	}
%>
						
	</table>
</body>
</html>