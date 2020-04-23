package com.fbgae;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.datastore.Query.FilterPredicate;
import com.google.appengine.api.datastore.Query.SortDirection;

/**
 * FbGaeDataStoreServlet to handle creating new tweets to add to the GAE
 * Datastore
 * 
 */
@SuppressWarnings("serial")
@WebServlet("/FbGaeDataStoreServlet")
public class FbGaeDataStoreServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public FbGaeDataStoreServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * doGet method to create a new "tweet" entity and add it to the GAE Datastore
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// pre-flight request processing
		response.addHeader("Access-Control-Allow-Origin", "*");
		response.addHeader("Access-Control-Allow-Methods", "GET");
		response.addHeader("Access-Control-Request-Method", "GET");
		// response.addHeader("Access-Control-Allow-Headers", "X-Requested-With,
		// Content-Type, Accept, Origin");

		// timestamp_format contains the format for the tweet entity's timestamp
		DateFormat timestamp_format = new SimpleDateFormat("MM/dd/yy, h:mm a");
		timestamp_format.setTimeZone(TimeZone.getTimeZone("America/Los_Angeles"));

		// current_date contains the current date that will become the tweet's timestamp
		// property
		Date current_date = new Date();

		/*
		 * GAEDatstore is an instance of the DatastoreService interface that provides
		 * synchronous access to the GAE Datastore
		 */
		DatastoreService GAEDatastore = DatastoreServiceFactory.getDatastoreService();

		// Create a new tweet entity message to add to the Datastore
		Entity message = new Entity("tweet");
		String timestamp = timestamp_format.format(current_date);

		// Set the properties of the tweet entity message
		message.setProperty("status", request.getParameter("text_content"));
		message.setProperty("user_id", request.getParameter("user_id"));
		message.setProperty("first_name", request.getParameter("first_name"));
		message.setProperty("last_name", request.getParameter("last_name"));
		message.setProperty("picture", request.getParameter("picture"));
		message.setProperty("visited_count", 0);
		message.setProperty("timestamp", timestamp);

		/*
		 * Create cookies for the application user's user_id, first name, last name, and
		 * profile picture and add them to the client response
		 */
		Cookie user_id = new Cookie("user_id", request.getParameter("user_id"));
		Cookie f_name = new Cookie("first_name", request.getParameter("first_name"));
		Cookie l_name = new Cookie("last_name", request.getParameter("last_name"));
		Cookie pic = new Cookie("picture", request.getParameter("picture"));

		// Add the cookies to the client response
		response.addCookie(user_id);
		response.addCookie(f_name);
		response.addCookie(l_name);
		response.addCookie(pic);

		/*
		 * Add the new tweet entity message repo to the datastore associated with the
		 * GCP project and maintain the returned key for the new tweet entity in the
		 * tweet_key variable
		 */
		GAEDatastore.put(message);

		// get tweet id from datastore
		Filter userIdFilter = new FilterPredicate("user_id", FilterOperator.EQUAL, request.getParameter("user_id"));
		Filter timestampFilter = new FilterPredicate("timestamp", FilterOperator.EQUAL, timestamp);
		Query q = new Query("tweet").addSort("timestamp", SortDirection.DESCENDING).setFilter(userIdFilter)
				.setFilter(timestampFilter);
		PreparedQuery prepQ = GAEDatastore.prepare(q);
		for (Entity output : prepQ.asIterable()) {
			Long tweetId = (Long) output.getKey().getId();
			Cookie tweet_id = new Cookie("tweet_id", String.valueOf(tweetId));
			response.addCookie(tweet_id);
		}

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
