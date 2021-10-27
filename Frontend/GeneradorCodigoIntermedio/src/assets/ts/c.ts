export class asignacion{
	destino:String;
	valor:any;
	constructor(destino:String,valor:any){
		this.destino = destino;
		this.valor = valor;
	}
}

export class instrucciones{
	instrucciones:any;
	constructor(instrucciones:instrucciones){
		this.instrucciones = instrucciones;
	}
}

export class declaracion{
	destino:String;
	valor:any;
	tipo: any;
	constante:any;
	constructor(destino:String,valor:any,tipo:any,constante:any){
		this.destino = destino;
		this.valor = valor;
		this.tipo = tipo;
		this.constante = constante;
	}
}

export class expresion{
	operacion:String;
	numero1:any;
	numero2:any;
	constructor(operacion:String,numero1:any,numero2:any){
		this.operacion = operacion;
		this.numero1 = numero1;
		this.numero2 = numero2;
	}
}

export class operador{
	tipo:String;
	valor:any;
	dimension: any;
	constructor(tipo:String,valor:any,dimension:any){
		this.tipo = tipo;
		this.valor = valor;
		this.dimension = dimension;
	}
}

export class dimension{
	dimensiones:any;
	no_dimensiones:number;
	constructor(dimensiones:any,no_dimensiones:number){
		this.dimensiones = dimensiones;
		this.no_dimensiones = no_dimensiones;
	}
}