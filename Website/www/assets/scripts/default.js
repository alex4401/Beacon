'use strict';

const explore = {
	container: null,
	popover: null,
	field: null,
	link: null,
	init() {
		this.container = document.getElementById('explore_container');
		this.popover = document.getElementById('explore_popover');
		this.field = document.getElementById('explore_search_field');
		this.link = document.getElementById('menu_explore_link');
		
		this.container.addEventListener('click', function(ev) {
			explore.dismiss();
			ev.stopPropagation();
			ev.stopImmediatePropagation();
			return false;
		});
		
		this.popover.addEventListener('click', function(ev) {
			ev.stopPropagation();
			ev.stopImmediatePropagation();
			return false;
		});
		
		this.link.addEventListener('click', function(ev) {
			ev.stopPropagation();
			ev.preventDefault();
			ev.stopImmediatePropagation();
			explore.toggle();
			return false;
		});
		
		this.field.addEventListener('input', function() {
			if (this.searchTimeout) {
				clearTimeout(this.searchTimeout);
				this.searchTimeout = null;
			}
			this.searchTimeout = setTimeout(function() {
				explore.search(explore.field.value);
			}, 1000);
		});
		
		document.getElementById('explore_results_back').addEventListener('click', function() {
			explore.search('');
		});
		
		document.getElementById('explore_results_more').addEventListener('click', function() {
			window.location = explore.searchMoreURL;
		});
		
		window.addEventListener('blur', function() {
			explore.dismiss();
		});
	},
	toggle() {
		if (this.container.style.display == 'none' || this.container.style.display == '') {
			this.present();
		} else {
			this.dismiss();
		}
	},
	dismiss() {
		if (this.container.style.display == 'none') {
			return;
		}
		
		this.container.style.display = 'none';
		this.link.className = '';
		this.field.value = '';
		this.displayResults();
	},
	present() {
		if (this.container.style.display == 'block') {
			return;
		}
		
		let rect = this.link.getBoundingClientRect();
		this.popover.style.top = rect.bottom + 'px';
		this.popover.style.left = Math.max(rect.left + ((rect.width - 320) / 2), 20) + 'px';
		this.container.style.display = 'block';
		this.link.className = 'expanded';
	},
	search(terms) {
		if (!terms) {
			terms = '';
		}
		if (explore.field.value != terms) {
			explore.field.value = terms;
		}
		if (terms == '') {
			explore.displayResults();
			return;
		}
		request.get('/search/', { 'query': terms.trim(), 'count': 4 }, function(data) {
			explore.displayResults(data);
		}, function(http_status, body) {
			explore.displayResults();
		});
	},
	displayResults(data) {
		let results_container = document.getElementById('explore_results');
		let menu = document.getElementById('explore_links');
		if (data && data.results) {
			let list = document.getElementById('explore_results_list');
			
			while (list.firstChild) {
				list.removeChild(list.firstChild);
			}
			
			let results = data.results;
			let total = data.total;
			let terms = data.terms;
			if (results.length > 0) {
				menu.style.display = 'block';
				document.getElementById('explore_results_empty').style.display = 'none';
				
				for (let i = 0; i < results.length; i++) {
					let link = document.createElement('a');
					link.href = results[i].url;
					let tag = document.createElement('span');
					tag.className = 'result_type';
					tag.appendChild(document.createTextNode(results[i].type));
					link.appendChild(tag);
					link.appendChild(document.createTextNode(results[i].title));
					
					if (results[i].summary != '') {
						var preview = document.createElement('span');
						preview.className = 'result_preview';
						preview.appendChild(document.createTextNode(results[i].summary));
						link.appendChild(document.createElement("br"));
						link.appendChild(preview);
					}
					
					let node = document.createElement('li');
					if ((i % 2) == 0) {
						node.className = 'result even';
					} else {
						node.className = 'result odd';
					}
					node.appendChild(link);
					
					list.appendChild(node);
				}
			} else {
				menu.style.display = 'none';
				document.getElementById('explore_results_empty').style.display = 'block';
			}
			
			if (total > results.length) {
				document.getElementById('explore_results_right_button').style.display = 'block';
				explore.searchMoreURL = '/search/?query=' + encodeURIComponent(terms);
			} else {
				document.getElementById('explore_results_right_button').style.display = 'none';
			}
			
			results_container.style.display = 'block';
			menu.style.display = 'none';
		} else {
			results_container.style.display = 'none';
			menu.style.display = 'block';
		}
	}
};

const mobileMenu = {
	button: null,
	menu: null,
	animating: false,
	init() {
		this.button = document.querySelector('#nav_more a');
		this.menu = document.getElementById('mobile_menu');
		
		this.button.addEventListener('click', function(ev) {
			ev.stopPropagation();
			ev.preventDefault();
			ev.stopImmediatePropagation();
			this.toggleMenu();
			return false;
		}.bind(this));
	},
	showMenu() {
		this.animating = true;
		this.menu.classList.add('visible');
		this.button.classList.add('on');
		setTimeout(function() {
			this.menu.classList.add('active');
		}.bind(this), 1);
		setTimeout(function() {
			this.animating = false;
		}.bind(this), 150);
	},
	hideMenu() {
		this.animating = true;
		this.menu.classList.remove('active');
		setTimeout(function() {
			this.menu.classList.remove('visible');
			this.button.classList.remove('on');
			this.animating = false;
		}.bind(this), 150);
	},
	toggleMenu() {
		if (this.animating) {
			return;
		}
		
		if (this.menu.classList.contains('active')) {
			this.hideMenu();
		} else {
			this.showMenu();
		}
	}
};

document.addEventListener('DOMContentLoaded', function() {
	explore.init();
	mobileMenu.init();
});