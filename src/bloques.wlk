import ciudad.*

class Bloque {
	const vecinos = []
	const ciudad
	
	method estaCeloso() = vecinos.all{ vecino => vecino.estaMejorQue(self) }
	
	method estaMejorQue(otroBloque) = 
		self.estaMejorEnEconomia(otroBloque) or self.estaMejorEnPlazas(otroBloque)
		
	method estaMejorEnEconomia(otroBloque) =
		self.aporteEconomico() > otroBloque.aporteEconomico()
		
	method estaMejorEnPlazas(otroBloque) =
		self.cantidadPlazas() > otroBloque.cantidadPlazas()
	
	method tienePlazas() = self.cantidadPlazas() > 0
	
	method esFeliz() = self.tienePlazas() and 
				self.menosPoblacionQueVecinos() and 
				not self.estaCeloso() and
				ciudad.tieneUltimoEventoFeliz()
	
	method menosPoblacionQueVecinos() = self.poblacionVecina() > self.poblacion()
	
	method poblacionVecina() = vecinos.sum{ vecino => vecino.poblacion() }
	
	method estaHacinado() = self.poblacion() > 100000
	
	method cantidadPlazas()
	
	method aporteEconomico()
	
	method poblacion()
	
	method parquizar()

	method afectarPoblacion(porcentaje)
	
	method afectarEconomia(porcentaje)
	
	method desdoblarEn(ciudad) {}
	
}


class Industrial inherits Bloque {
	const property cantidadPlazas = 0
	const property poblacion = 0
	var produccion = 0
	
	override method aporteEconomico() = produccion * 1000
	
	override method afectarEconomia(porcentaje) { 
		produccion += produccion * porcentaje / 100
	}
	
	override method parquizar(){}
	override method afectarPoblacion(porcentaje) {}
	
}


class Residencial inherits Bloque {
	var property cantidadPlazas = 0
	const property comercios = []
	var property poblacion
	
	override method aporteEconomico() = comercios.sum{ comercio => comercio.aporteEconomico() }
	
	override method parquizar() {
		cantidadPlazas += poblacion / 10000
	}
	
	override method afectarPoblacion(porcentaje) {
		poblacion += poblacion * porcentaje / 100
	}
	
	override method afectarEconomia(porcentaje) {
		comercios.forEach{ comercio => comercio.afectarEconomia(porcentaje) } 
	}
	
	override method desdoblarEn(ciudad) {
		poblacion = poblacion / 2
		const nuevo = new Residencial(poblacion = poblacion, ciudad = ciudad)
		ciudad.agregar(nuevo)
	}
}


class Comercio {
	var property aporteEconomico = 0
	
	method afectarEconomia(porcentaje) { aporteEconomico += aporteEconomico * porcentaje / 100 }
}

