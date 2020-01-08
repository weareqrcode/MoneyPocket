document.addEventListener("turbolinks:load", () => {
  let url_string = window.location.href
  let url = new URL(url_string);
  let mail = url.searchParams.get('email');
  document.getElementById('inputEmail').setAttribute('value',mail) ;
})