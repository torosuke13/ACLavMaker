<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Upload</title>
  <link href="/css/bootstrap.css" rel="stylesheet">
  <style>
    .hero-unit {
      margin-top: 60px;
    }
  </style>
  <script src="/js/bootstrap.min.js"></script>
  <script type="text/javascript"
      src="http://maps.googleapis.com/maps/api/js?key=AIzaSyD2wBM0eTo5GqhQpmujouK-Jbv-zKlY-cI&sensor=true">
  </script>
  
  <script type="text/javascript">
  	var message;
  	
  	function initialize() {
  		document.getElementById("area_name").innerHTML= '位置情報取得します';
    	if (navigator.geolocation) {
    		navigator.geolocation.getCurrentPosition(successCallback,errorCallback);
    	} else {
    		message = "本ブラウザではGeolocationが使えません";
    		document.getElementById("area_name").innerHTML = message;
    	}
  	}
  	
  	function successCallback(pos) {
  		mapping(pos.coords.latitude,pos.coords.longitude);
  	}
  	
  	function errorCallback(error) {
  		message = "位置情報が許可されていません";
  		document.getElementById("area_name").innerHTML = message;
  	}
  	
    function mapping(x,y) {
      	var myLatlng = new google.maps.LatLng(x,y);
      	var opts = {
        	zoom: 15,
        	center: myLatlng,
        	mapTypeId: google.maps.MapTypeId.ROADMAP
      	};
      	var map = new google.maps.Map(document.getElementById("map_canvas"), opts);
      	var marker = new google.maps.Marker({
      		position: myLatlng,
      		map: map,
      		title:"Your position"
      	});
    }
    </script>
    


</head>
<meta charset="utf-8">
<body onload="initialize()">
  <div class="container">
    <div class="hero-unit">
      <div class="text-center">
        <h1><a href="/">ACLav Maker</a></h1>
        
        <p>
          <form action="/support" method="POST">
            <input type="hidden" name="support" value="support" />
            <input type="submit" class="btn" value="Support" />
          </form>
        </p>
        
        <p>
          <form action="/add" method="POST">
          	<input type="text" name="name" value="name" />
            <input type="text" name="latitude" value="latitude" />
            <input type="text" name="longitude" value="longitude" />
            <input type="submit" class="btn" value="add" />
          </form>
        </p>
        
        <% if (request.getAttribute("msg") != null) { %>
        	  <div class="alert alert-info"><%= request.getAttribute("msg") %></div>
        <% } %>
      </div>
    </div>
    <div>
      <table class="table">
      <% 
         java.util.List<String> posts = (java.util.List<String>) request.getAttribute("posts");
         if (posts == null) {
        	 posts = new ArrayList<String>();
         }
         for (String post : posts) {
      %>
        	<tr><td><%= post %></td></tr>
      <% } %>
      </table>
    </div>
    
    <% if (request.getAttribute("status") != null && request.getAttribute("status").equals("select")) { %>
        	  <div id="map_canvas" style="width:500px; height:300px"></div>
        	  <div id="area_name"></div>
    <% } %>
    
  </div>
</body>
</html>
