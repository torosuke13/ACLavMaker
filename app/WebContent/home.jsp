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
  <script src="https://maps.googleapis.com/maps/api/js?v=3.exp"></script>
  
  <script>
//ユーザーの現在の位置情報を取得
navigator.geolocation.getCurrentPosition(successCallback, errorCallback);

/***** ユーザーの現在の位置情報を取得 *****/
function successCallback(position) {
  	var gl_text = "緯度：" + position.coords.latitude + "<br>";
    gl_text += "経度：" + position.coords.longitude + "<br>";
    //gl_text += "高度：" + position.coords.altitude + "<br>";
    //gl_text += "緯度・経度の誤差：" + position.coords.accuracy + "<br>";
    //gl_text += "高度の誤差：" + position.coords.altitudeAccuracy + "<br>";
    gl_text += "方角：" + position.coords.heading + "<br>";
    //gl_text += "速度：" + position.coords.speed + "<br>";
  	document.getElementById("show_result").innerHTML = gl_text;
  	
   	var map = new google.maps.Map(document.getElementById("map"));
    map.addControl(new GLargeMapControl());
    map.addControl(new GMapTypeControl());
    var latlng = new GLatLng(position.coords.latitude,position.coords.longitude);
    map.setCenter(latlng, 14, G_NORMAL_MAP);
    var marker = new GMarker(latlng);
    map.addOverlay(marker);
}

/***** 位置情報が取得できない場合 *****/
function errorCallback(error) {
  var err_msg = "";
  switch(error.code)
  {
    case 1:
      err_msg = "位置情報の利用が許可されていません";
      break;
    case 2:
      err_msg = "デバイスの位置が判定できません";
      break;
    case 3:
      err_msg = "タイムアウトしました";
      break;
  }
  document.getElementById("show_result").innerHTML = err_msg;
}
</script>

</head>
<meta charset="utf-8">
<body>
  <div class="container">
    <div class="hero-unit">
      <div class="pull-right">    
        <a href="/delete" class="btn btn-danger" title="Clear All">X</a>
      </div>
      <div class="text-center">
        <h1><a href="/">BlueMix Upload</a></h1>
        
        <p>
          <form action="/support" method="POST">
            <input type="hidden" name="support" value="support" />
            <input type="submit" class="btn" value="Support" />
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
    
    <% if (request.getAttribute("status") != null) { %>
        	  <div id="show_result"></div>
        	  <div id="map"></div>
    <% } %>
    
  </div>
</body>
</html>
