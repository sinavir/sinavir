var intervalID = window.setInterval(updateScreen, 200);
var console = document.getElementById("console");
var m = document.getElementById("main");
const msg = document.querySelector(".msg");

let txt = [
  "FORCE: XX0022. ENCYPT://000.222.2345",
  "TRYPASS: ********* AUTH CODE: ALPHA GAMMA: 1___ PRIORITY 1",
  "RETRY: REINDEER FLOTILLA",
  "Z:> /FALKEN/GAMES/TICTACTOE/ EXECUTE -PLAYERS 0",
  "================================================",
  "Priority 1 // local / scanning...",
  "scanning ports...",
  "BACKDOOR FOUND (23.45.23.12.00000000)",
  "BACKDOOR FOUND (13.66.23.12.00110000)",
  "BACKDOOR FOUND (13.66.23.12.00110044)",
  "...",
  "...",
  "RESULT OF SCAN (PLEASE READ CAREFULLY UNTIL EOF):",
  "CODE2 :",
  "B",
  "",
  "PROCHAIN INDICE :",
  "ML YBBB",
  "127 501 531 1247 1290 1958 2141 3421",
  "3810 4186 1290 4683",
  "127 3421 6550",
  "531 6584 4683 6550",
  "( compris) ",
  "EOF"
];

var txtbis = [];

function updateScreen() {
  //Shuffle the "txt" array
  let e = (txt.shift());
  //Rebuild document fragment
  let p = document.createElement("p");
  p.textContent = e;
  console.appendChild(p);
  m.scrollTop = m.scrollHeight;
}

setTimeout(() => { clearInterval(intervalID); msg.remove();}, 5000);
