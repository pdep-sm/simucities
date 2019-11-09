import bloques.*
import eventos.*

class Ciudad {
	const bloques = []
	const ppcAnteriores = [] // ppc = PBI per cápita
	const eventos = []

	method esVerde() = bloques.all{ bloque => bloque.tienePlazas() }

	method parquizar() = bloques.forEach{ bloque => bloque.parquizar() }

	method pbiPerCapita() = self.pbi() / self.poblacion()
	method pbi() = bloques.sum{ bloque => bloque.aporteEconomico() }
	method poblacion() = bloques.sum{ bloque => bloque.poblacion() }

	method economiaEstaBien() = self.pbiPerCapita() > ppcAnteriores.last() and 
								ppcAnteriores.last() > ppcAnteriores.first()

	method occurre(evento) {
		eventos.agregar(evento)
		ppcAnteriores.removeFirst()
		ppcAnteriores.add(self.pbiPerCapita())
		evento.afectar(self)
	}
	
	method afectarPoblacion(porcentaje) {
		bloques.forEach{ bloque => bloque.afectarPoblacion(porcentaje) }
		self.desdoblarBloquesHacinados()
	}
	
	method afectarEconomia(porcentaje) {
		bloques.forEach{ bloque => bloque.afectarEconomia(porcentaje) }
	}
	
	method destruirBloquesViejos(cantidad) { 
		bloques.drop(cantidad)
	}
	
	method desdoblarBloquesHacinados() {
		const hacinados = bloques.filter{ bloque => bloque.estaHacinado() }
		hacinados.forEach{ bloque => bloque.desdoblarEn(self) }
	}
	
	method ultimosBloques(cantidad) = bloques.reverse().take(cantidad)
	
	method agregar(bloque) { bloques.add(bloque) }
	
	method crearBloqueIndustrial() { 
		const promedio = self.pbi() / bloques.size()
		const nuevo = new Industrial(produccion = promedio / 1000, ciudad = self)
		self.agregar(nuevo)
	}
	
	method tieneUltimoEventoFeliz() = eventos.last().esFeliz()
	
}
