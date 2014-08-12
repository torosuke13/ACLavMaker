<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.ibm.bluemix.samples.Spot" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>ACLav Maker</title>
  <link href="/css/bootstrap.css" rel="stylesheet">
  <style>
    .hero-unit {
      margin-top: 60px;
    }
  </style>
   <style type="text/css">
   .labels {
     color: red;
     background-color: white;
     font-family: "Lucida Grande", "Arial", sans-serif;
     font-size: 10px;
     font-weight: bold;
     text-align: center;
     width: 40px;     
     border: 2px solid black;
     white-space: nowrap;
   }
 </style>
  <script src="/js/bootstrap.min.js"></script>
  <script type="text/javascript"
      src="http://maps.googleapis.com/maps/api/js?key=AIzaSyD2wBM0eTo5GqhQpmujouK-Jbv-zKlY-cI&sensor=true">
  </script>
  
  <script type="text/javascript">
  	var latitude = 0.0;
  	var longitude = 0.0;
  	var message;
  	
  	function initialize() {
  		<% System.out.println("jsp:initialize"); %>
  		document.getElementById("area_name").innerHTML= '位置情報取得します';
    	if (navigator.geolocation) {
    		navigator.geolocation.getCurrentPosition(successCallback,errorCallback);
    	} else {
    		message = "本ブラウザではGeolocationが使えません";
    		document.getElementById("area_name").innerHTML = message;
    	}
  	}
  	
  	function successCallback(pos) {
  		latitude = pos.coords.latitude;
  		longitude = pos.coords.longitude;
  		<% System.out.println("jsp:successCallback"); %>
  		<% if (request.getAttribute("status") != null && request.getAttribute("status").equals("select")) { %>
  			mapping();
  		<%}%>
  		<% if (request.getAttribute("status") != null && request.getAttribute("status").equals("support")) { %>
			supporting();
		<%}%>
  	}
  	
  	function errorCallback(error) {
  		message = "位置情報が許可されていません";
  		document.getElementById("area_name").innerHTML = message;
  	}
  	
    function mapping() {
    	<% System.out.println("jsp:mapping"); %>
      	var myLatlng = new google.maps.LatLng(latitude,longitude);
      	var opts = {
        	zoom: 15,
        	center: myLatlng,
        	mapTypeId: google.maps.MapTypeId.ROADMAP
      	};
      	var map = new google.maps.Map(document.getElementById("map_canvas"), opts);
      	
      	var mymarker = new google.maps.Marker({
      		position: myLatlng,
      		map: map,
      		title:"your location"
      	});
      	
      	<%
        java.util.List<Spot> spots = (java.util.List<Spot>) request.getAttribute("spots");
        if (spots == null) {
       	 spots = new ArrayList<Spot>();
        }
        System.out.println("spots size:" + spots.size());
        %>
        <% if(spots.size() >= 3) {%>
        var Latlng0 = new google.maps.LatLng(<%=spots.get(0).latitude%>,<%=spots.get(0).longitude%>);
        var marker0 = new google.maps.Marker({
      		position: Latlng0,
      		map: map,
      		titleContent:"<%=spots.get(0).name%>",
      		labelContent: "A",
      	   	labelAnchor: new google.maps.Point(3, 30),
      	   	labelClass: "labels", // the CSS class for the label
      	  	labelStyle: {opacity: 0.75}
      	});
        google.maps.event.addListener(marker0, 'click', function() {
        	<%request.setAttribute("status","support");%>
        });
        var Latlng1 = new google.maps.LatLng(<%=spots.get(1).latitude%>,<%=spots.get(1).longitude%>);
        var marker1 = new google.maps.Marker({
      		position: Latlng1,
      		map: map,
      		title:"<%=spots.get(1).name%>",
      		labelContent: 'B',
      		labelAnchor: new google.maps.Point(3, 30),
          	labelClass: "labels", // the CSS class for the label
          	labelStyle: {opacity: 0.75}
      	});
        google.maps.event.addListener(marker1, 'click', function() {
        	<%request.setAttribute("status","support");%>
        });
        var Latlng2 = new google.maps.LatLng(<%=spots.get(2).latitude%>,<%=spots.get(2).longitude%>);
        var marker2 = new google.maps.Marker({
      		position: Latlng2,
      		map: map,
      		title:"<%=spots.get(2).name%>",
      		labelContent: 'C',
      		labelAnchor: new google.maps.Point(3, 30),
          	labelClass: "labels", // the CSS class for the label
          	labelStyle: {opacity: 0.75}
      	});
        google.maps.event.addListener(marker2, 'click', function() {
        	<%request.setAttribute("status","support");%>
        });
        <%}%>
    }
    
    function supporting() {
    	<% System.out.println("jsp:supporting"); %>
      	var myLatlng = new google.maps.LatLng(latitude,longitude);
      	var opts = {
        	zoom: 15,
        	center: myLatlng,
        	mapTypeId: google.maps.MapTypeId.ROADMAP
      	};
      	var map = new google.maps.Map(document.getElementById("map_canvas"), opts);
      	
      	var mymarker = new google.maps.Marker({
      		position: myLatlng,
      		map: map,
      		title:"your location"
      	});
      	
      	<%
        java.util.List<Spot> spots2 = (java.util.List<Spot>) request.getAttribute("spots");
        if (spots == null) {
       	 spots = new ArrayList<Spot>();
        }
        System.out.println("spots size:" + spots.size());
        for (int i = 0; i < spots.size(); i++) {
        %>
        var Latlng<%=i%> = new google.maps.LatLng(<%=spots.get(i).latitude%>,<%=spots.get(i).longitude%>);
        var marker<%=i%> = new google.maps.Marker({
      		position: Latlng<%=i%>,
      		map: map,
      		title:"<%=spots.get(i).name%>"
      	});
        google.maps.event.addListener(marker<%=i%>, 'click', function() {
            var request = {
            		origin: myLatlng,
            		destination: Latlng<%=i%>,
            		travelMode: google.maps.TravelMode.WALKING
            };
            directionsService.route(request, function(result, status) {
            	if (status == google.maps.DirectionsStatus.OK) {
            		directionsDisplay.setDirections(result);
            	}
            });
        	<%request.setAttribute("status","support");%>
        });
            
        <%
        }
        %>
    }
    
    function get_javascript_variable(){
        document.forms['input_form'].elements['latitude'].value = latitude;
        document.forms['input_form'].elements['longitude'].value = longitude;
    }
    </script>
</head>
<meta charset="utf-8">
<body onload="initialize()">
  <div class="container">
    <div class="hero-unit">
      <div class="text-center">
        <h1><a href="/">ACLav Maker</a></h1>
        
        <% if (request.getAttribute("msg") != null) { %>
        	  <div class="alert alert-info"><%= request.getAttribute("msg") %></div>
        <% } %>
        <form name ="input_form" action="/support" method="post" onsubmit="get_javascript_variable()">
            <p>
                <input type="submit" value="Support" />
                <input type="hidden" name="latitude" value="" />
                <input type="hidden" name="longitude" value="" />
                <input type="hidden" name="test" value="testdesu" />
            </p>
        </form>
      </div>
    </div>
    
    <% if (request.getAttribute("status") != null && request.getAttribute("status").equals("select")) { %>
        	  <div id="map_canvas" style="width:800px; height:600px"></div>
        	  <div id="area_name"></div>
    <% } %>
    <% if (request.getAttribute("status") != null && request.getAttribute("status").equals("support")) { %>
        	  <div id="map_canvas" style="width:800px; height:600px"></div>
        	  <div id="directionsPanel" style="float:right;width:300px; height:300px"></div>
        	  <div id="area_name"></div>
    <% } %>
    
  </div>
</body>
</html>
