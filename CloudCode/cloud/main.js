var twilio = require('twilio')('ACa7d329d1b5c88a9b2be8674ea4b304da', 'c307a90e5205a174cc2353de8fb4fa73');

var express = require('express');
var app = express();
  
// Global app configuration section
app.use(express.bodyParser());  // Populate req.body
  
app.post('/receiveSMS', function(req, res) {
	console.log("Received a new text: " + req.body.From);
	res.send('Success');

	twilio.sendSms({
		to: req.params.phoneNumber,
		from: '+12313664054',
		body: req.params.message
	}, function(err, responseData) {
		if (err) {
			res.error(err);
		} else {
			res.success('Sent Successfully');
		}
	});
});

Parse.Cloud.define("twilioTest", function(req, res) {

	//params:
		//phoneNumber
		//message

	twilio.sendSms({
		to: req.params.phoneNumber,
		from: '+12313664054',
		body: req.params.message
	}, function(err, responseData) {
		if (err) {
			res.error(err);
		} else {
			res.success('Sent Successfully');
		}
	});

});
  
app.listen();