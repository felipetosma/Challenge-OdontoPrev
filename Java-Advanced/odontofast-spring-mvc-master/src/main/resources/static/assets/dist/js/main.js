
document.addEventListener('DOMContentLoaded', function() {
  const logo = document.getElementById('logo-img');
  var sidebar = document.getElementById('sidebar');
  var isMinimized = localStorage.getItem('sidebarMinimized') === 'true';
  if (isMinimized && !sidebar.classList.contains('minimized')) {
      sidebar.classList.add('minimized');
      logo.classList.add('minimized');
  }
});

document.addEventListener('DOMContentLoaded', function() {
  const toggleButton = document.getElementById('toggleSidebar');
  const sidebar = document.getElementById('sidebar');
  const logo = document.getElementById('logo-img');

  if (toggleButton && sidebar) {
      toggleButton.addEventListener('click', function() {
          sidebar.classList.toggle('minimized');
          logo.classList.toggle('minimized');
          localStorage.setItem('sidebarMinimized', sidebar.classList.contains('minimized'));
          localStorage.setItem('sidebarMinimized', logo.classList.contains('minimized'));
      });
  }
});

