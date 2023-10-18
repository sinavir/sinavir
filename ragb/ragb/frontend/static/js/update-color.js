function hexToRgb(hex) {
  let result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  return result ? {
    r: parseInt(result[1], 16),
    g: parseInt(result[2], 16),
    b: parseInt(result[3], 16)
  } : null;
}

document.addEventListener('DOMContentLoaded', () => {
  const socket = new WebSocket(WEBSOCKET_ENDPOINT);

  socket.addEventListener("message", (event) => {
    const message = JSON.parse(event.data);
    const element = document.getElementById(`light${message.id}`);
    if(element !== null) {
      element.style.fill = message.html_color;
    }
    const inputElement = document.getElementById(`light${message.id}`);
    if(inputElement !== null) {
      inputElement.value = message.html_color;
    }
  });

  socket.addEventListener("close", (event) => {
    bulmaToast.toast({ duration: 6000, message: `La fonction de mise à jour automatique des couleurs s'est arrêtée. Rechargez la page pour la relancer.\n\nCode: ${event.code}` });
  });

  socket.addEventListener("error", (event) => {
    console.log(event);
  });
});

document.addEventListener('DOMContentLoaded', () => {
  // Functions to open and close a modal
  function openModal($el) {
    $el.classList.add('is-active');
  }

  function closeModal($el) {
    $el.classList.remove('is-active');
  }

  function closeAllModals() {
    (document.querySelectorAll('.modal') || []).forEach(($modal) => {
      closeModal($modal);
    });
  }

  // Add a click event on buttons to open a specific modal
  (document.querySelectorAll('.js-modal-trigger') || []).forEach(($trigger) => {
    const modal = $trigger.dataset.target;
    const $target = document.getElementById(modal);

    if ($target !== null) $trigger.addEventListener('click', () => {
      openModal($target);
    });
  });

  // Add a click event on various child elements to close the parent modal
  (document.querySelectorAll('.modal-background, .modal-close, .modal-card-head .delete, .modal-card-foot .button') || []).forEach(($close) => {
    const $target = $close.closest('.modal');

    $close.addEventListener('click', () => {
      closeModal($target);
    });
  });
  const $loadingModal = document.getElementById("modal-loading");

  // Add a click event to save colors
  (document.querySelectorAll('.save-color') || []).forEach(($trigger) => {
    const lightId = $trigger.dataset.target;
    const $input = document.getElementById(`input-light${lightId}`);
    const url = $trigger.dataset.url;

    $trigger.addEventListener('click', async () => {
      // Get csrf token
      const cookieValue = document.cookie
        .split('; ')
        .find((row) => row.startsWith('csrftoken='))
        ?.split('=')[1];
      const color = hexToRgb($input.value);
      openModal($loadingModal)
      await fetch(url, {
        method: 'PUT',
        headers: {
          'X-CSRFToken': cookieValue,
          'Accept': "application/json",
          "Content-Type": "application/json"
        },
        body: JSON.stringify({"red": color.r, "green": color.g, "blue": color.b}),
      }).then((resp) => {
        if(!resp.ok) {
          alert(`Request failed. Err code:${resp.status}`);
        }
      }).catch((e) => {
        alert(`Request failed. Err: ${e}`);
        console.log(e);
      }).finally(() => {
        closeAllModals();
      });
    });
  });

});
