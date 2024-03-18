function insert_accordion_buttons() {
  let accordions = document.getElementsByClassName('accordion');
  let i = 0;
  for (let accordion_block of accordions) {
    i++;
    openCheck = "";
    let classnames = '';
    for (let blockClass of accordion_block.classList) {
    	if(blockClass != 'accordion'){
    		classnames = classnames + ' ' + blockClass;
    	}
      if(blockClass == 'accordion-open'){
    		openCheck = "checked";
    	}
    }
    accordion_block.insertAdjacentHTML('beforebegin','<input type="checkbox" class="accordion-check" id="accordion-check-' + i + '" ' + openCheck + ' /><label class="accordion-label ' + classnames +'" for="accordion-check-' + i + '"></label>');
  }
}
window.onload = function(){
  insert_accordion_buttons();
}
