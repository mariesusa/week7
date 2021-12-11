<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<link href="css/styleMyynti.css" rel="stylesheet" type="text/css">
<title>Muuta asiakas</title>
</head>
<body onkeydown= "tutkiKey(event)">
<form id = "tiedot">
	<table>
		<thead>
			<tr>
				<th colspan="3" id = "ilmo"></th>
				<th colspan="5"><label1><a href = "listaaasiakkaattrad.jsp" id = "takaisin">Takaisin listaukseen</a></label1></th>
			</tr>
			<tr>
				<th><label>Etunimi</label></th>
				<th><label>Sukunimi</label></th>
				<th><label>Puhelinnumero</label></th>
				<th><label>Sähköpostiosoite</label></th>
				<th><label>Muuta</label></th>
				<th></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><input type = "text" name = "etunimi" id = "etunimi"></td>
				<td><input type = "text" name = "sukunimi" id = "sukunimi"></td>
				<td><input type = "text" name = "puhelin" id = "puhelin"></td>
				<td><input type = "text" name = "sposti" id = "sposti"></td>
				<td><input type = "button" id = "tallenna" value = "Hyväksy" onclick = "vieTiedot()"></td>
			</tr>
		</tbody>
	</table>
<input type="hidden" name="asiakas_id" id="asiakas_id">
</form>
<span id = "ilmo"></span>
</body>
<script>

function tutkiKeyX(event) {
	if (event.keyCode==13) {
		vieTiedot();
	}
}

var tutkiKey = (event) => {
	if (event.keyCode == 13) {
		vieTiedot();
	}
}

document.getElementById("etunimi").focus();

var asiakas_id = requestURLParam("asiakas_id");
fetch("asiakkaat/haeyksi/" + asiakas_id, {
	method: 'GET'
})
.then(function (response) {
	return response.json()
})
.then(function (responseJson) {
	document.getElementById("asiakas_id").value = responseJson.asiakas_id;
	document.getElementById("etunimi").value = responseJson.etunimi;
	document.getElementById("sukunimi").value = responseJson.sukunimi;
	document.getElementById("puhelin").value = responseJson.puhelin;
	document.getElementById("sposti").value = responseJson.sposti;
	document.getElementById("asiakas_id").value = responseJson.asiakas_id;
});

function vieTiedot() {
	var ilmo = "";
	if (document.getElementById("etunimi").value.length<2) {
		ilmo = "Etunimi ei kelpaa!";
	} else if (document.getElementById("sukunimi").value.length<2) {
		ilmo = "Sukunimi ei kelpaa!";
	} else if (document.getElementById("puhelin").value.length<7) {
		ilmo = "Puhelinnumero ei kelpaa!";
	} else if (document.getElementById("sposti").value.length<5) {
		ilmo = "Sähköpostiosoite ei kelpaa!";
	}
	if (ilmo != "") {
		document.getElementById("ilmo").innerHTML = ilmo;
		setTimeout(function () { document.getElementById("ilmo").innerHTML = ""; }, 3000);
		return;
	}
	document.getElementById("etunimi").value = siivoa(document.getElementById("etunimi").value);
	document.getElementById("sukunimi").value = siivoa(document.getElementById("sukunimi").value);
	document.getElementById("puhelin").value = siivoa(document.getElementById("puhelin").value);
	document.getElementById("sposti").value = siivoa(document.getElementById("sposti").value);
	
	var formJsonStr = formDataToJSON(document.getElementById("tiedot"));
	console.log(formJsonStr);
	fetch("asiakkaat", {
		method: 'PUT',
		body: formJsonStr
	})
	.then( function (response) {
		return response.json();
	})
	.then( function (responseJson) {
		console.log(responseJson);
		var vastaus = responseJson.response;
		if (vastaus == 0) {
			document.getElementById("ilmo").innerHTML = "Tietojen päivitys onnistui";
		} else if (vastaus == 1) {
			document.getElementById("ilmo").innerHTML = "Tietojen päivitys onnistui";
		}
		setTimeout(function() {document.getElementById("ilmo").innerHTML = ""; }, 5000);
	});
	document.getElementById("tiedot").reset();
}
</script>
</html>