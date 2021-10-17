import { expresion_java } from "./expresion";

export class if_java{
	instrucciones_if: any;
	instrucciones_else: any;
	else_if: any;
	condicion: expresion_java;
	linea: number;
	columna: number;


	constructor(instrucciones_if:any, instrucciones_else:any,else_if:if_java,condicion:expresion_java,linea:number,columna:number){
		this.instrucciones_if = instrucciones_if;
		this.instrucciones_else = instrucciones_else;
		this.else_if = else_if;
		this.condicion = condicion;
		this.linea = linea;
		this.columna = columna;
	}

	ejecutar(){
		return "Hola en linea "+this.linea+" y columna "+this.columna;
	}

	saludar(){
		return "Hola amiguitos";
	}
}