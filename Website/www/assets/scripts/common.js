if (!String.prototype.endsWith) {
	String.prototype.endsWith = function(search, this_len) {
		if (this_len === undefined || this_len > this.length) {
			this_len = this.length;
		}
		return this.substring(this_len - search.length, this_len) === search;
	};
}

var request = {
	start: function(method, uri, content_type, entity_body, success_handler, error_handler, headers) {
		var xhr = new XMLHttpRequest();
		xhr.open(method, uri, true);
		xhr.setRequestHeader('Accept', 'application/json');
		if (content_type != '') {
			xhr.setRequestHeader('Content-Type', content_type);
		}
		if (headers !== null) {
			for (var key in headers) {
				xhr.setRequestHeader(key, headers[key]);
			}
		}
		xhr.onreadystatechange = function() {
			if (xhr.readyState != 4) {
				return;
			}
			
			if (xhr.status < 200 || xhr.status >= 300) {
				error_handler(xhr.status, xhr.responseText);
				return;
			}
			
			var obj
			if (xhr.responseText != '') {
				obj = JSON.parse(xhr.responseText);
			} else {
				obj = {};
			}
			success_handler(obj);
		};
		xhr.send(entity_body);
	},
	get: function(uri, formdata, success_handler, error_handler, headers) {
		var query = this.encodeFormData(formdata);
		if (query != '') {
			query = '?' + query;
		}
		this.start('GET', uri + query, '', '', success_handler, error_handler, headers);
	},
	post: function(uri, formdata, success_handler, error_handler, headers) {
		this.start('POST', uri, 'application/x-www-form-urlencoded', this.encodeFormData(formdata), success_handler, error_handler, headers);
	},
	encodeFormData: function(formdata) {
		if (formdata === null) {
			return '';
		} else if (formdata === undefined) {
			return '';
		} else if (formdata.constructor === {}.constructor) {
			var pairs = [];
			for (var key in formdata) {
				pairs.push(encodeURIComponent(key) + '=' + encodeURIComponent(formdata[key]));
			}
			return pairs.join('&');
		} else {
			return '';
		}
	}
};

var dialog = {
	show: function(message, explanation, handler) {
		var overlay = document.getElementById('overlay');
		var dialog_frame = document.getElementById('dialog');
		var dialog_message = document.getElementById('dialog_message');
		var dialog_explanation = document.getElementById('dialog_explanation');
		var dialog_action_button = document.getElementById('dialog_action_button');
		var dialog_cancel_button = document.getElementById('dialog_cancel_button');
		if (overlay && dialog && dialog_message && dialog_explanation && dialog_action_button && dialog_cancel_button) {
			overlay.className = 'exist';
			dialog_frame.className = 'exist';
			setTimeout(function() {
				overlay.className = 'exist visible';
				dialog_frame.className = 'exist visible';
			}, 10);
			dialog_message.innerText = message;
			dialog_explanation.innerText = explanation;
			dialog_action_button.addEventListener('click', function(event) {
				event.target.removeEventListener(event.type, arguments.callee);
				dialog.hide(handler);
			});
			dialog_cancel_button.className = 'hidden';
			dialog_action_button.innerText = 'Ok';
		}
	},
	confirm: function(message, explanation, action_caption, cancel_caption, handler) {
		let prom = new Promise((resolve, reject) => {
			let overlay = document.getElementById('overlay');
			let dialog_frame = document.getElementById('dialog');
			let dialog_message = document.getElementById('dialog_message');
			let dialog_explanation = document.getElementById('dialog_explanation');
			let dialog_action_button = document.getElementById('dialog_action_button');
			let dialog_cancel_button = document.getElementById('dialog_cancel_button');
			if (overlay && dialog && dialog_message && dialog_explanation && dialog_action_button && dialog_cancel_button) {
				overlay.className = 'exist';
				dialog_frame.className = 'exist';
				setTimeout(function() {
					overlay.className = 'exist visible';
					dialog_frame.className = 'exist visible';
				}, 10);
				dialog_message.innerText = message;
				dialog_explanation.innerText = explanation;
				dialog_action_button.addEventListener('click', function(event) {
					event.target.removeEventListener(event.type, arguments.callee);
					dialog.hide(resolve);
				});
				dialog_cancel_button.addEventListener('click', function(event) {
					event.target.removeEventListener(event.type, arguments.callee);
					dialog.hide(reject);
				});
				dialog_cancel_button.className = '';
				dialog_action_button.innerText = action_caption;
				dialog_cancel_button.innerText = cancel_caption;
			}
		});
		
		if (handler) {
			prom.then(handler).catch(function() {});
		} else {
			return prom;
		}
	},
	hide: function(handler) {
		var overlay = document.getElementById('overlay');
		var dialog_frame = document.getElementById('dialog');
		if (overlay && dialog_frame) {
			overlay.className = 'exist';
			dialog_frame.className = 'exist';
			setTimeout(function() {
				overlay.className = '';
				dialog_frame.className = '';
				if (handler) {
					handler();
				}
			}, 300);
		}
	},
	showModal: function(id) {
		let overlay = document.getElementById('overlay');
		let modal = document.getElementById(id);
		if (overlay && modal) {
			overlay.classList.add('exist');
			modal.classList.add('exist');
			
			setTimeout(function() {
				overlay.classList.add('visible');
				modal.classList.add('visible');
			}, 10);
		}
	},
	hideModal: function(id) {
		let overlay = document.getElementById('overlay');
		let modal = document.getElementById(id);
		if (overlay && modal) {
			overlay.classList.remove('visible');
			modal.classList.remove('visible');
			
			setTimeout(function() {
				overlay.classList.remove('exist');
				modal.classList.remove('exist');
			}, 300);
		}
	}
};