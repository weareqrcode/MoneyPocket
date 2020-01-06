// import $ from "jquery";

// let url = location.href;
// url.searchParams.get('email');
// console.log($_GET['email']);
// document.location('http://localhost:3000/users/sign_in');
// $('#user_email').attr('value',url)

// function processFormData() {
//   const emailElement = document.getElementById("email");
//   // const email = emailElement.value;
//   const email = form.elements.email.value;
//   console.log(email);
// }

let url_string = window.location.href
let url = new URL(url_string);
let c = url.searchParams.get('email');
console.log(c);
document.getElementById('inputEmail').setAttribute('value',c) ;