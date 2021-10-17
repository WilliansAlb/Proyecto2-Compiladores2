import { expresion_java } from "./expresion";
import { valor } from "./valor";

export class asignacion_java{
	destino:String;
	linea:number;
	columna:number;
	tipo: String;
	expresion:expresion_java;

	constructor(destino:String,expresion:expresion_java,tipo:String,linea:number,columna:number){
		this.destino = destino;
		this.expresion = expresion;
		this.tipo = tipo;
		this.linea = linea;
		this.columna = columna;
	}

	ejecutar(){
		var resultado:any = this.expresion.ejecutar();
		console.log(resultado.valor);
	}
}