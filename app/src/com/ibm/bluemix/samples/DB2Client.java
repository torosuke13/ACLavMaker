package com.ibm.bluemix.samples;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class DB2Client {
	
	public DB2Client() {
	}
		
	public List<Spot> getSpots() throws Exception {
		String sql = "SELECT * FROM DB2INST1.TESTDATA2";
		Connection connection = null;
		PreparedStatement statement = null;
		ResultSet results = null;
		
		try {
			connection = getConnection();
			statement = connection.prepareStatement(sql);
			results = statement.executeQuery();
			List<Spot> spots = new ArrayList<Spot>();
			
			while (results.next()) {
				String name = results.getString("name");
				double latitude = results.getDouble("latitude");
				double longitude = results.getDouble("longitude");
				int ambience = results.getInt("ambience");
				int accessibility = results.getInt("accessibility");
				int calmness = results.getInt("calmness");
				int dramatic = results.getInt("dramatic");
				int openess = results.getInt("openess");
				int total = results.getInt("total");
				String comment = results.getString("name");
				
				spots.add(new Spot(name, latitude, longitude, ambience, accessibility, calmness, dramatic,	openess, total,	comment));
			}
			
			return spots;
		} finally {
			if (results != null) {
				results.close();
			}
			
			if (statement != null) {
				statement.close();
			}
			
			if (connection != null) {
				connection.close();
			}
		}
	}
	
	
	/**
	 * Delete all rows from DB2
	 * @return number of rows affected
	 * @throws Exception 
	 */
	public int deleteAll() throws Exception {
		String sql = "DELETE FROM points WHERE TRUE";
		Connection connection = null;
		PreparedStatement statement = null;
		try {
			connection = getConnection();
			statement = connection.prepareStatement(sql);
			return statement.executeUpdate();
		} finally {
			if (statement != null) {
				statement.close();
			}
			
			if (connection != null) {
				connection.close();
			}	
		}
	}
	
	private static Connection getConnection() throws Exception {
		Map<String, String> env = System.getenv();
		
		if (env.containsKey("VCAP_SERVICES")) {
			// we are running on cloud foundry, let's grab the service details from vcap_services
			JSONParser parser = new JSONParser();
			JSONObject vcap = (JSONObject) parser.parse(env.get("VCAP_SERVICES"));
			JSONObject service = null;
			
			// We don't know exactly what the service is called, but it will contain "DB2"
			for (Object key : vcap.keySet()) {
				String keyStr = (String) key;
				if (keyStr.toLowerCase().contains("sqldb")) {
					service = (JSONObject) ((JSONArray) vcap.get(keyStr)).get(0);
					break;
				}
			}
			
			if (service != null) {
				Class.forName("com.ibm.db2.jcc.DB2Driver");  
				JSONObject creds = (JSONObject) service.get("credentials");
				String user = (String) creds.get("username");
				String password = (String) creds.get("password");
				
				String url = (String) creds.get("jdbcurl");
				return DriverManager.getConnection(url, user, password);
			}
		}
		
		throw new Exception("No DB2 service URL found. Make sure you have bound the correct services to your app.");
	}
}