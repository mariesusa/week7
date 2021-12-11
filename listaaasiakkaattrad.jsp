<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link href="css/styleMyynti.css" rel="stylesheet" type="text/css">
<script src="scripts/main.js"></script>
<title>Listaa asiakkaat</title>
</head>
<body onkeydown="tutkiKey(event)">
<table id="listaus">
	<thead>
		<tr>
				<tr colspan="2" id="ilmo"></tr>
				<th><label1>Hakusana:</label1></th>
				<th colspan="2"><label1><input type="text" id="hakusana"></label1>
				<th colspan="1"><label1><input type="button" value="Hae" id="hakunappi" onclick="haeTiedot()"></label1>
				<th colspan="2"><label1><a id="uusiAsiakas" href = "lisaaasiakastrad.jsp">Lisää uusi asiakas</a></label1></th>
			
			</tr>
			<tr>
				<th><label>Etunimi</label></th>
				<th><label>Sukunimi</label></th>
				<th><label>Puhelinnumero</label></th>
				<th><label>Sähköpostiosoite</label></th>
				<th><label>Muuta</label></th>
				<th><label>Poista</label></th>
				<th></th>
		</tr>
	</thead>
	<tbody id = "tbody">
	</tbody>		
</table>
<script>
haeTiedot();
document.getElementById("hakusana").focus();//Kursori

function tutkiKey(event) {
	if (event.keyCode==13) {//Enter
		haeTiedot();
	}
}
function haeTiedot() {
		document.getElementById("tbody").innerHTML = "";
		fetch("asiakkaat/" + document.getElementById("hakusana").value, {
			method: 'GET'
		})
	.then(function (response) {
		return response.json()
	})
	.then(function (responseJson) {
		console.log(responseJson);
		var asiakkaat = responseJson.asiakkaat;
		var htmlStr="";
		for (var i = 0; i < asiakkaat.length; i++) {
			htmlStr+="<tr>";
			//htmlStr+="<td>" + asiakkaat[i].asiakas_id + "</td>";
			htmlStr+="<td>" + asiakkaat[i].etunimi + "</td>";
			htmlStr+="<td>" + asiakkaat[i].sukunimi + "</td>";
			htmlStr+="<td>" + asiakkaat[i].puhelin + "</td>";
			htmlStr+="<td>" + asiakkaat[i].sposti + "</td>";
			htmlStr+="<td><a href='muutaasiakastrad.jsp?asiakas_id="+asiakkaat[i].asiakas_id+"'>Muuta</a>&nbsp;</td>";
			htmlStr+="<td><span class='poista' onclick=poista('"+asiakkaat[i].asiakas_id+"','"+asiakkaat[i].etunimi+"','"+asiakkaat[i].sukunimi+"')>Poista</span></td>";
			htmlStr+="</tr>";
			}
			document.getElementById("tbody").innerHTML = htmlStr;
	})
}

function poista(asiakas_id, etunimi, sukunimi) {
	if (confirm("Poista asiakas " + asiakas_id + " " + etunimi + " " + sukunimi + "?")) {
		fetch("asiakkaat/" + asiakas_id, {
			method: 'DELETE'
		})
		.then (function (response) {
			return response.json()
		})
		.then(function (responseJson) {
			var vastaus = responseJson.response;
			if (vastaus == 0) {
				document.getElementById("ilmo").innerHTML = "<td2>Asiakkaan poisto epäonnistui.</td2>";
			} else if (vastaus == 1) {
				document.getElementById("ilmo").innerHTML = "<td2>Asiakkaan " + asiakas_id + " " + etunimi + " " + sukunimi + " poisto onnistui.</td2>";
				haeTiedot();
			}
			setTimeout(function() { document.getElementById("ilmo").innerHTML = ""; }, 5000);
		})
	}
}
</script>
</body>
</html>
