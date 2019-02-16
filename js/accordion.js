/*
 * Multi-Level Accordion Menu
 * =========
 * A simple CSS accordion menu with support for sub level items.
 * 
 * [Article on CodyHouse](https://codyhouse.co/gem/css-multi-level-accordion-menu)
 * 
 * [Demo](https://codyhouse.co/demo/multi-level-accordion-menu/index.html)
 * 
 * Icons: [Nucleo](https://nucleoapp.com/)
 * 
 * [Terms](https://codyhouse.co/terms/)
 * 
 */

jQuery(document).ready(function(){
	var accordionsMenu = $('.cd-accordion-menu');

	if( accordionsMenu.length > 0 ) {
		
		accordionsMenu.each(function(){
			var accordion = $(this);
			//detect change in the input[type="checkbox"] value
			accordion.on('change', 'input[type="checkbox"]', function(){
				var checkbox = $(this);
				console.log(checkbox.prop('checked'));
				( checkbox.prop('checked') ) ? checkbox.siblings('ul').attr('style', 'display:none;').slideDown(300) : checkbox.siblings('ul').attr('style', 'display:block;').slideUp(300);
			});
		});
	}
});
