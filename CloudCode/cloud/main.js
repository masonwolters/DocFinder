var twilio = require('twilio')('ACa7d329d1b5c88a9b2be8674ea4b304da', 'c307a90e5205a174cc2353de8fb4fa73');
var googlePlaces = require('cloud/googlePlaces.js');

var express = require('express');
var app = express();

// Global app configuration section
app.use(express.bodyParser());  // Populate req.body
  
app.post('/receiveSMS', function(req, res) {
	console.log("Received a new text: " + req.body.From + '. Message: ' + req.body.Body);
	console.log(req.body);

	googlePlaces.coordinateForSearch(req.body.Body, {
		success: function(coordinate) {

			// clinicsNearRadiusOfLatLng(coordinate.lat, coordinate.lng, 100, {
			// 	success: function(clinics) {

			// 		if (clinics.length > 0) {
			// 			var clinic = clinics[0];
			// 			twilio.sendSms({
			// 				to: req.body.From,
			// 				from: '+12313664054',
			// 				body: 'The closest clinic is: ' + clinic.get('name')
			// 			}, function(err, responseData) {
			// 				res.send('something');
			// 			});
			// 		} else {
			// 			//No Clinics Found
			// 			twilio.sendSms({
			// 				to: req.body.From,
			// 				from: '+12313664054',
			// 				body: 'No Clinics found within radius'
			// 			}, function(err, responseData) {
			// 				res.send('something');
			// 			});
			// 		}

			// 	},
			// 	error: function(error) {

			// 	}
			// });	

			twilio.sendSms({
				to: req.body.From,
				from: '+12313664054',
				body: 'Lat: ' + coordinate.lat + '; Lng: ' + coordinate.lng
			}, function(err, responseData) {
				if (err) {
					res.send('Error');
				} else {
					res.send('Sent Successfully');
				}
			});

		},
		error: function(error) {

			twilio.sendSms({
				to: req.body.From,
				from: '+12313664054',
				body: 'Couldn\'t get location from input'
			}, function(err, responseData) {
				if (err) {
					res.send('error');
				} else {
					res.send('Sent Successfully');
				}
			});

		}
	});
	
});

function clinicsNearRadiusOfLatLng(lat, lng, radius, callbacks) {
	var geoPoint = new Parse.GeoPoint({latitude: lat, longitude: lng});

	var query = new Parse.Query(Parse.Object.extend('Clinic'));
	query.withinMiles('location', geoPoint, radius);

	query.find({
		success: function(results) {
			callbacks.success(results);
		},
		error: function(error) {
			callbacks.error(error);
		}
	});
}
  
app.listen();