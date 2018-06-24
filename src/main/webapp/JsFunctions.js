// function jsAdRespondAdd(element) {
//     var xhttp = new XMLHttpRequest();
//     xhttp.open("POST", "MakeAdRespond", true);
//     xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
//     xhttp.send("AdId=" + element.id);
// }


//отображение откликов. Устар.
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
/*

// Разворот спойлера-пример(статичны блок)
$(document).on('click', '.spoiler-trigger', function (e) {
    $(this)
        .parent()
        .find('.spoiler-block')
        .html("<table style=\"width:100%\">\n" +
            "  <tr>\n" +
            "    <th>Firstname</th>\n" +
            "    <th>Lastname</th> \n" +
            "    <th>Age</th>\n" +
            "  </tr>\n" +
            "  <tr>\n" +
            "    <td>Jill</td>\n" +
            "    <td>Smith</td> \n" +
            "    <td>50</td>\n" +
            "  </tr>\n" +
            "  <tr>\n" +
            "    <td>Eve</td>\n" +
            "    <td>Jackson</td> \n" +
            "    <td>94</td>\n" +
            "  </tr>\n" +
            "</table>")
        .slideToggle(300);
});
*/

//переделать под слайдер с откликами под каждое АД
/*
$(document).ready(function () {
    $(".b_button_responds").click(function () {
        alert("Respind_id!:"+ $(this).closest("div.b_ad").prop("id"));
        $.post("RespondsList"
            , {AdId: $(this).closest("div.b_ad").prop("id")}
            // , function (data) {alert("::responds_list::\t"+$(this).closest("div.b_ad").prop("id"))}
            , function (data) {
                $(this)
                    .parent()
                    .find('spoiler-block')
                    .html(data);
                alert($(this)
                    .parent()
                    .find('.spoiler-block').className );
            }
        )
    });
});
*/
//Рабочий вариант.Возвращает отклики на объявление
$(function () {
    $(".b_ad").on("click", ".b_button_responds", function (event) {
        event.preventDefault();
        var parent = event.delegateTarget,
            id = parent.id,
            spoiler = $('.spoiler-block', parent),
            text = spoiler.text(),
            str = "загрузка...";
        if(text) spoiler.slideToggle(300);
        else if(text != str){
            spoiler.text(str);
            $.post("RespondsList"
                , {AdId: id}
                , function (data) { spoiler.html(data);})
        }
    })
});


//возвратает сообщение с результатом отклика
$(document).ready(function () {
    $(".b-button_right").click(function () {
        //добавляет отклик по ID обьявления
        $.post("MakeAdRespond"
            , {AdId: $(this).closest("div.b_ad").prop("id")}
            // , function (data) {alert(data)}
            , function (data) {
                $("#RespondNotice").html(data);
                // $("#RespondNotice").dialog();
                // $("#RespondNotice").delay(1000);
                $("#RespondNotice").dialog({
                    title: "Уведомление",
                    closeOnEscape: true,
                    closeText: "Закрыть",
                    dialogClass: "notification",
                    show: "slide",
                    modal: false,
                    resizable: false,
                    open: function (event, ui) {
                        setTimeout("$('#RespondNotice').dialog('close')", 1500);
                    }
                })
            }
        )

    });
});
/*
$(document).ready(function () {
    $(".b_button_responds").click(function () {

    });
});

*/