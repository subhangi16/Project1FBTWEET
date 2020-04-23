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
	
	<script type="text/javascript" src="http://code.jquery.com/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="/js/tweet.js"></script>
	<script type="text/javascript">callme();</script>
	<title>Top Tweets Page</title>

</head>
<body>
	<!-- Top Navigation Bar -->
	<div class="topnav">
		<!-- List the Items in the Top Navigation Bar  -->
		<a href="tweet.jsp">Tweet</a> 
		<a href="friends.jsp">Friends</a> 
		<a id=toptweet href=topTweets.jsp>Top Tweets</a>

		<div id="fb-root"></div>
		<div align="right">
			<div class="fb-login-button" data-max-rows="1" data-size="large"
				data-button-type="login_with" data-show-faces="false"
				data-auto-logout-link="true" data-use-continue-as="true"
				scope="public_profile,email" onlogin="checkLoginState();"></div>
		</div>
	</div>

<h1>Top 10 most popular tweets from friends:</h1>
<br><br>

		<table id="top_tweets">
			  <tr>
			  	<th>#</th>
			    <th>Tweet Message</th>
			    <th>Posted by</th>
			    <th>Posted at</th>
			    <th># of Visits</th>
			  </tr>
			  
<%
	//creating query that sorts the tweets in descending order based on their visited_count
	DatastoreService GAEDatastore=DatastoreServiceFactory.getDatastoreService();

	Query TweetQuery=new Query("tweet").addSort("visited_count", SortDirection.DESCENDING);
	PreparedQuery prepQ = GAEDatastore.prepare(TweetQuery);

	int counter=0;
	//iterate through the sorted tweets to get 10 most popular tweets
	for (Entity output : prepQ.asIterable()) {
		if(counter < 10 && output.getProperty("user_id") != null){
			  String tweetMessage = (String) output.getProperty("status");
			  String firstName = (String) output.getProperty("first_name");
			  String lastName = (String) output.getProperty("last_name");			  
			  String timestamp = (String) output.getProperty("timestamp");
			  Long visitedCount = (Long)((output.getProperty("visited_count")));
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
%>
	</table>		
</body>
</html>