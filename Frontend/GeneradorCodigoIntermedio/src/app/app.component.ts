import { Component, OnInit } from '@angular/core';
declare var require: any;
import { ElementRef } from '@angular/core';
import { asignacion_java } from 'src/assets/ts/asignacion';
import { expresion_java } from 'src/assets/ts/expresion';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { if_java } from 'src/assets/ts/if';
import { valor } from 'src/assets/ts/valor';
declare var $: any;
declare var analizador: any;

@Component({
	selector: 'app-root',
	templateUrl: './app.component.html',
	styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
	title = 'GeneradorCodigoIntermedio';
	conteo = 0;
	lis_errores = [];
	error_actual = 0;
	lis_proyectos = [];
	constructor(private elRef: ElementRef, private http: HttpClient) { }
	ngOnInit() {
		fetch("http://localhost:4200/api/Paquetes?existe=true", {
			method: "GET",
			headers: {
				'Content-Type': 'application/json',
				'Accept': 'application/json'
			}
		}).then(response => response.json()).then(data => {
			var nose = []
			for (var i = 0; i < data.hijos.length; i++) {
				nose.push(data.hijos[i]);
			}
			this.lis_proyectos = nose;
		});
	}

	realizarConexion() {
		this.http.get('http://localhost:4200/api/Texto').subscribe(data => {   // data is already a JSON object
			var texto: String = data['texto'];
			console.log(texto);
			return texto;
		});
	}

	probandoOtra() {
		this.http.get('http://localhost:4200/api/Paquetes').subscribe(data => {   // data is already a JSON object
			var texto: String = data['texto'];
			console.log(texto);
			return texto;
		});
	}

	ngAfterViewInit() {
		var proyects = [];
		var div1 = this.elRef.nativeElement.querySelector('#textarea');
		var TextAreaLineNumbersWithCanvas = function () {
			var div = div1;
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
			var ta: any = document.createElement('textarea');
			ta.setAttribute('cols', '80');
			ta.setAttribute('style', cssTextArea);
			ta.id = "texto";
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
				var valor = (this.value) ? this.value.substr(0, this.selectionStart).split("\n").length : 1;
				try {
					var canvas = this.canvasLines;
					if (canvas.height != this.clientHeight) canvas.height = this.clientHeight; // on resize
					var ctx = canvas.getContext("2d");
					ctx.fillStyle = "#222222";
					ctx.fillRect(0, 0, 42, this.scrollHeight + 1);
					ctx.fillStyle = "#808080";
					ctx.font = "15px monospace"; // NOTICE: must match TextArea font-size(11px) and lineheight(15) !!!
					var startIndex = Math.floor(this.scrollTop / 20) + 0;
					var endIndex = startIndex + Math.ceil(this.clientHeight / 20);
					for (var i = startIndex; i < endIndex; i++) {
						var suma = (i == (valor - 1)) ? ">" : "";
						var ph = 10 - this.scrollTop + (i * 20);
						ctx.font = (i == (valor - 1)) ? "20px monospace" : "15px monospace";
						var text = '' + (1 + i) + suma;  // line number
						ctx.fillStyle = (i == (valor - 1)) ? "#ffa" : "#808080";
						ctx.fillText(text, 40 - (text.length * 10), ph + 5);
					}
				}
				catch (e) { alert(e); }
			};

			ta.onscroll = function () { this.paintLineNumbers(); };
			ta.onmousedown = function () { this.mouseisdown = true; }
			ta.onmouseup = function () { this.mouseisdown = false; this.paintLineNumbers(); };
			ta.onmousemove = function () { if (this.mouseisdown) this.paintLineNumbers(); actualizar_lineas(this); };
			ta.onkeyup = function () { this.paintLineNumbers(); actualizar_lineas(this); };
			ta.onkeydown = function (e: any) {
				if (e.key == 'Tab') {
					e.preventDefault();
					var start = this.selectionStart;
					var end = this.selectionEnd;

					// set textarea value to: text before caret + tab + text after caret
					this.value = this.value.substring(0, start) +
						"\t" + this.value.substring(end);

					// put caret at right position again
					this.selectionStart =
						this.selectionEnd = start + 1;
				}
			};

			//document.getElementById("textarea").appendChild(div);
			// make sure it's painted
			console.log("llega acá");
			ta.paintLineNumbers();
			return ta;
		};
		var ejecutar = TextAreaLineNumbersWithCanvas();
		this.http.get('http://localhost:4200/api/Texto').subscribe(data => {   // data is already a JSON object
			var texto: String = data['texto'];
			ejecutar.textContent = texto;
		});
		var data = { existe: "true" };
		fetch("http://localhost:4200/api/Paquetes?existe=true", {
			method: "GET",
			headers: {
				'Content-Type': 'application/json',
				'Accept': 'application/json'
			}
		}).then(response => response.json()).then(data => {
			if (data.respuesta) {
				document.getElementById("contenedor-arbol").style.display = "none";
				document.getElementById("vacio-proyecto").style.display = "";
			} else {
				var cont = document.createElement("ul");
				var nose = []
				for (var i = 0; i < data.hijos.length; i++) {
					nose.push(data.hijos[i].nombre);
				}
				proyects = nose;
				if (data.hijos.length > 0) {
					extraerHijos(data.hijos[0], cont);
				}
				document.getElementById("contenedor-arbol").appendChild(cont);
			}
		});
		function actualizar_lineas(textarea: HTMLTextAreaElement) {
			var textLines = textarea.value.substr(0, textarea.selectionStart).split("\n");
			var currentLineNumber = textLines.length;
			var currentColumnIndex = textLines[textLines.length - 1].length;
			var visor_lineas: any = document.getElementById("visor");
			visor_lineas.textContent = "Linea: " + currentLineNumber + " Columna: " + currentColumnIndex;
		}

		function extraerHijos(data: any, padre: any) {
			if (data.directorio) {
				var li = document.createElement("li");
				var span = document.createElement("span");
				span.classList.add("caret");
				span.innerHTML = "<img width='15em' src='assets/img/folder-cerrado.png' class='folder' title='" + data.nombre + "'>" + data.nombre;
				span.innerHTML += "<img width='15em' class='nuevo-archivo' onclick='nuevo_archivo(this)' title='Nuevo archivo'>";
				span.addEventListener("click", function () {
					this.parentElement?.querySelector(".nested")?.classList.toggle("active");
					this.classList.toggle("caret-down");
					var img: any = this.querySelectorAll(".folder")[0];
					if (this.classList.contains("caret-down")) {
						img.src = "assets/img/folder-abierto.png";
						console.log("abierto");
					} else {
						img.src = "assets/img/folder-cerrado.png";
						console.log("cerrado");
					}
				});
				li.appendChild(span);
				if (data.hijos) {
					var ul2 = document.createElement("ul");
					ul2.classList.add("nested");
					for (var i = 0; i < data.hijos.length; i++) {
						extraerHijos(data.hijos[i], ul2);
					}
					li.appendChild(ul2);
				}
				padre.appendChild(li);
			} else {
				var li = document.createElement("li");
				var div = document.createElement("button");
				div.classList.add("div-archivo");
				div.textContent = data.nombre;
				div.value = data.url;
				div.onclick = (event) => {
					var el: any = event.srcElement;
					fetch("http://localhost:4200/api/Texto?archivo=" + el.value, {
						method: "GET",
						headers: {
							'Content-Type': 'application/json',
							'Accept': 'application/json'
						}
					}).then(response => response.json()).then(data => {
						document.getElementById("nombre-archivo").textContent = data.nombre;
						document.getElementById("texto").textContent = data.texto;
						$("#editando").val(el.value);
					});
				};
				li.appendChild(div);
				padre.appendChild(li);
			}
		}
	}

	extraerHijos(data: any, padre: any) {
		if (data.directorio) {
			var li = document.createElement("li");
			var span = document.createElement("span");
			span.classList.add("caret");
			span.innerHTML = "<img width='15em' src='assets/img/folder-cerrado.png' class='folder' title='" + data.nombre + "'>" + data.nombre;
			span.innerHTML += "<img width='15em' class='nuevo-archivo' onclick='nuevo_archivo(this)' title='Nuevo archivo'>";
			span.addEventListener("click", function () {
				this.parentElement?.querySelector(".nested")?.classList.toggle("active");
				this.classList.toggle("caret-down");
				var img: any = this.querySelectorAll(".folder")[0];
				if (this.classList.contains("caret-down")) {
					img.src = "assets/img/folder-abierto.png";
					console.log("abierto");
				} else {
					img.src = "assets/img/folder-cerrado.png";
					console.log("cerrado");
				}
			});
			li.appendChild(span);
			if (data.hijos) {
				var ul2 = document.createElement("ul");
				ul2.classList.add("nested");
				for (var i = 0; i < data.hijos.length; i++) {
					this.extraerHijos(data.hijos[i], ul2);
				}
				li.appendChild(ul2);
			}
			padre.appendChild(li);
		} else {
			var li = document.createElement("li");
			var div = document.createElement("button");
			div.classList.add("div-archivo");
			div.textContent = data.nombre;
			div.value = data.url;
			div.onclick = (event) => {
				var el: any = event.srcElement;

				fetch("http://localhost:4200/api/Texto?archivo=" + el.value, {
					method: "GET",
					headers: {
						'Content-Type': 'application/json',
						'Accept': 'application/json'
					}
				}).then(response => response.json()).then(data => {
					document.getElementById("nombre-archivo").textContent = data.nombre;
					document.getElementById("texto").textContent = data.texto;
					$("#editando").val(el.value);
				});
			};
			li.appendChild(div);
			padre.appendChild(li);
		}
	}
	imgClick(img: number) {
		var imagenes = document.querySelectorAll(".pestañas");
		for (let i = 0; i < imagenes.length; i++) {
			imagenes[i].classList.remove("seleccionado");
			var divs: any = imagenes[i].parentNode;
			divs.classList.remove("seleccionado-contenedor");
		}
		var lines = document.querySelectorAll(".areas");
		lines.forEach((value: any, key, parent) => {
			value.style.display = "none";
		})
		switch (img) {
			case 0:
				var i: any = document.querySelector("#codearea");
				i.classList.add("seleccionado");
				var div_padre: any = i.parentNode;
				div_padre.classList.add("seleccionado-contenedor");
				document.getElementById("area-editor").style.display = "";
				break;
			case 1:
				var i: any = document.querySelector("#c");
				i.classList.add("seleccionado");
				var div_padre: any = i.parentNode;
				div_padre.classList.add("seleccionado-contenedor");
				break;
			case 2:
				var i: any = document.querySelector("#cop");
				i.classList.add("seleccionado");
				var div_padre: any = i.parentNode;
				div_padre.classList.add("seleccionado-contenedor");
				break;
			case 3:
				var i: any = document.querySelector("#asm");
				i.classList.add("seleccionado");
				var div_padre: any = i.parentNode;
				div_padre.classList.add("seleccionado-contenedor");
				break;
			case 4:
				var i: any = document.querySelector("#reporte");
				i.classList.add("seleccionado");
				var div_padre: any = i.parentNode;
				div_padre.classList.add("seleccionado-contenedor");
				break;
			case 5:
				var i: any = document.querySelector("#errores");
				i.classList.add("seleccionado");
				var div_padre: any = i.parentNode;
				div_padre.classList.add("seleccionado-contenedor");
				document.getElementById("area-errores").style.display = "";
				break;
			default:
				break;
		}
	}
	abrir_proyecto() {
		document.getElementById("oculto").style.display = "flex";
		var ele = document.getElementById("flexible");
		ele.innerHTML = "";
		var h1 = document.createElement("h1");
		h1.textContent = "PROYECTOS DISPONIBLES";
		ele.appendChild(h1);
		var divc = document.createElement("div");
		divc.classList.add("loader");
		ele.appendChild(divc);
		fetch("http://localhost:4200/api/Paquetes?existe=true", {
			method: "GET",
			headers: {
				'Content-Type': 'application/json',
				'Accept': 'application/json'
			}
		}).then(response => response.json()).then(data => {
			var nose = []
			for (var i = 0; i < data.hijos.length; i++) {
				nose.push(data.hijos[i]);
				//extraerHijos(data.hijos[i],cont);
			}
			this.lis_proyectos = nose;
			var dvc:any = document.querySelectorAll(".loader")[0];
			setTimeout(()=>{
				dvc.style.display = "none";
				for (var i = 0; i < nose.length; i++) {
					var span = document.createElement("span");
					span.textContent = nose[i].nombre;
					span.classList.add("presionar");
					console.log(nose[i]);
					span.onclick = (event) => {
						var el: any = event.srcElement;
						var pos = 0;
						for (var j = 0; j < this.lis_proyectos.length; j++) {
							if (this.lis_proyectos[j].nombre == el.textContent) {
								pos = j;
								break;
							}
						}
						document.getElementById("contenedor-arbol").innerHTML = "";
						var cont = document.createElement("ul");
						console.log(nose[pos]);
						this.extraerHijos(nose[pos], cont);
						document.getElementById("contenedor-arbol").appendChild(cont);
						document.getElementById("oculto").style.display = "none";
					};
					ele.appendChild(span);
				}
				var spanto = document.createElement("span");
				spanto.textContent = "CERRAR";
				spanto.classList.add("cerrar");
				spanto.onclick = () => {
					document.getElementById("oculto").style.display = "none";
				};
				ele.appendChild(spanto);
			},500);
			
		});
	}

	traer(span: any) {
		console.log(span);
	}

	parsear() {
		var texto1: HTMLTextAreaElement = document.querySelector("#texto");
		if (texto1) {
			analizador.yy.expresion_java = expresion_java;
			analizador.yy.valor_java = valor;
			analizador.yy.asignacion_java = asignacion_java;
			analizador.yy.errores = [];
			analizador.yy.conteo = 0;
			var h = analizador.parse(texto1.value);
			if (this.conteo != h.conteo) {
				console.log(this.conteo);
				console.log(h.conteo);
				var nuevo_errores = [];
				for (var i = this.conteo; i < h.errores.length; i++) {
					nuevo_errores.push(h.errores[i]);
				}
				this.conteo = h.conteo;
				this.colocarErrores(texto1.value, nuevo_errores);
				this.rellenarTabla();
			}
		}
	}
	colocarErrores1(texto: String, errores: any) {
		var texta: any = document.getElementById("area-editor");
		var repe: any = document.getElementById("area-errores");
		repe.style.display = "flex";
		repe.style.flexDirection = "column";
		repe.style.overflow = "auto";
		repe.style.height = "88%";
		texta.style.display = "none";
		repe.style.display = "flex";
		var split = texto.split("\n");
		var conteo_errores = 0;
		for (var i = 0; i < split.length; i++) {
			var div = document.createElement("div");
			var acabados = true;
			var inicio_linea = 0;
			while (acabados && conteo_errores < errores.length) {
				if ((i + 1) == errores[conteo_errores].linea) {
					var cols = errores[conteo_errores].columna.split('-');
					div.innerHTML += split[i].substring(inicio_linea, parseInt(cols[0]));
					var razon = errores[conteo_errores].razon.replaceAll("'", "");
					div.innerHTML += "<span class='error' style='color:red;font-size:2em;' title='" + razon + "'>" + split[i].substring(parseInt(cols[0]), parseInt(cols[1])) + "</span>";
					inicio_linea = cols[1];
					conteo_errores++;
				} else {
					acabados = false;
				}
			}
			if (split[i].length > inicio_linea) {
				div.innerHTML += split[i].substring(inicio_linea, split[i].length);
			}
			repe.appendChild(div);
		}
	}
	colocarErrores(texto: String, errores: any) {
		this.lis_errores = errores;
		var texta: any = document.getElementById("area-editor");
		var repe1: any = document.getElementById("area-errores");
		repe1.style.display = "flex";
		repe1.style.flexDirection = "column";
		var repe: any = document.getElementById("lista-errores");
		repe.style.display = "flex";
		repe.style.flexDirection = "column";
		repe.style.overflow = "auto";
		repe.style.height = "470px";
		texta.style.display = "none";
		repe.style.display = "flex";
		repe.innerHTML = "";
		var split = texto.split("\n");
		var conteo_errores = 0;
		for (var i = 0; i < split.length; i++) {
			var div: any = document.createElement("div");
			div.style.display = "grid";
			div.style.gridTemplateColumns = "5% 95%";
			div.classList.add("linea");
			var numero: any = document.createElement("div");
			var textoin: any = document.createElement("div");
			numero.innerHTML = i + 1;
			if (errores.length > 0) {
				for (var a = 0; a < errores.length; a++) {
					if (errores[a].linea === (i + 1)) {
						numero.innerHTML += "&#9888;";
						div.style.backgroundColor = "red";
					}
				}
			}
			div.tabIndex = -1;
			div.id = "linea" + (i + 1);
			numero.style.borderRight = "2px solid white";
			numero.style.textAlign = "center";
			var cont = 0;
			for (var j = 0; j < split[i].length; j++) {
				if ('\t' == split[i].charAt(j)) {
					cont++;
				}
			}

			textoin.style.paddingLeft = "0.5em";
			textoin.style.whiteSpace = "break-spaces";
			textoin.textContent = split[i];
			div.appendChild(numero);
			div.appendChild(textoin);
			repe.appendChild(div);
		}
	}

	rellenarTabla() {
		this.imgClick(5);
		var error1 = this.lis_errores[this.error_actual];
		console.log(error1);
		var lines = document.querySelectorAll(".linea");
		lines.forEach((value: any, key, parent) => {
			value.style.backgroundColor = "transparent";
		})
		document.getElementById("no_error").textContent = (this.error_actual + 1) + " de " + this.lis_errores.length;
		document.getElementById("lexema_error").textContent = error1.valor;
		document.getElementById("tipo_error").textContent = error1.tipo;
		document.getElementById("razon_error").textContent = error1.razon;
		document.getElementById("linea_error").textContent = error1.linea;
		document.getElementById("columna_error").textContent = error1.columna;
		var line12 = "linea" + error1.linea;
		document.getElementById(line12).focus();
		document.getElementById(line12).style.backgroundColor = "red";
	}

	focusearAnterior() {
		if (this.error_actual == 0) {
			this.error_actual = this.lis_errores.length - 1;
		} else {
			this.error_actual--;
		}
		this.rellenarTabla();
	}

	focusearSiguiente() {
		if (this.error_actual == (this.lis_errores.length - 1)) {
			this.error_actual = 0;
		} else {
			this.error_actual++;
		}
		this.rellenarTabla();
	}

	focusear() {

	}
}
window.onload = () => {

};

interface prueba {
	texto: String;

}