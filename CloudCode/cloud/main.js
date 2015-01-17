var twilio = require('twilio')('ACa7d329d1b5c88a9b2be8674ea4b304da', 'c307a90e5205a174cc2353de8fb4fa73');
var googlePlaces = require('cloud/googlePlaces.js');
var _ = require('underscore');

var express = require('express');
var app = express();

// Global app configuration section
app.use(express.bodyParser());  // Populate req.body
  
app.post('/receiveSMS', function(req, res) {
	console.log("Received a new text: " + req.body.From + '. Message: ' + req.body.Body);
	console.log(req.body);

	googlePlaces.coordinateForSearch(req.body.Body, {
		success: function(place) {

			clinicsNearRadiusOfLatLng(place.lat, place.lng, 200, {
				success: function(clinics) {

					var response;

					if (clinics.length > 0) {
						var clinic = clinics[0];
						response = textResponseForClinic(clinic, place);
					} else {
						//No Clinics Found
						response = 'No clinics found within radius of: ' + place.name;
					}

					twilio.sendSms({
						to: req.body.From,
						from: '+12313664054',
						body: response
					}, function(err, responseData) {
						res.send('something');
					});

				},
				error: function(error) {
					twilio.sendSms({
						to: req.body.From,
						from: '+12313664054',
						body: 'An error occured when fetching clinics near your location'
					}, function(err, responseData) {
						res.send('something');
					});
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
	query.withinKilometers('location', geoPoint, radius);

	query.find({
		success: function(results) {
			callbacks.success(results);
		},
		error: function(error) {
			callbacks.error(error);
		}
	});
}

function textResponseForClinic(clinic, gpInfo) {
	//gpInfo is what is returned from googlePlaces.coordinateForSearch

	var template = 'The closest clinic to <%= userLocationName %> is: <%= clinicName %>, located at: <%= clinicLocationName %>. It is <%= distance %> km away.';

	var userGeoPoint = new Parse.GeoPoint({latitude: gpInfo.lat, longitude: gpInfo.lng});
	var distance = userGeoPoint.kilometersTo(clinic.get('location'));

	return _.template(template, {
		userLocationName: gpInfo.name,
		clinicName: clinic.get('name'),
		clinicLocationName: clinic.get('locationName'),
		distance: distance.toFixed(1)
	});
}
  
app.listen();




















