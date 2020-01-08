document.addEventListener("turbolinks:load", () => {
  let url_string = window.location.href
  let url = new URL(url_string);
  let c = url.searchParams.get('email');
  console.log(c);
  document.getElementById('inputEmail').setAttribute('value',c) ;
})