
var _elm_lang$cookie$Native_Cookie = function() {


function get(targetKey)
{
	return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback)
	{
		var results = _elm_lang$core$Native_List.Nil;

		var chunks = document.cookie.split('; ');
		for (var i = 0; i < chunks.length; i++)
		{
			var chunk = chunks[i];
			var eq = chunk.indexOf('=');
			if (eq < 0)
			{
				eq = chunk.length;
			}
			var key = chunk.substr(0, eq);
			if (key === targetKey)
			{
				results = _elm_lang$core$Native_List.Cons(chunk.substr(eq + 1), results);
			}
		}

		callback(_elm_lang$core$Native_Scheduler.succeed(results));
	});
}


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

		if (typeof options.expires._0 !== 'undefined')
		{
			str += ';expires=' + options.expires._0;
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
