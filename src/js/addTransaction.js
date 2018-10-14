document.body.onload = addTransaction;

function addTransaction (ID, condition, weaponType, currentOwner, price) {
  console.log("addElement is called")

  // create a new div element
  var newDiv = document.getElementsByTagName("tbody")[0];
  // and give it some content
  var newTr = document.createElement("tr");

  var newTd1 = document.createElement("th");
  var newContent1 = document.createTextNode(ID);
  newTd1.appendChild(newContent1);

  var newTd2 = document.createElement("th");
  var newContent2 = document.createTextNode(condition);
  newTd2.appendChild(newContent2);

  var newTd3 = document.createElement("th");
  var newContent3 = document.createTextNode(weaponType);
  newTd3.appendChild(newContent3);

  var newTd4 = document.createElement("th");
  var newContent4 = document.createTextNode(currentOwner);
  newTd4.appendChild(newContent4);

  var newTd5 = document.createElement("th");
  var newContent5 = document.createTextNode(price);
  newTd5.appendChild(newContent5);

  // add the text node to the newly created div
  newTr.appendChild(newTd1);
  newTr.appendChild(newTd2);
  newTr.appendChild(newTd3);
  newTr.appendChild(newTd4);
  newTr.appendChild(newTd5);


  // add the newly created element and its content into the DOM
  newDiv.appendChild(newTr);
}
