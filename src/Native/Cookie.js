
var _elm_lang$cookie$Native_Cookie = function() {


var get = _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {
	callback(_elm_lang$core$Native_Scheduler.succeed(document.cookie));
});


function set(string)
{
	return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback)
	{
		document.cookie = string;
		callback(_elm_lang$core$Native_Scheduler.succeed({ ctor: '_Tuple0' }));
	});
}

return {
	get: get,
	set: set
};

}();
