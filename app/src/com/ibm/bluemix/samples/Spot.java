package com.ibm.bluemix.samples;

public class Spot {
	public String name;
	public double latitude;
	public double longitude;
	public int ambience;
	public int accessibility;
	public int calmness;
	public int dramatic;
	public int openess;
	public int total;
	public String comment;
	public int distance;
	
	Spot(String name, double latitude, double longitude, int ambience, int accessibility, int calmness, int dramatic, int openess, int total, String comment) {
		this.name = name;
		this.latitude = latitude;
		this.longitude = longitude;
		this.ambience = ambience;
		this.accessibility = accessibility;
		this.calmness = calmness;
		this.dramatic = dramatic;
		this.openess = openess;
		this.total = total;
		this.comment = comment;
		this.distance = -1;
	}
	
	Spot() {
		this.name = "default";
		this.latitude = 0.0;
		this.longitude = 0.0;
		this.ambience = 0;
		this.accessibility = 0;
		this.calmness = 0;
		this.dramatic = 0;
		this.openess = 0;
		this.total = 0;
		this.comment = "default";
		this.distance = -1;
	}
	
	String getLatitudeS() {
		return String.valueOf(latitude);
	}
	String getLongitudeS() {
		return String.valueOf(longitude);
	}
}
