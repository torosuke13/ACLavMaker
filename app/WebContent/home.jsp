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

  
<script type="text/javascript" src="./html5jp/graph/radar.js"></script>
  
  
  <script type="text/javascript">
  	var latitude = 0.0;
  	var longitude = 0.0;
  	var message;
  	
  	function initialize() {
  		<% System.out.println("jsp:initialize"); %>
  		document.getElementById("area_name").innerHTML= '';
    	if (navigator.geolocation) {
    		navigator.geolocation.getCurrentPosition(successCallback,errorCallback);
    	} else {
    		message = "can't use Geolocation";
    		document.getElementById("area_name").innerHTML = message;
    	}
  	}
  	
  	function successCallback(pos) {
  		latitude = pos.coords.latitude;
  		longitude = pos.coords.longitude;
  		<% System.out.println("jsp:successCallback"); %>
  		<% if (request.getAttribute("status") != null && request.getAttribute("status").equals("select")) { 
  			System.out.println("jsp:mapping");%>
  			mapping();
  		<%}%>
  		<% if (request.getAttribute("status") != null && request.getAttribute("status").equals("support")) { 
  		System.out.println("jsp:supporting");%>
			supporting();
		<%}%>
  	}
  	
  	function errorCallback(error) {
  		message = "error callback";
  		document.getElementById("area_name").innerHTML = message;
  	}
  	
    function mapping() {
      	var myLatlng = new google.maps.LatLng(latitude,longitude);
      	var opts = {
        	zoom: 15,
        	center: myLatlng,
        	mapTypeId: google.maps.MapTypeId.ROADMAP
      	};
      	var map = new google.maps.Map(document.getElementById("select_map"), opts);
      	
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
      		icon: "img/icon_A.png"
      	});
        google.maps.event.addListener(marker0, 'click', function() {
        	var form0 = document.createElement('form');
            document.body.appendChild(form0);
            var input0 = document.createElement('input');
            input0.setAttribute('type', 'hidden');
            input0.setAttribute('name' , 'marker');
            input0.setAttribute('value' , '0');
            form0.appendChild(input0);
            form0.setAttribute('action', '/support');
            form0.setAttribute('method', 'post');
            form0.submit();
        });
        var Latlng1 = new google.maps.LatLng(<%=spots.get(1).latitude%>,<%=spots.get(1).longitude%>);
        var marker1 = new google.maps.Marker({
      		position: Latlng1,
      		map: map,
      		title:"<%=spots.get(1).name%>",
      		icon: "img/icon_B.png"
      	});
        google.maps.event.addListener(marker1, 'click', function() {
        	var form1 = document.createElement('form');
            document.body.appendChild(form1);
            var input1 = document.createElement('input');
            input1.setAttribute('type', 'hidden');
            input1.setAttribute('name' , 'marker');
            input1.setAttribute('value' , '1');
            form1.appendChild(input1);
            form1.setAttribute('action', '/support');
            form1.setAttribute('method', 'post');
            form1.submit();
        });
        var Latlng2 = new google.maps.LatLng(<%=spots.get(2).latitude%>,<%=spots.get(2).longitude%>);
        var marker2 = new google.maps.Marker({
      		position: Latlng2,
      		map: map,
      		title:"<%=spots.get(2).name%>",
      		icon: "img/icon_C.png"
      	});
        google.maps.event.addListener(marker2, 'click', function() {
        	var form2 = document.createElement('form');
            document.body.appendChild(form2);
            var input2 = document.createElement('input');
            input2.setAttribute('type', 'hidden');
            input2.setAttribute('name' , 'marker');
            input2.setAttribute('value' , '2');
            form2.appendChild(input2);
            form2.setAttribute('action', '/support');
            form2.setAttribute('method', 'post');
            form2.submit();
        });
        <%}%>
    }
    
    function supporting() {
      	var myLatlng = new google.maps.LatLng(latitude,longitude);
      	var opts = {
        	zoom: 16,
        	center: myLatlng,
        	mapTypeId: google.maps.MapTypeId.ROADMAP
      	};
      	var map2 = new google.maps.Map(document.getElementById("support_map"), opts);
      	
      	var mymarker2 = new google.maps.Marker({
      		position: myLatlng,
      		map: map2,
      		title:"your location"
      	});
      	
      	<%
      	if(request.getAttribute("dst_spot") != null) {
      		Spot dst_spot = (Spot) request.getAttribute("dst_spot");
        	System.out.println("dst_spot:" + dst_spot.name);
        %>
        var Latlng = new google.maps.LatLng(<%=dst_spot.latitude%>,<%=dst_spot.longitude%>);
        var marker = new google.maps.Marker({
      		position: Latlng,
      		map: map2,
      		title:"<%=dst_spot.name%>",
      	});
        <%}%>
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
            </p>
        </form>
      </div>
    </div>
    <% if (request.getAttribute("status") != null && request.getAttribute("status").equals("select")) { %>

	<table width="80%">
	  <tr>
	    <td width="30%">
	      	A : <%=spots.get(0).name%><br />
	      	オススメ度: <%=spots.get(0).total%>
	      <hr />
	      	B : <%=spots.get(1).name%><br />
	      	オススメ度: <%=spots.get(1).total%>
	      <hr />
	      	C : <%=spots.get(2).name%><br />
	      	オススメ度: <%=spots.get(2).total%>
	    </td>
	    <td width="70%">
              <div id="select_map" style="width:800px; height:600px"></div>
              <div id="area_name"></div>
	    </td>
	</table>
    <% } %>
    <% if (request.getAttribute("status") != null && request.getAttribute("status").equals("support")) { %>
    
	<table width="80%">
	  <tr>
	    <td width="30%">
	      <script>
	       var rc = new html5jp.graph.radar("sample");
               if( rc ) {
               var items = [["",
			     dst_spot.ambience,
			     dst_spot.accessibility,
			     dst_spot.calmness,
			     dst_spot.dramatic,
			     dst_spot.openess]];
               var params = {aCap: ["ambience", "accessibility", "calmness", "dramatic", "openess"]};
	       		rc.draw(items, params);
	      	}
	      </script>
	      
	    </td>
	    <td width="70%">
	      <div id="support_map" style="width:800px; height:600px"></div>
	      <div id="area_name"></div>
	    </td>
	</table>
    <% } %>
  </div>
</body>
</html>
