import Moment from "moment";
import { extendMoment } from "moment-range";
const R = require("ramda");

const moment = extendMoment(Moment);

$(document).on("turbolinks:load", function() {
  generateDayGrid();
  fetchDayColors();
});

function fetchDayColors() {
  let colors = ["pink200", "pink175", "pink150", "pink125", "pink100"];
  $.getJSON(`/users/transactions`).then(data => {
    data
      .map(d => ({ ...d, color: colors[d.count] }))
      .map(d => {
        let el = $(`div.item[data-date=${d.date}]`).removeClass(colors.join(" "));
        if (6 > d.count > 0){
          el.addClass(d.color);
        }else if (d.count > 5){
          el.addClass("pink50");
        }
      });
  });
}

function generateDayGrid() {
  const range = moment.range(moment().subtract(1, "year"), moment());
  const days = Array.from(range.by("day"));
  const daysByWeeks = R.splitEvery(7, days);[[1, 2, 3, 4, 5, 6, 7]]
  const daysHTML = daysByWeeks.map(w => w.map(toDayDiv)).map(w => toWeekDiv(w));
  $("#point-item")
    .empty()
    .append(daysHTML);
}

function toDayDiv(m) {
  return `<div class="item" data-date="${m.format("YYYY-MM-DD")}"></div>`;
}

function toWeekDiv(c) {
  return `<div class="column">${c.join("")}</div>`;
}