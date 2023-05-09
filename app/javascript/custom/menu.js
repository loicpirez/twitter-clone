// Add event listener to an element and toggle the class of another element
function addToggleListener(triggerSelector, targetSelector, toggleClass) {
    const trigger = document.querySelector(triggerSelector);
    const target = document.querySelector(targetSelector);
    trigger.addEventListener("click", (event) => {
        event.preventDefault();
        event.stopImmediatePropagation();
        target.classList.toggle(toggleClass);
    });
}

// DOMContentLoaded
document.addEventListener("turbo:load", () => {
    // Add toggle listeners for the hamburger menu and account dropdown
    addToggleListener("#hamburger", "#navbar-menu", "collapse");
    addToggleListener("#account", "#dropdown-menu", "active");
});