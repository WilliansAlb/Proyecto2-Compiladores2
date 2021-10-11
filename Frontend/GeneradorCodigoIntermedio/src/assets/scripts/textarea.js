var TextAreaLineNumbersWithCanvas = function () {
	var div = document.getElementById("textarea");
	var cssTable = 'padding:0px 0px 0px 0px!important; margin:0px 0px 0px 0px!important; font-size:1px;line-height:0px; width:100%; height:100%;';
	var cssTd1 = 'border-right-color: #303030;border-right-style: solid;vertical-align:top; width:1px;';
	var cssTd2 = 'vertical-align:top;';
	var cssButton = 'width:120px; height:40px; border:1px solid #333 !important; border-bottom-color: #484!important; color:#ffe; background-color:#222;';
	var cssCanvas = 'border:0px; background-color:#222; margin-top:0px; padding-top:0px;';
	var cssTextArea = 'width:100%;'
		+ 'height:100%;'
		+ 'font-size:15px;'
		+ 'font-family:monospace;'
		+ 'line-height:20px;'
		+ 'font-weight:500;'
		+ 'margin: 0px 0px 0px 0px;'
		+ 'padding: 0px 0px 0px 0px;'
		+ 'resize: both;'
		+ 'color:#ffa;'
		+ 'border:0px;'
		+ 'background-color:#222;'
		+ 'white-space:nowrap; overflow:auto;'
		// supported only in opera 12.x
		+ 'scrollbar-arrow-color: #ee8;'
		+ 'scrollbar-base-color: #444;'
		+ 'scrollbar-track-color: #666;'
		+ 'scrollbar-face-color: #444;'
		+ 'scrollbar-3dlight-color: #444;' /* outer light */
		+ 'scrollbar-highlight-color: #666;' /* inner light */
		+ 'scrollbar-darkshadow-color: #444;' /* outer dark */
		+ 'scrollbar-shadow-color: #222;' /* inner dark */
		;

	// LAYOUT (table 2 panels)
	var table = document.createElement('table');
	table.setAttribute('cellspacing', '0');
	table.setAttribute('cellpadding', '0');
	table.setAttribute('style', cssTable);
	var tr = document.createElement('tr');
	var td1 = document.createElement('td');
	td1.setAttribute('style', cssTd1);
	var td2 = document.createElement('td');
	td2.setAttribute('style', cssTd2);
	tr.appendChild(td1);
	tr.appendChild(td2);
	table.appendChild(tr);

	// TEXTAREA
	var ta = this.evalnode = document.createElement('textarea');
	ta.setAttribute('cols', '80');
	ta.setAttribute('style', cssTextArea);
	//ta.value = this.S.get('eval') || '';  // get previous executed value ;)

	// TEXTAREA NUMBERS (Canvas)
	var canvas = document.createElement('canvas');
	canvas.width = 48;    // must not set width & height in css !!!
	canvas.height = 500;  // must not set width & height in css !!!
	canvas.setAttribute('style', cssCanvas);
	ta.canvasLines = canvas;
	td1.appendChild(canvas);
	td2.appendChild(ta);
	div.appendChild(table);

	// PAINT LINE NUMBERS
	ta.paintLineNumbers = function () {
		var valor = (this.value)?this.value.substr(0, this.selectionStart).split("\n").length:1;
		try {
			var canvas = this.canvasLines;
			if (canvas.height != this.clientHeight) canvas.height = this.clientHeight; // on resize
			var ctx = canvas.getContext("2d");
			ctx.fillStyle = "#222222";
			ctx.fillRect(0, 0, 42, this.scrollHeight + 1);
			ctx.fillStyle = "#808080";
			ctx.font = "15px monospace"; // NOTICE: must match TextArea font-size(11px) and lineheight(15) !!!
			var startIndex = Math.floor(this.scrollTop / 20, 0)+0;
			var endIndex = startIndex + Math.ceil(this.clientHeight / 20, 0);
			for (var i = startIndex; i < endIndex; i++) {
				var suma = (i==(valor-1))?"":"";
				var ph = 10 - this.scrollTop + (i * 20);
				ctx.font = (i==(valor-1))?"20px monospace":"15px monospace"; 
				var text = '' + (1 + i)+suma;  // line number
				ctx.fillStyle = (i==(valor-1))?"#ffa":"#808080";
				ctx.fillText(text, 40 - (text.length * 10), ph+5);
			}
		}
		catch (e) { alert(e); }
	};
	
	ta.onscroll = function (ev) { this.paintLineNumbers(); };
	ta.onmousedown = function (ev) { this.mouseisdown = true; }
	ta.onmouseup = function (ev) { this.mouseisdown = false; this.paintLineNumbers();  };
	ta.onmousemove = function (ev) { if (this.mouseisdown) this.paintLineNumbers(); actualizar_lineas(this); };
	ta.onkeyup = function (ev) { this.paintLineNumbers(); actualizar_lineas(this); };

	//document.getElementById("textarea").appendChild(div);
	// make sure it's painted
	ta.paintLineNumbers();
	return ta;
};

var ta = TextAreaLineNumbersWithCanvas();
ta.value = "%%PYTHON\ndef unafuncion(nombre,nombre2):\n\tx1 = 10\n\tx2 = 20\ndef otraFuncion():\n\tse1 = 20\n\tif 5 > 20:\n\t\tse2 = 30\n\telif 5 < 10:"+
		"\n\t\tif a > ab:\n\t\t\tse5 = 60\n\telse:\n\t\tse4 = 50\n\tfor x in range ():\n\t\tse6 = 70\n\t\tprint(\"ingresa un numero a sumar para la casilla #\",10)"+
		"\n\t\tse7 = input()\n\t\twhile a < 23:\n\t\t\tprint(\"hola\")\n%%JAVA\npublic class hola extends adios{\npublic int numero1;\n"+
		"public hola(int hola2){\n\n}\nprivate void numeros(){\nString numero2 = \"estoy probando nomas\";\nif (7>5)\n{\nint numero3 = \"estoy probando nomas\";";

var toggler = document.getElementsByClassName("caret");
var i;

for (i = 0; i < toggler.length; i++) {
  toggler[i].addEventListener("click", function() {
    this.parentElement.querySelector(".nested").classList.toggle("active");
    this.classList.toggle("caret-down");
	var img = this.getElementsByClassName("folder")[0];
	if (this.classList.contains("caret-down")){
		img.src = "assets/img/folder-abierto.png";
		console.log("abierto");
	} else {
		img.src = "assets/img/folder-cerrado.png";
		console.log("cerrado");
	}
  });
}

function actualizar_lineas(textarea){
	var textLines = textarea.value.substr(0, textarea.selectionStart).split("\n");
    var currentLineNumber = textLines.length;
    var currentColumnIndex = textLines[textLines.length-1].length;
	var visor_lineas = document.getElementById("visor");
	visor_lineas.textContent = "Linea: "+currentLineNumber+" Columna: "+currentColumnIndex;
}

function nuevo_archivo(span){
	var padre = span.parentNode;
	alert("nuevo");
}