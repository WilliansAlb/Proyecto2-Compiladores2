import { valor } from "./valor";

export class expresion_java{
	operacion: String;
	operador1: expresion_java;
	operador2: expresion_java;
	valor: valor;
	linea: number;
	columna: number;

	constructor(operacion:String, operador1:expresion_java, operador2:expresion_java, valor:valor,linea:number, columna:number){
		this.operacion = operacion;
		this.operador1 = operador1;
		this.operador2 = operador2;
		this.valor = valor;
		this.linea = linea;
		this.columna = columna;
	}

	ejecutar(){
		var terminoA:any = (this.operador1==null)?null:this.operador1.ejecutar();	
		var terminoB:any = (this.operador2==null)?null:this.operador2.ejecutar();	
		console.log(terminoA);
		if (this.operacion==="+"){
			var resultado:any;
			var respuesta:String;
			if ((terminoA.tipo==="int" || terminoA.tipo === "float" || terminoA.tipo ==="boolean") &&
				(terminoB.tipo==="int" || terminoB.tipo === "float" || terminoB.tipo ==="boolean")){
					respuesta = "boolean";
					respuesta = (terminoA.tipo==="int" || terminoB.tipo ==="int")?"int":respuesta;
					respuesta = (terminoA.tipo==="float" || terminoB.tipo ==="float")?"float":respuesta;
					resultado = (terminoA.tipo==="float" || terminoB.tipo ==="float")?parseFloat(terminoA.valor)+parseFloat(terminoB.valor):parseInt(terminoA.valor)+parseInt(terminoB.valor);
				} else {
					respuesta = "string";
					resultado = terminoA.valor + terminoB.valor;
				}
			return new valor(resultado,respuesta,terminoA.linea,terminoA.columna);
		} else if (this.operacion==="-"){
			var resultado:any = terminoA.valor-terminoB.valor;
			if (resultado==NaN){
				return new valor(resultado,"error",terminoA.linea,terminoA.columna);
			} else {
				return new valor(resultado,"numero",terminoA.linea,terminoA.columna);
			}
		} else if (this.operacion==="*"){
			var resultado:any;
			var respuesta:String;
			if ((terminoA.tipo==="int" || terminoA.tipo === "float" || terminoA.tipo ==="boolean") &&
				(terminoB.tipo==="int" || terminoB.tipo === "float" || terminoB.tipo ==="boolean")){
					respuesta = "boolean";
					respuesta = (terminoA.tipo==="int" || terminoB.tipo ==="int")?"int":respuesta;
					respuesta = (terminoA.tipo==="float" || terminoB.tipo ==="float")?"float":respuesta;
					resultado = (terminoA.tipo==="float" || terminoB.tipo ==="float")?parseFloat(terminoA.valor)*parseFloat(terminoB.valor):parseInt(terminoA.valor)*parseInt(terminoB.valor);
				} else {
					respuesta = "error";
					resultado = "Tipos incompatibles";
				}
			return new valor(resultado,respuesta,terminoA.linea,terminoA.columna);
		} else if (this.operacion==="/"){
			var resultado:any = terminoA.valor/terminoB.valor;
			if (resultado==NaN){
				return new valor(resultado,"error",terminoA.linea,terminoA.columna);
			} else {
				return new valor(resultado,"numero",terminoA.linea,terminoA.columna);
			}
		} else if (this.operacion==="^"){
			var resultado:any = Math.pow(terminoA.valor,terminoB.valor);
			if (resultado==NaN){
				return new valor(resultado,"error",terminoA.linea,terminoA.columna);
			} else {
				return new valor(resultado,"numero",terminoA.linea,terminoA.columna);
			}
		} else if (this.operacion === "val"){
			console.log(this.valor.valor);
			return this.valor;
		}

		return null;
	}
}