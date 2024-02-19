function hexToRgb(hex) {
  let result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  return result ? {
    r: parseInt(result[1], 16),
    g: parseInt(result[2], 16),
    b: parseInt(result[3], 16)
  } : null;
}

function componentToHex(c) {
  var hex = c.toString(16);
  return hex.length == 1 ? "0" + hex : hex;
}

function rgbToHex({red, green, blue}) {
  return "#" + componentToHex(red) + componentToHex(green) + componentToHex(blue);
}

document.addEventListener('DOMContentLoaded', () => {
  const socket = new EventSource(`${WEBSOCKET_ENDPOINT}/sse`);

  socket.addEventListener("message", (event) => {
    const message = JSON.parse(event.data);
    const color = rgbToHex(message.value);
    console.log(color, `light${message.address}`);
    const element = document.getElementById(`light${message.address}`);
    if(element !== null) {
      element.style.fill = color;
    }
    const inputElement = document.getElementById(`input-light${message.address}`);
    if(inputElement !== null) {
      inputElement.value = color;
    }
  });

  socket.addEventListener("error", (event) => {
    console.error(event);
  });
});


document.addEventListener('DOMContentLoaded', () => {
  // Functions to open and close a modal
  function openModal($el) {
    $el.showModal();
  }

  function closeModal($el) {
    $el.close();
  }

  function closeAllModals() {
    (document.querySelectorAll('dialog') || []).forEach(($modal) => {
      closeModal($modal);
    });
  }

  const $loadingModal = document.getElementById("modal-loading");
  closeModal($loadingModal);

  // Add a click event on buttons to open a specific modal
  (document.querySelectorAll('.modal-trigger') || []).forEach(($trigger) => {
    const modal = $trigger.dataset.target;
    const $target = document.getElementById(modal);

    if ($target !== null) $trigger.addEventListener('click', () => {
      openModal($target);
    });
  });

  // Add a click event on various child elements to close the parent modal
  (document.querySelectorAll('.close-modal') || []).forEach(($close) => {
    const $target = $close.closest('dialog');

    $close.addEventListener('click', () => {
      closeModal($target);
    });
  });



  // Add a click event to save colors
  (document.querySelectorAll('.save-color') || []).forEach(($trigger) => {
    const lightId = $trigger.dataset.target;
    const $input = document.getElementById(`input-light${lightId}`);
    const url = `${WEBSOCKET_ENDPOINT}/values/${lightId}`;

    $trigger.addEventListener('click', async (e) => {
      e.preventDefault();
      const color = hexToRgb($input.value);
      openModal($loadingModal)
      await fetch(url, {
        method: 'POST',
        //mode: "no-cors",
        headers: {
          'Accept': "application/json",
          'Content-Type': "application/json",
          'Authorization': `Bearer ${JWT}`
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
