document.addEventListener('DOMContentLoaded', () => {

  // Get all "navbar-burger" elements
  const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

  // Add a click event on each of them
  $navbarBurgers.forEach( el => {
    el.addEventListener('click', () => {
      // Get the target from the "data-target" attribute
      if ('target' in el.dataset) {
        const target = el.dataset.target;
        const $target = document.getElementById(target);
        el.classList.toggle('is-active');
        $target.classList.toggle('is-active');
      }
    });
  });

});

document.addEventListener('DOMContentLoaded', () => {
  const $deleteElems = Array.prototype.slice.call(document.querySelectorAll('.delete'), 0);

  // Add a click event on each of them
  $deleteElems.forEach( el => {
    el.addEventListener('click', () => {
      // Get the target from the "data-target" attribute
      if ('target' in el.dataset) {
        const target = el.dataset.target;
        const $target = document.getElementById(target);
        $target.remove();
      }
    });
  });

});

