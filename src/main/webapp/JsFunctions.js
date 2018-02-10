// function jsAdRespondAdd(element) {
//     var xhttp = new XMLHttpRequest();
//     xhttp.open("POST", "MakeAdRespond", true);
//     xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
//     xhttp.send("AdId=" + element.id);
// }


function jsShowResponds(element) {
    var xhttp = new XMLHttpRequest();
    xhttp.open("POST", "RespondsList", true);
    xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhttp.send("AdId=" + element.id);
    xhttp.onreadystatechange = function () { // (3)
        if (xhttp.readyState != 4) return;

        if (xhttp.status != 200) {
            alert(xhttp.status + ': ' + xhttp.statusText);
        } else {
            // alert(xhttp.responseText);
            var respTxt = xhttp.responseText.split(", ");

            var respTable;
            for (i = 0; i < respTxt.length; i += 5) {
                respTable = "<tr>"
                    + "<td>" + respTxt[i] + "</td>"
                    + "<td>" + respTxt[i + 1] + "</td>"
                    + "<td>" + respTxt[i + 2] + "</td>"
                    + "<td>" + respTxt[i + 3] + "</td>"
                    + "<td>" + respTxt[i + 4] + "</td>"
                    + "</tr>";
            }
            respTable = "<table>"
                + "<tr>"
                + "<th>username</th>"
                + "<th>user_id</th>"
                + "<th>battle_count</th>"
                + "<th>win_rate</th>"
                + "<th>own_rate</th>"
                + "</tr>"
                + respTable
                + "</table>";
            console.log(respTable);
            // var popup = open("", "Popup", "width=300,height=200");
            // var tblOk = popup.document.createElement("Table");
            // tblOk.innerHTML = respTable;
            // var aOk = popup.document.createElement("a");
            // aOk.innerHTML = "Click here";
            //
            // popup.document.body.appendChild(tblOk);
            // popup.document.body.appendChild(aOk);
            // window.document.getElementById(30)
        }
    }
    // alert("status"+xhttp.status);
    // alert("Text_LOG:"+xhttp.responseText);
    // alert("readyState"+xhttp.readyState);
}

//Разворот спойлера
$(document).on('click', '.spoiler-trigger', function (e) {
    e.preventDefault();
    $(this).toggleClass('active');
    // $(this).parent().find('.spoiler-block').first().slideToggle(300);
    $(this)
        .parent()
        .find('.spoiler-block')
        .html("SomeText")
        .slideToggle(300);

    console.log("DEBUG: " + this.parent());
});

//show id
$(document).ready(function () {
    $(".b-button_right_").click(function () {
        //добавляет отклик по ID обьявления
        $.post("MakeAdRespond"
            , {AdId: $(this).closest("div.b_ad").prop("id")}
            // , function (data) {
            //     alert(data)
            // }
        ,function (data) {
            var w = window.open('about:blank');
            w.document.open();
            w.document.write(data);
            w.document.close();

        }
        );
        // alert("id : " + $(this).closest("div.b_ad").prop("id"));
    });
});