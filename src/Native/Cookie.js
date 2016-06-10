
var _elm_lang$cookie$Native_Cookie = function() {


var get = _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {
	callback(_elm_lang$core$Native_Scheduler.succeed(document.cookie));
});


function set(options, key, value)
{
	return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback)
	{
		var str = key + '=' + encodeURIComponent(value);

		if (typeof options.path._0 !== 'undefined')
		{
			str += ';path=' + options.path._0;
		}

		if (typeof options.domain._0 !== 'undefined')
		{
			str += ';domain=' + options.domain._0;
		}

		if (typeof options.maxAge._0 !== 'undefined')
		{
			var expiration = Date.now() + options.maxAge._0;
			str += ';expires=' + new Date(expiration);
		}

		if (options.secure)
		{
			str += ';secure';
		}

		document.cookie = str;

		callback(_elm_lang$core$Native_Scheduler.succeed({ ctor: '_Tuple0' }));
	});
}

return {
	get: get,
	set: F3(set)
};

}();
