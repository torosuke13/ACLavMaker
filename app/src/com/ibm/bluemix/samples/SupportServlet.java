/*-------------------------------------------------------------------*/
/*                                                                   */
/* Copyright IBM Corp. 2013 All Rights Reserved                      */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*        NOTICE TO USERS OF THE SOURCE CODE EXAMPLES                */
/*                                                                   */
/* The source code examples provided by IBM are only intended to     */
/* assist in the development of a working software program.          */
/*                                                                   */
/* International Business Machines Corporation provides the source   */
/* code examples, both individually and as one or more groups,       */
/* "as is" without warranty of any kind, either expressed or         */
/* implied, including, but not limited to the warranty of            */
/* non-infringement and the implied warranties of merchantability    */
/* and fitness for a particular purpose. The entire risk             */
/* as to the quality and performance of the source code              */
/* examples, both individually and as one or more groups, is with    */
/* you. Should any part of the source code examples prove defective, */
/* you (and not IBM or an authorized dealer) assume the entire cost  */
/* of all necessary servicing, repair or correction.                 */
/*                                                                   */
/* IBM does not warrant that the contents of the source code         */
/* examples, whether individually or as one or more groups, will     */
/* meet your requirements or that the source code examples are       */
/* error-free.                                                       */
/*                                                                   */
/* IBM may make improvements and/or changes in the source code       */
/* examples at any time.                                             */
/*                                                                   */
/* Changes may be made periodically to the information in the        */
/* source code examples; these changes may be reported, for the      */
/* sample code included herein, in new editions of the examples.     */
/*                                                                   */
/* References in the source code examples to IBM products, programs, */
/* or services do not imply that IBM intends to make these           */
/* available in all countries in which IBM operates. Any reference   */
/* to the IBM licensed program in the source code examples is not    */
/* intended to state or imply that IBM's licensed program must be    */
/* used. Any functionally equivalent program may be used.            */
/*-------------------------------------------------------------------*/
package com.ibm.bluemix.samples;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class SupportServlet extends HttpServlet {
	
	private DB2Client db = new DB2Client();
	
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	System.out.println("Support Servlet");
        
        try {
        	if(request.getParameter("marker") != null) {
        		request.setAttribute("status","support");
        	}
        	else {
        		List<Spot> spots = db.getSpots();

        		System.out.println("latitude:" + request.getParameter("latitude"));
        		System.out.println("longitude:" + request.getParameter("longitude"));
        		double latitude = Double.parseDouble(request.getParameter("latitude"));
        		double longitude = Double.parseDouble(request.getParameter("latitude"));
			
        		/*現在の地点から各スポットへの距離を求める*/
        		for(int i = 0; i < spots.size(); i++) {
        			//ラジアンに変換
        			double a_lat = latitude * Math.PI / 180;
        			double a_lon = longitude * Math.PI / 180;
        			double b_lat = spots.get(i).latitude * Math.PI / 180;
        			double b_lon = spots.get(i).longitude * Math.PI / 180;

        			// 緯度の平均、緯度間の差、経度間の差
        			double latave = (a_lat + b_lat) / 2;
        			double latidiff = a_lat - b_lat;
        			double longdiff = a_lon - b_lon;

        			//子午線曲率半径
        			//半径を6335439m、離心率を0.006694で設定してます
        			double meridian = 6335439 / Math.sqrt(Math.pow(1 - 0.006694 * Math.sin(latave) * Math.sin(latave), 3));    

        			//卯酉線曲率半径
        			//半径を6378137m、離心率を0.006694で設定してます
        			double primevertical = 6378137 / Math.sqrt(1 - 0.006694 * Math.sin(latave) * Math.sin(latave));     

        			//Hubenyの簡易式
        			double x = meridian * latidiff;
        			double y = primevertical * Math.cos(latave) * longdiff;

        			spots.get(i).distance = (int) Math.sqrt(Math.pow(x,2) + Math.pow(y,2));
        			System.out.println(i + ":dis:" + spots.get(i).distance);
        		}
			
        		/*距離によってspotsをソーティング（単純選択法）*/
        		for(int i = 0; i < spots.size() -1; i++) {
        			int min_index = i;
        			int min_dis = spots.get(i).distance;
        			for(int j = i + 1; j < spots.size(); j++) {
        				if(spots.get(j).distance < min_dis) {
        					min_dis = spots.get(j).distance;
        					min_index = j;
        				}
        			}
        			Spot min_spot = spots.get(min_index);
        			spots.set(min_index, spots.get(i));
        			spots.set(i, min_spot);
        		}
			
        		request.setAttribute("spots", spots);
        		request.setAttribute("status", "select");
        	}
		} catch (Exception e) {
			request.setAttribute("msg", e.getMessage());
			request.setAttribute("spots", new ArrayList<Spot>());
			e.printStackTrace(System.err);
		}
        
    	response.setContentType("text/html");
        response.setStatus(200);
        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }
}