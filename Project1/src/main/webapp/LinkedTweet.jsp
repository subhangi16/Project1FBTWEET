<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query.Filter" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterOperator" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterPredicate" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery" %>
<%@ page import="com.google.appengine.api.datastore.Query.SortDirection" %>
<%@ page import="java.util.List"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
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
	<script type="text/javascript" src="https://code.jquery.com/jquery-1.7.1.min.js"></script>
	<script type="text/javascript">callme()</script>
<title>View linked tweet here</title>
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
	
	<br>
	<br>
<%
		//fetch linked tweet from DataStore and display the tweet content 	
		DatastoreService GAEDatastore = DatastoreServiceFactory.getDatastoreService();
		if (request.getParameter("tweet_id") != null) {
			Entity tweet = GAEDatastore.get(KeyFactory.createKey("tweet", 
					Long.parseLong(request.getParameter("tweet_id"))));
			
			String tweetMessage = (String) tweet.getProperty("status");	
			String timestamp = (String) tweet.getProperty("timestamp");
			Long visitedCount = (Long) tweet.getProperty("visited_count");
			%>
			<table id="my_tweets">
			<tr>
				
				<th>Tweet Message</th>
				<th>Posted at</th>
				<th># of Visits</th>
			</tr>
			<tr>
				<td><%= tweetMessage %></td>			  	
				<td><%= timestamp %></td>
				<td><%= visitedCount %></td>
			</tr>
			</table>
			
<%  
		}else { %>
			<script type="text/javascript"> msg= "Tweet not found!";alert(msg); location.href="tweet.jsp";</script>
			<%
			}
		
 %>
</body>
</html>