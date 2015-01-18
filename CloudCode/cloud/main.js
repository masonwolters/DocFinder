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

	var query = new Parse.Query(Parse.Object.extend('Issue'));
	query.equalTo('phoneNumber', req.body.From);
	query.include('clinic');
	query.find({
		success: function(issues) {
			if (issues.length > 0) {
				handleResponseToExistingIssue(req, res, issues[0]);
			} else {
				handleResponseToNewIssue(req, res);
			}
		},
		error: function(error) {
			twilioSendError(req.body.From, 'Error Querying for Issues');
			res.end('error');
		}
	});
	
});

function handleResponseToNewIssue(req, res) {
	googlePlaces.coordinateForSearch(req.body.Body, {
		success: function(place) {

			clinicsNearRadiusOfLatLng(place.lat, place.lng, 200, {
				success: function(clinics) {

					var response;

					if (clinics.length > 0) {
						var clinic = clinics[0];
						response = textResponseForClinic(clinic, place);

						var geoPoint = new Parse.GeoPoint({latitude: place.lat, longitude: place.lng});

						console.log('geoPoint: '+geoPoint);
						var Issue = Parse.Object.extend('Issue');
						var issue = new Issue();
						issue.set('clinic', clinic);
						issue.set('location', geoPoint);
						issue.set('locationName', place.name);
						issue.set('phoneNumber', req.body.From);
						issue.set('date', new Date());
						console.log('should save issue');
						issue.save(null, {
							success: function(object) {
								console.log('saved new issue');
							    res.end('success');

							},
							error: function(error) {
								console.log('error saving new issue');
								console.log(error);
							}
						});

						// pushToClinic(clinic, 'New issue', {
						// 	success: function() {

						// 	},
						// 	error: function(error) {

						// 	}
						// });
					} else {
						//No Clinics Found
						response = 'No clinics found within radius of: ' + place.name;
					}

					twilio.sendSms({
						to: req.body.From,
						from: '+12313664054',
						body: response
					}, function(err, responseData) {
						
					});


				},
				error: function(error) {
					twilio.sendSms({
						to: req.body.From,
						from: '+12313664054',
						body: 'An error occured when fetching clinics near your location'
					}, function(err, responseData) {
						res.end('something');
					});
				}
			});	
		},
		error: function(error) {
			twilioSendError(req.body.From, 'Couldn\'t get location from input');
		}
	});
}

function handleResponseToExistingIssue(req, res, issue) {

	var Message = Parse.Object.extend('Message');
	var message = new Message();
	message.set('text', req.body.Body);
	message.set('issue', issue);
	message.set('phoneNumber', req.body.From);
	message.set('date', new Date());
	message.save(null, {
		success: function(savedMessage) {
			issue.set('lastMessage', savedMessage);
			issue.set('date', new Date());
			issue.save();

			pushToClinic(issue.get('clinic'), req.body.Body, {
				success: function() {

				},
				error: function(error) {

				}
			});
			res.end('');
		},
		error: function(error) {
			twilioSendError(req.body.From, 'Error saving message. Try again.');
			res.end('');
		}
	});

}

function pushToClinic(clinic, message, callbacks) {

	console.log('push to clinic: ' + clinic.get('name'));

	var query = new Parse.Query(Parse.Installation);

	var doctorQuery = new Parse.Query(Parse.User);
	doctorQuery.equalTo('clinic', clinic);
	query.matchesQuery('doctor', doctorQuery);

	Parse.Push.send({
		where: query,
		data: {
		  aps: {
		  	alert: message
		  }
		}
	}, {
		success: function() {
		  // Push was successful
			callbacks.success();
		},
		error: function(error) {
			callbacks.error(error);
		}
	});

}

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

	var template = 'The closest clinic to <%= userLocationName %> is: <%= clinicName %>, located at: <%= clinicLocationName %>. It is <%= distance %> km away. Reply to message this clinic.';

	var userGeoPoint = new Parse.GeoPoint({latitude: gpInfo.lat, longitude: gpInfo.lng});
	var distance = userGeoPoint.kilometersTo(clinic.get('location'));

	return _.template(template, {
		userLocationName: gpInfo.name,
		clinicName: clinic.get('name'),
		clinicLocationName: clinic.get('locationName'),
		distance: distance.toFixed(1)
	});
}

function twilioSendError(phoneNumber, message) {
	twilio.sendSms({
		to: phoneNumber,
		from: '+12313664054',
		body: message
	});
}
  
app.listen();




















