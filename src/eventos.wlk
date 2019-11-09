import ciudad.*

class Evento {
	
	method esFeliz() = true
}

object cambioPoblacion inherits Evento {
	method afectar(ciudad) {
		if(ciudad.economiaEstaBien()) {
			ciudad.afectarPoblacion(5)
			ciudad.crearBloquesResidenciales()
		} else
			ciudad.afectarPoblacion(-1)
	}
}


class CrecimientoEconomico inherits Evento {
	const porcentaje
	
	method afectar(ciudad) {
		self.validar(ciudad)
		ciudad.afectarEconomia(porcentaje)
		self.crearBloqueIndustrial(ciudad)
	}
	
	method validar(ciudad) {
		if(ciudad.pbiPerCapita() <= 600)
			throw new UserException(message="La economía no puede crecer debido al PBI per cápita de la ciudad")
	}
	
	method crearBloqueIndustrial(ciudad) {
		if(ciudad.pbiPerCapita() > 1000)
			ciudad.crearBloqueIndustrial()
	}
	
}

class UserException inherits Exception {}

class CrecimientoMixto inherits Evento {
	const crecimientoEconomico
	
	method afectar(ciudad) {
		cambioPoblacion.afectar(ciudad)
		crecimientoEconomico.afectar(ciudad)	
	}
}

object desastreNatural inherits Evento {
	method afectar(ciudad) {
		ciudad.afectarPoblacion(-10)
		ciudad.destruirBloquesViejos(2)
	}
	
	override method esFeliz() = false
}



