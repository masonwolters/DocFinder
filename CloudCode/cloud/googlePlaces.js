var baseUrl = 'https://maps.googleapis.com/maps/api/place/textsearch/json?key=AIzaSyBO4nLEFkpK6hq1ZqZ3ht4HXugLWiVUSRA';

exports.coordinateForSearch = function(searchText, callbacks) {

	Parse.Cloud.httpRequest({
		url: baseUrl + '&query=' + encodeURI(searchText),
		success: function(response) {

			var results = response.data.results;
			if (results.length > 0) {
				var first = results[0];
				
				console.log(results);
				var response = {lat: first.geometry.location.lat, 
								lng: first.geometry.location.lng,
								name: first.formatted_address};
				callbacks.success(response);

			} else {
				callbacks.error('Didn\'t Find');
			}

		},
		error: function(error) {

			console.log('GP error');
			console.log(error);
			callbacks.error('error');

		}
	});

} 

var reverseGeocodeBaseUrl = 'https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyBO4nLEFkpK6hq1ZqZ3ht4HXugLWiVUSRA';

exports.reverseGeocode = function(req, res) {
	//params
		//location - PFGeoPoint

	Parse.Cloud.httpRequest({
		url: reverseGeocodeBaseUrl + '&latlng=' + req.params.location.latitude + ',' + req.params.location.longitude,
		success: function(response) {

			if (response.data.results.length > 0) {
				var result = response.data.results[0];
				res.success(result.formatted_address);
			} else {
				res.error('No Results');
			}

		},
		error: function(error) {
			res.error('error');
		}
	})

}