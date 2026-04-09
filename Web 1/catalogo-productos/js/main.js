function crearProducto() {
  const nombre = document.getElementById('nombre').value.trim();
  const precio = document.getElementById('precio').value;
  const imagen = document.getElementById('imagen').value.trim();

  if (!nombre || !precio || !imagen) {
    alert('Por favor completa todos los campos.');
    return;
  }

  const col = document.createElement('div');
  col.className = 'col-sm-6 col-md-4 col-lg-3';
  col.innerHTML = `
    <div class="card h-100 shadow-sm">
      <img src="${imagen}" class="card-img-top" alt="${nombre}" style="height:200px;object-fit:cover;">
      <div class="card-body text-center">
        <h5 class="card-title">${nombre}</h5>
        <p class="card-text text-success fw-bold">$${parseFloat(precio).toFixed(2)}</p>
      </div>
    </div>`;

  document.getElementById('productos').appendChild(col);

  document.getElementById('nombre').value = '';
  document.getElementById('precio').value = '';
  document.getElementById('imagen').value = '';
}
