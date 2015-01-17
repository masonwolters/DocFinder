var twilio = require('twilio')('ACa7d329d1b5c88a9b2be8674ea4b304da', 'c307a90e5205a174cc2353de8fb4fa73');

// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
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