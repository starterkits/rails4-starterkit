/* Load this script using conditional IE comments if you need to support IE 7 and IE 6. */

window.onload = function() {
	function addIcon(el, entity) {
		var html = el.innerHTML;
		el.innerHTML = '<span style="font-family: \'Social-Icons\'">' + entity + '</span>' + html;
	}
	var icons = {
			'sico-twitter' : '&#xf099;',
			'sico-facebook' : '&#xf09a;',
			'sico-linkedin' : '&#xf0e1;',
			'sico-github' : '&#xf09b;',
			'sico-google-plus' : '&#xf0d5;'
		},
		els = document.getElementsByTagName('*'),
		i, attr, c, el;
	for (i = 0; ; i += 1) {
		el = els[i];
		if(!el) {
			break;
		}
		attr = el.getAttribute('data-icon');
		if (attr) {
			addIcon(el, attr);
		}
		c = el.className;
		c = c.match(/sico-[^\s'"]+/);
		if (c && icons[c[0]]) {
			addIcon(el, icons[c[0]]);
		}
	}
};