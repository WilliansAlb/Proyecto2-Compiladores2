export class valor{
	valor:any;
	tipo:String;
	linea: number;
	columna: number;

	constructor(valor:any,tipo:String,linea:number,columna:number){
		this.valor = valor;
		this.tipo = tipo;
		this.linea = linea;
		this.columna = columna;
	}
}