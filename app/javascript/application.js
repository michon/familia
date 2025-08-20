// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import "@hotwired/turbo-rails"
import "controllers"
import { Dropdown } from 'bootstrap'

// Inicializar dropdowns
document.addEventListener("turbo:load", () => {
  const dropdowns = document.querySelectorAll('.dropdown-toggle')
  dropdowns.forEach((toggle) => {
    new Dropdown(toggle)
  })
})
