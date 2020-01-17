import Moment from "moment";
import { extendMoment } from "moment-range";
const R = require("ramda");

const moment = extendMoment(Moment);

$(document).on("turbolinks:load", function() {
  generateDayGrid();
  fetchDayColors();
  monthToGrid();
});

function fetchDayColors() {
  let colors = [ "checkin-1", "checkin-2", "checkin-3", "checkin-4", "checkin-5"];
  $.getJSON(`/users/transactions`).then(data => {
    let points = {};
    let mapDate = [...data.income, ...data.point];
    mapDate.map(function(m) {
      let p = points[m.date];
      if (p == null) {
        points[m.date] = m;
      } else {
        p.count += m.count;
      }
    });

    Object.values(points)
      .map(d => ({ ...d, color: colors[d.count] }))
      .map(d => {
        let el = $(`div.item[data-date=${d.date}]`).removeClass(
          colors.join(" ")
        );
        if (6 > d.count > 0) {
          el.addClass(d.color);
        } else if (d.count > 5) {
          el.addClass("checkin-6");
        }
      });
  });
}
function generateDayGrid() {
  if($(window).width() < 767){
    var range = moment.range(moment().subtract(4, "month"), moment());
    
  } else {
    var range = moment.range(moment().subtract(1, "year"), moment());
  }
    const days = Array.from(range.by("day"));
    const daysByWeeks = R.splitEvery(7, days);
    const daysHTML = daysByWeeks
        .map(w => w.map(toDayDiv))
        .map(w => toWeekDiv(w));
    $("#item")
      .empty()
      .append(daysHTML);
}

function toDayDiv(m) {
  return `<div class="item ${m.format("MMMDD")}" data-date="${m.format(
    "YYYY-MM-DD"
  )}"></div>`;
}

function toWeekDiv(c) {
  return `<div class="column ">${c.join("")}</div>`;
}

function monthToGrid() {
  if($(window).width() < 767){
    var range = moment.range(moment().subtract(4, "month"), moment());
    let month = Array.from(range.by("month"));
    for (let i = 1; i < 5; i++) {
      let month01 = $(`.${month[i].format("MMM01")}`).offset().left
      $("#month").append(`<span class="month${month[i].format("M")}">${month[i].format("M")}月</span>`);
      $(`.month${month[i].format("M")}`).offset({left: month01})
    }
  }else{
    var range = moment.range(moment().subtract(1, "year"), moment());
    let month = Array.from(range.by("month"));
    for (let i = 1; i < 13; i++) {
      let month01 = $(`.${month[i].format("MMM01")}`).offset().left
      $("#month").append(`<span class="month${month[i].format("M")}">${month[i].format("M")}月</span>`);
      $(`.month${month[i].format("M")}`).offset({left: month01})
    }
  }
}