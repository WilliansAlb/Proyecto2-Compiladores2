import { Component, OnInit } from '@angular/core';
declare var require: any;
import { ElementRef } from '@angular/core';
declare var analizador2: any;

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit{
  title = 'GeneradorCodigoIntermedio';
  constructor(private elRef: ElementRef) { }
  ngOnInit(){

  }

  ngAfterViewInit() {
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
      ta.onkeydown = function (e:any) { 
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
    console.log("ejecuta bien")
    function actualizar_lineas(textarea: HTMLTextAreaElement) {
      var textLines = textarea.value.substr(0, textarea.selectionStart).split("\n");
      var currentLineNumber = textLines.length;
      var currentColumnIndex = textLines[textLines.length - 1].length;
      var visor_lineas: any = document.getElementById("visor");
      visor_lineas.textContent = "Linea: " + currentLineNumber + " Columna: " + currentColumnIndex;
    }
  }
  imgClick(img: number) {
    var imagenes = document.querySelectorAll(".pestañas");
    for (let i = 0; i < imagenes.length; i++) {
      imagenes[i].classList.remove("seleccionado");
      var divs: any = imagenes[i].parentNode;
      divs.classList.remove("seleccionado-contenedor");
    }
    switch (img) {
      case 0:
        var i: any = document.querySelector("#codearea");
        i.classList.add("seleccionado");
        var div_padre: any = i.parentNode;
        div_padre.classList.add("seleccionado-contenedor");
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
        break;
      default:
        break;
    }
  }
  parsear(){
    var texto1: HTMLTextAreaElement = document.querySelector("#texto");
    if (texto1){
      analizador2.parse(texto1.value);
    }
  }

}
window.onload = () => {
  var toggler = document.getElementsByClassName("caret");
    var il: any;
    for (il = 0; il < toggler.length; il++) {
      var to: any = toggler[il];
      to.addEventListener("click", function () {
        this.parentElement?.querySelector(".nested")?.classList.toggle("active");
        console.log(to.parentElement.querySelector(".nested"));
        this.classList.toggle("caret-down");
        var img: any = this.querySelectorAll(".folder")[0];
        if (to.classList.contains("caret-down")) {
          img.src = "assets/img/folder-abierto.png";
          console.log("abierto");
        } else {
          img.src = "assets/img/folder-cerrado.png";
          console.log("cerrado");
        }
      });
    }
};