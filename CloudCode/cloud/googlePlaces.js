var baseUrl = 'https://maps.googleapis.com/maps/api/place/textsearch/json?key=AIzaSyBO4nLEFkpK6hq1ZqZ3ht4HXugLWiVUSRA';

exports.coordinateForSearch = function(searchText, callbacks) {

	Parse.Cloud.httpRequest({
		url: baseUrl + '&query=' + encodeURI(searchText),
		success: function(response) {

			var results = response.data.results;
			if (results.length > 0) {
				var first = results[0];
				
				var response = {lat: first.geometry.location.lat, lng: first.geometry.location.lng};
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