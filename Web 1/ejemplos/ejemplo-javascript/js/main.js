let addCardButton = document.getElementById("addCard");
let cardContainer = document.getElementById("cardContainer");

addCardButton.addEventListener("click", function() {
    let card = document.createElement("div");
    card.className = "card";
    card.innerHTML = `<div class="card-body"><h5 class="card-title">Tarjeta de ejemplo</h5><p class="card-text">Este es un ejemplo de tarjeta.</p></div>`;
    cardContainer.appendChild(card);
});

