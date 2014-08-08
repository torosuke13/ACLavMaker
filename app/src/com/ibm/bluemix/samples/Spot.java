package com.ibm.bluemix.samples;

public class Spot {
	String name;
	double latitude;
	double longitude;
	int ambience;
	int accessibility;
	int calmness;
	int dramatic;
	int openess;
	int total;
	String comment;
	
	Spot(String name, double latitude, double longitude, int ambience, int accessibility, int calmness, int dramatic,	int openess, int total,	String comment) {
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
	}
}
